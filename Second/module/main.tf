resource "aws_instance" "mServer01" {
  count = var.instanceCount
  ami = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  tags = {
      "Name"= "Server-${var.instanceName}${var.serverCount[count.index]}"
      "Env" = var.env
  }
}

output "public_ip" {
    value = aws_instance.mServer01[*].public_ip
}