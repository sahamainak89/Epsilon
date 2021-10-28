resource "aws_lb" "msapplb" {
  name            = "msapplb"
  subnets         = aws_subnet.emesspublicsubnets.*.id
  security_groups = [aws_security_group.mssg.id]
}

resource "aws_security_group" "mssg" {
  name   = "aws_lb_mssg"
  vpc_id = aws_vpc.emessVPC.id

  ingress  {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress  {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = -1
    to_port     = 0
  }
}

resource "aws_lb_listener" "ms_listner" {
  load_balancer_arn = aws_lb.msapplb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ms_lb_grp.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "ms_lb_grp" {
  name        = "mslbtargetgrp"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.emessVPC.id
  target_type = "ip"
}

output "lbdnsnameme" {
  value = aws_lb.msapplb.dns_name
}