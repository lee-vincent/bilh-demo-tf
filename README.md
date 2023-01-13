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

conditional create
local-exec

1. working with terraform cli locally and local state files as a solo developer
   * deploy base vpc and wordpress ec2 instance
```sh
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```
   * review outputs
   * inspect terraform.tfstate local state file
   * what happens if we modify or delete a resource provisioned by terraform using the aws cli/console?
      * start trying to ping ec2 instance
```sh
ping -DO public_ip
```
   * modify security group - add all ICMP in via aws console
```sh
terraform plan
terraform apply
```
   * notice how ICMP rule is removed so security group matches the terraform config
   * what happens if someone creates a resource using the aws cli/console and we want terraform to manage it?
      * use value of the terraform output: **output.aws_cli_command_create_ec2_instance** to create ec2 instance using aws cli
      * **copy the command from the terraform output value output.aws_cli_command_create_ec2_instance, it will look similar to the below**
```sh
aws ec2 run-instances --image-id ami-0fe472d8a85bc7b0e --count 1 --instance-type t2.micro --key-name bilh-aws-demo-master-key --security-group-ids sg-0349a357ce3af89c1 --subnet-id subnet-0872df4f05d481829 --no-associate-public-ip-address --profile iamadmin-bilh-tf
```
   * copy the newly created instance's InstanceId from the aws cli ouput - e.g. i-0eba8bc0d6a8efdcc
   * uncomment last section of code in vpc.tf
   * import the aws cli cli_created instance into our terraform config
```sh
terraform import aws_instance.cli_created replace_with_instance_id
```
   * find aws_instance.cli_created in terraform.tfstate file to show it is under terraform management
   * go to aws console to the cli_created instance's tags - there should be no tags yet
```sh
terraform plan
terraform apply
```
   * cli_created instance should now show our standard tags
   * delete all infrastructure
```sh
terraform destroy
```
2. working with terraform cloud and remote state as a team of developers
[![GitHub](https://content.hashicorp.com/api/assets?product=tutorials&version=main&asset=public%2Fimg%2Fterraform%2Fautomation%2Ftfc-gh-actions-workflow.png)][https://developer.hashicorp.com/terraform/tutorials/automation/github-actions]
   * review terraform cloud workspace and connection to GitHub
      * create a new api-driven Terraform Cloud workspace named bilh-tf-gh-actions-demo
      * set workspace variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
      * [Create Token named **GitHub Actions**][tfghat]
      * Create new GitHub repository secret named **TF_API_TOKEN** with a value of the **GitHub Actions** terraform cloud token
         * make sure GitHub Actions has read/write permissions
      * create new branch to update terraform cloud backend and workspace
```sh
git checkout -b 'update-tfc-backend'
```
   * copy .github workflows into directory to provide github action definitions
   * un-comment terraform cloud config in versions.tf
   * re-initialize tfc workspace
```sh
terraform init
terraform workspace list
terraform plan
```
   * commit changes to the branch



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
   [tfghat]: <https://app.terraform.io/app/settings/tokens?product_intent=terraform&utm_source=learn>