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

> This will be a description
> This will be a description
> This will be a description
> This will be a description
> This will be a description

## Agenda

- deploy base vpc with instance
- refactor base vpc into private module
- new tf workspace with instance using the base vpc module and tfc exported outputs
- implicit resource creation ordering/dependencies and dependson
- resources
- names
- state files
- local state
- terraform cloud
- migrate remote state to tfc
- modules for something like wordpress?
- packer for ami wordpress
- github commit/pull request workflow
- import a resource
- terraform import aws_instance.console_created i-06e725a25c0335c27
- make sure the ami id matches - maybe use a data source
- what about ebs snapshots with commvault?
- terraform functions
- variables
- local-exec scripting
- data sources
- terminate instance with console - run tf plan
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