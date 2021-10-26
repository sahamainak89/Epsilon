resource "aws_instance" "srv01" {
  count         = var.instanceCount
  ami           = var.amiId
  instance_type = var.instanceType
  tags = {
    "Name" = "server${count.index + 1}",
    "ENV" = var.envType
  }
  user_data = <<-EOF
  #!/bin/bash
  echo "Hello world" > index.html
  nohup busybox httpd -f -p 80 &
  EOF

  vpc_security_group_ids =  [ aws_security_group.publicwebsg.id ]
  depends_on = [
    aws_security_group.publicwebsg 
  ]
  key_name = "mandeep"
}

resource "aws_security_group" "publicwebsg" {
  name = "publicwebsg"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

output "ipaddress" {
  value = aws_instance.srv01[*].public_ip
}


output "private_ip" {
  value = aws_instance.srv01[*].private_ip
}


