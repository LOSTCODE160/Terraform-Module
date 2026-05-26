
#key pair 
resource "aws_key_pair" "ec2" {
  key_name   = "${var.env}-infra-app-key"
  public_key = file("ec2-key.pub")
}

#vpc
resource "aws_default_vpc" "default" {

  tags = {
    name = "default-vpc"
  }
}
#security group
resource "aws_security_group" "my-sg" {
  name        = "${var.env}-infra-app-sg"
  description = "security group for ec2"
  vpc_id      = aws_default_vpc.default.id


  #inbound rules
  ingress { #ssh
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { #http
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-infra-app-SG"

  }

}

#ec2 instance
resource "aws_instance" "this" {
  count         = var.instance_count
  ami           = var.ec2_ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2.key_name


  vpc_security_group_ids = [aws_security_group.my-sg.id]

  associate_public_ip_address = true

  root_block_device {
    volume_size = var.env == "prod" ? 20 : 10
    volume_type = "gp3"
  }


  tags = {
    Name        = "${var.env}-infra-app-EC2"
    Environment = var.env
  }

}

