# Terraform State

- production enviroment with multiple teams, need remote state
- avoid race condition -solution restore state remotely

remote state changed
```hcl
terraform init -reconfigure
```

migrate state
```hcl
terraform init -migrate-state  # pull remote state to local, if state local add to remote.
```

**[updating resource names](https://blog.gruntwork.io/terraform-up-running-3rd-edition-is-now-published-4b99804d922a)**

- Any time you refactor your code, you should add a moved block to capture how the state should be updated. You can add the moved block in any .tf file in your Terraform code, though to make them easier to find, you may wish to pick a convention, such as putting all moved blocks in a moved.tf file.

```hcl
moved {
  from = aws_instance.instance
  to   = aws_instance.jenkins
}
```

## Backup State
**cloud state backup/management**
- [Getting-Started](https://learn.hashicorp.com/tutorials/terraform/aws-remote?in=terraform/aws-get-started)
- [Locking](https://developer.hashicorp.com/terraform/language/state/locking)
- terraform login  //paste token when asked.
- add aws credentials to cloud

```hcl
terraform {
# terraform online storage
  backend "remote" {
    organization = "Batch22"  # must already exist
    workspaces {
      name = "Batch_Terraform_Workspace"  # can't already exist
    }
  }

# or aws s3 bucket
  backend "s3" {
    bucket = "terra-ptkgux"
    key    = "terraform/terraform.tfstate"
    dynamodb_table = "your dynamodb table name"  # to lock state when multiple people use it.
    region = "us-east-1"  #cannot be a variable
  }
  required_providers {
    aws = {
  ...
}
```

**Locking State**
- local state, locking is performed by default.
- remote state
  - [s3 must add DynamoDB table name](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
  - terraform cloud  # automatic versioning

```hcl
# S3
terraform {
  backend "s3" {
    bucket = "terra-ptkgux"
    key    = "terraform/terraform.tfstate"
    dynamodb_table = "your dynamodb table name"  # to lock state when multiple people use it.
    region = "us-east-1"  #cannot be a variable
  }
  required_providers {
    aws = { ... }
}

```





**Terraform Cloud**
- cannot include a backend block
- terraform workspace show  # show which workspace your using.  'default' is default
- to start using
  - terraform login
    - add credentials
    - when you add token, creates jason file: **~/.terraform.d/credentials.tfrc.json**
    - now you can run: terraform apply

```hcl
terraform {
 cloud {
  organization = "your organization name on terraform cloud"
  workspaces {
    name = "Devops-Production"  # create name here, then the workspace on cloud will be named this.
  }
 }
}
```
