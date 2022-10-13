# Terraform State

- production environment with multiple teams, need remote state
- avoid race condition -solution restore state remotely
- [Pros / Cons](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)

**Remote state module version changed**

```hcl
terraform init -reconfigure
```

[**Migrate state**](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-migrate)

- you must add/remove `backend blocks` before running `terraform init -migrate-state`

```hcl
terraform init -migrate-state  # pull remote state to local, if state local add to remote.
```

### [Updating Resource Names](https://blog.gruntwork.io/terraform-up-running-3rd-edition-is-now-published-4b99804d922a)

- [Move Resources](https://developer.hashicorp.com/terraform/cli/commands/state/mv)
- Any time you refactor your code, you should add a moved block to capture how the state should be updated. You can add the moved block in any .tf file in your Terraform code, though to make them easier to find, you may wish to pick a convention, such as putting all moved blocks in a moved.tf file.

```hcl
moved {
  from = aws_instance.instance
  to   = aws_instance.jenkins
}
```

### [Move, Concat, Add State](https://lgallardo.com/2019/06/25/how-to-migrate-terraform-remote-tfstates/)

- `terraform state pull > ./someFile.tfstate` # get remote/local state

### Backup State

**cloud state backup/management**

- [Getting-Started](https://learn.hashicorp.com/tutorials/terraform/aws-remote?in=terraform/aws-get-started)
- [S3](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
- terraform login //paste token when asked.
- add aws credentials to cloud

```hcl
terraform {
# terraform online storage  # Terraform versions older than 1.1 use the remote backend block else use terraform cloud
  backend "remote" {
    organization = "My-Org"  # must already exist
    workspaces {
      name = "Batch_Terraform_Workspace"  # can't already exist
    }
  }

# or aws s3 bucket
  backend "s3" {
    encrypt = true
    bucket = "terra-ptkgux"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"  # cannot be a variable
  }
  required_providers {
    aws = {
  ...
}
```

### Locking State

- local state, locking is performed by default.
- remote state
  - [Locking State Hashicorp](https://developer.hashicorp.com/terraform/language/state/locking)
  - [s3 must add DynamoDB table name](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
    - The DynomoDB table must have a partition key named `LockID` with type of `String`. If not configured, state locking will be disabled.
  - terraform cloud # automatic versioning
  - Disable locking
    - `-lock=false` Disable locking of state files during state-related operations

```hcl
# S3
terraform {
  backend "s3" {
    bucket = "terra-ptkgux"
    key    = "terraform/terraform.tfstate"
    dynamodb_table = "your dynamodb table name"  # to lock state when multiple people use it.
    region = "us-east-2"  # cannot be a variable
  }
  required_providers {
    aws = { ... }
}

# DynamoDB Example
resource "aws_dynamodb_table" "example" {
  name           = "BoB-Table-${random_pet.name.id}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID" # must be LockID or Terraform will error.

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Architect = "BoB"
    Zone      = "Ohio"
    Managed   = "Terraform"
  }
}
```

# [Force Unlock](https://developer.hashicorp.com/terraform/language/state/locking#force-unlock)

### [Terraform Cloud](https://developer.hashicorp.com/terraform/cli/cloud)

- [Migrate State](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-migrate)
- [Initializing and Migrating](https://developer.hashicorp.com/terraform/cli/cloud/migrating)
- Terraform versions older than 1.1 use the `remote backend block`
- cannot include a `backend block`.
- automatic state locking.
- `terraform workspace show` # show which workspace your using. 'default' is default
- to start using
  - terraform login
    - [add credentials](https://developer.hashicorp.com/terraform/cli/config/config-file#credentials-1)
    - when you terraform cloud gives you a token, it is stored in a json file: **~/.terraform.d/credentials.tfrc.json**
    - now you can run: `terraform apply`

```hcl
terraform {
 cloud {
  organization = "My-Org"  # must exist before terraform init
  workspaces {
    name = "Devops-Production"  # name must NOT exist.
  }
 }
}
```

[**Migrate Terraform Cloud State Back to Local**](https://developer.hashicorp.com/terraform/cloud-docs/api-docs/state-versions)

- [Migrate State off Terraform Cloud](https://nedinthecloud.com/2022/03/03/migrating-state-data-off-terraform-cloud/)

1. `terraform state pull > ./terraform.tfstate`
2. remove `.terraform` folder and `.terraform.lock.hcl` file
3. comment out the `cloud block`
4. `terraform init`
