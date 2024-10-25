# jenkins-terraform-vsphere
Building Terraform Pipeline using Jenkins. 
## stages
![j](https://github.com/alilotfi23/jenkins-terraform-vsphere/assets/91953142/fc7ffd8b-5ae0-40dc-8b38-c73d017f94b4)
## BluPrint
![blue-1](https://github.com/alilotfi23/jenkins-terraform-vsphere/assets/91953142/1e2313e3-1f23-4ee0-bf8f-e425cf8f44f7)
## terraform provider file
A provider in Terraform is a plugin that enables interaction with an API. This includes Cloud providers and Software-as-a-service providers. The providers are specified in the Terraform configuration code. They tell Terraform which services it 
## terraform versions file
You can stick to a provider version that makes sure there are no breaking changes.
## terrafprm main file
main.tf will contain the main set of configurations for your module.
# main.tf file 
This code will create vm in a datacenter with a specific amount of resource
## run terraform code
Install provider

```shell
terraform init
```
The terraform plan command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure

```shell
terraform plan
```
The terraform apply command is used to apply the changes required to reach the desired state of the configuration
```shell
terraform apply
```
# jenkins file
The jenkins pipline run terraform (init, fmt, validate) before apply command 
