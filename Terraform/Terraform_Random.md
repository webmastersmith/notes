# Terraform Random


[Random](https://registry.terraform.io/providers/hashicorp/random/latest/docs)

- Random resources generate randomness only when they are created; the results produced are stored in the Terraform state and re-used until the inputs change, prompting the resource to be recreated.

```terraform
terraform {
  required_version = ">= 1.2.8"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}
```

### [String](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) 

```HCL
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
  numeric = false
  lower   = true
}

name = "my_secret-${random_string.suffix.result}"  # or id
```

### [Pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)

```HCL
resource "random_pet" "name" {
  length = 1  # how many words, separated by -
}

Name = "web-server-${random_pet.name.id}"
```
