module "ec2" {
  source        = "./module"
  instanceCount = 2
  instanceType  = "t2.micro"
  amiId         = "ami-09e67e426f25ce0d7"
  envType       = "DEV"
  main_vpc_cidr = "10.0.0.0/24"
  public_subnets = "10.0.0.128/26"
  private_subnets = "10.0.0.192/26"
}

output "ipaddress" {
  value = module.ec2.private_ip
}

