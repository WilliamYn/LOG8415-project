terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
  access_key = "ASIAQVPOG3TTIW6AFJDW"
  secret_key = "oj+0/enIDyR9O8Z588FqOZ2dwOK05rmn6zVurv/s"
  token      = "FwoGZXIvYXdzEJX//////////wEaDPpTOCtvuZnR1VjjACLEAScJTZc31KRX9TUmIP13orpk0wTyJxabbtDHqgr+yDskh6mBAarwAVWIn0zKh5pKQX6SQoQTRQ0H59cCBCak8tBbSx25THwIvuUo+wWOVxlQj+qvJPmNyP3feY5VViEMSBR4Ir0RGbiOM/sa6EAz5k/hFx3fpyvBHYa7xmpyH9OuiLLVDy3CguvpiFQaxnbMTsF2Pkl4eS/onmgMld5CDQdlkPIEIO3dTXLivY6rCgGPN+9VzH6zavb/PlNPWHKaMu3zoi8ohIfenAYyLe07SwaekZ1RWrQ/rjhoLelHhw6C8b3bq0nyg0zKOAzEipjcha4yQGZVrD/idA=="
}

resource "aws_security_group" "security_gp" {
  vpc_id = data.aws_vpc.default.id

  # verify port
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "instance_micro" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("standalone.sh")
  count                  = 1
  tags = {
    Name = "sql-standalone"
  }
}

# resource "aws_security_group" "cluster_gp" {
#   vpc_id = data.aws_vpc.default.id

#   # verify port
#   ingress {
#     from_port        = 0
#     to_port          = 65535
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }
# }


resource "aws_instance" "master" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("master.sh")
  count                  = 1
  subnet_id = "subnet-0e56c7e46775aa919"
  private_ip              = "172.31.17.1"
  tags = {
    Name = "sql-master"
  }
}

resource "aws_instance" "slave_1" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("slave.sh")
  count                  = 1
  subnet_id = "subnet-0e56c7e46775aa919"
  private_ip              = "172.31.17.2" 
  tags = {
    Name = "sql-slave-1"
  }
}

resource "aws_instance" "slave_2" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("slave.sh")
  count                  = 1
  subnet_id = "subnet-0e56c7e46775aa919"
  private_ip              = "172.31.17.3"
  tags = {
    Name = "sql-slave-2"
  }
}

resource "aws_instance" "slave_3" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("slave.sh")
  count                  = 1
  subnet_id = "subnet-0e56c7e46775aa919"
  private_ip              = "172.31.17.4"
  tags = {
    Name = "sql-slave-3"
  }
}