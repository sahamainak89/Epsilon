module "ec2" {
  source        = "./module"
  instanceCount = 1
  instanceType  = "t2.micro"
  amiId         = "ami-09e67e426f25ce0d7"
  envType       = "DEV"
}

output "ipaddress" {
  value = module.ec2.ipaddress
}

