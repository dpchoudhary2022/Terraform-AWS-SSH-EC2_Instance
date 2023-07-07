terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2_example" {

  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  key_name      = "mykeys" //this is created by us after ssh-keygen command 
  //  C:\Users\HP Note\mykeys
  vpc_security_group_ids = [aws_security_group.main.id]

  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote provisioner >> hello.txt",
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("C:/Users/HP Note/mykeys") // created by us
    // path of key
    timeout = "4m"
  }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}

// enter key_name= private key which we created
// enter public_key which we created
// both created by ssh-keygen command
// "C:/Users/HP Note/mykeys -->> here 'mykeys' is keyname
resource "aws_key_pair" "deployer" {
  key_name   = "mykeys" // this is created by us
                        // "C:/Users/HP Note/mykeys <<-- hint
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwAS7jibV/Prn4oDaigKyHvE4P1XxckUA0WAdirCHHST/V0AtrhA9DP7zwNSXjN8KQJFTtrhZjA2Mf1J35LWndg+iDMG0NU90sDRxuXaU0i1reSq9R3LUYuO6p8Gn46ft1T3da3JrXXq+hOJXyI3Lp+i2o0n1xRApromX6opCu/tMAhh+W3fq3nbbmXHQRJUjYb4+FjpJ2rKhfgXQHI+cJKEztx9/MQFxefnX2utIOFNRo3b4DitVhOoH9lH3hUdRz2VDt/vElJGubebukV6k7OlgnLeN2eIa85ynf/V2bLKZhsKhWf0+z5M8JKG/HTFGXHApgYsxfXoO1s4jvbGbn hp note@dp"
}
