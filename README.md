# BILH Terraform Demo
## Creating, Modifying, and Deleting AWS Infrastructure
- Author: Vinnie Lee
- Contact: vinnie.lee@ahead.com

[![AHEAD](https://public-bucket-general.s3.amazonaws.com/AHEAD-logo-bluebackground-90x19px.png)](https://ahead.com)

## Terraform Providers Used (plugins)

| Plugin | Documentation |
| ------ | ------ |
| AWS | [hashicorp/aws/4.49.0][pvdaws] |
| null | [hashicorp/null/3.2.1][pvdnul] |
| local | [hashicorp/local/2.2.3][pvdlcl] |
| random | [hashicorp/random/3.4.3][pvdrnd] |

Demo Description

> In this terraform demo we will introduce the terraform cli, aws infrastructure provisioning,
> local state management, terraform cloud, remote state management, and github integration with
> terraform cloud.

## Agenda

1. working with terraform cli locally and local state files as a solo developer
   * deploy base vpc and wordpress ec2 instance
      ```sh
      terraform init
      terraform fmt
      terraform validate
      terraform plan
      terraform apply
      ```
   * outputs
   * inspect terraform.tfstate local state file
   * what happens if we modify or delete a resource provisioned by terraform using the aws cli/console?
      * modify security group - ping example ping -DO public_ip
         * terraform plan
         * terraform apply
   * what happens if someone creates a resource using the aws cli/console and we want terraform to manage it?
      * use value of the terraform output: **output.aws_cli_command_create_ec2_instance** to create ec2 instance using aws cli/console
      * uncomment last section of code in vpc.tf
         * terraform import aws_instance.console_created replace_with_instance_id
   * delete all infrastructure
      * terraform destroy
2. working with terraform cloud and remote state as a team of developers
- refactor base vpc into private module
- new tf workspace with instance using the base vpc module and tfc exported outputs

- migrate remote state to tfc
- modules for something like wordpress?
- packer for ami wordpress
- github commit/pull request workflow
- local-exec scripting
- tf workspaces with local state should correspond to git feature branches

> A common use for multiple workspaces is to create a parallel, distinct copy of a set of infrastructure to test a set of changes before modifying production infrastructure.\

[Terraform workspace use-cases][tfwsuc]

## Tech

## Installation

Install the dependencies

```sh
```

> Note:

```sh
terraform plan
```

## License

MIT

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [pvdaws]: <https://registry.terraform.io/providers/hashicorp/aws/4.49.0>
   [pvdnul]: <https://registry.terraform.io/providers/hashicorp/null/3.2.1>
   [pvdlcl]: <https://registry.terraform.io/providers/hashicorp/local/2.2.3>
   [pvdrnd]: <https://registry.terraform.io/providers/hashicorp/random/3.4.3>
   [tfwsuc]: <https://developer.hashicorp.com/terraform/cli/workspaces#use-cases>