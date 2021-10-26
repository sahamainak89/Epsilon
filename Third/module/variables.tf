variable "instanceCount" {
  description = "No. of EC2 machies to spin up"
  type    = number
  default = 1
}


variable "instanceType"{
  description = "Type of EC2 instance"
  default = "t2.micro"
}

variable "envType" {
  description = "Name of the environment this machine belongs to"
}

variable "amiId" {
  description = "AMI Id of the EC2 Instance you want to provision"
}