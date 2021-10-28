resource "aws_instance" "srv01" {
  count         = var.instanceCount
  ami           = var.amiId
  instance_type = var.instanceType
  tags = {
    "Name" = "server${count.index + 1}",
    "ENV" = var.envType
  }
  key_name = "emess"
  subnet_id = count.index == 0 ? aws_subnet.privatesubnets.id :aws_subnet.publicsubnets.id
}

 resource "aws_vpc" "TrainingMain" {              
   cidr_block       = var.main_vpc_cidr
   instance_tenancy = "default"
   tags = {
     Name = "emessVPC"
   }
 }

 data "aws_availability_zones" "available_zones" {
  
}

 resource "aws_subnet" "publicsubnets" {  
   vpc_id =  aws_vpc.TrainingMain.id
   cidr_block = "${var.public_subnets}"
   availability_zone = data.aws_availability_zones.available_zones.names[0]
   depends_on = [
    aws_vpc.TrainingMain 
  ] 
 }

 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.TrainingMain.id
   cidr_block = "${var.private_subnets}"
   availability_zone = data.aws_availability_zones.available_zones.names[1]
   depends_on = [
    aws_vpc.TrainingMain 
  ]         
 }

output "ipaddress" {
  value = aws_instance.srv01[*].public_ip
}


output "private_ip" {
  value = aws_instance.srv01[*].private_ip
}


