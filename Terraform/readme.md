# infrastructure as code using terraform

- Hashicorp Terraform is an infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable configuration files that you can version, reuse and share.

- Uses HCL(Hashicorp Configuration language)
- Follows a Declarative approach.
- Automate infrastructure lifecycle managment.
- version control and resusable.

# How does terraform work?
 - configiration file -> Terraform provider-> cloud api(Target api)

# Core concepts
- Providers
- Resources - Defines the actual components of the infrastructure.
- HCL language features
- State managment - record of everything we provision/create/manage/delete in our infrastructure.
- Variables and outputs
- Modules
# Terraform state
- sensitive data(backend configuration)

#  Variables and outputs
- input variable
 variable "aws-region"{
  description = "AWS region"
  type = string
  default = "us-west-2"
 }

 - output variable
 output "instance_ip_address" {
  value = aws_instance.server.private_ip
 }

 - local variable
 locals{
  service_name = "forum"
  owner = "Community Team"
 }
