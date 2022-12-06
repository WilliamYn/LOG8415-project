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
  access_key = "ASIAQVPOG3TTAZPZGA5U"
  secret_key = "MhEXzg8qcvcnYq+6zG4GpvD9iKcz/hR/1fUCXEAW"
  token      = "FwoGZXIvYXdzEPf//////////wEaDCPY6uWPHVc8tz8l2CLEAV9JcvLBrcsEPIHBIMeDrZdo7irA+kPi5NSpbmz34VChKakgA1G+e8IpRYvh/L631wIiT4TABkYqpJSn3HYttpeiDBQ56X+2OYeq3FxqV19uPHcoMFNSiinJJcXrACRm45jwPRIQYhNfa5Q3uPiOts9tRKsCVq6wYhuIv6JbBZzbfXGbGxOuyt9341D4M2/LPWfbSRL/tO90WwjkLT2RkgZ79UFETkwMkCARq3EHruB34rEK81sT23QUKyQGWIg9/H9ml8co6Zy7nAYyLUWkqTMbOUkGD4Ta0LQ9L7JCQQy+O6CUUIFuYI/7nxkTabULN3/Z4gnGhJ178A=="
}

resource "aws_security_group" "security_gp" {
  vpc_id = data.aws_vpc.default.id

  # verify port
  ingress {
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
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
  user_data              = file("userdata.sh")
  count                  = 1
  tags = {
    Name = "sql-11"
  }
}

resource "aws_security_group" "cluster_gp" {
  vpc_id = data.aws_vpc.default.id

  # verify port
  ingress {
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "master" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cluster_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("master.sh")
  count                  = 1
  private_ip              = "172.35.5.1" # test
  tags = {
    Name = "sql-master"
  }
}

resource "aws_instance" "slave_1" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cluster_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("slave.sh")
  count                  = 1
  private_ip              = "172.33.5.2" # test
  tags = {
    Name = "sql-slave-1"
  }
}

resource "aws_instance" "slave_2" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cluster_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("slave.sh")
  count                  = 1
  private_ip              = "172.33.5.3" # test
  tags = {
    Name = "sql-slave-1"
  }
}

resource "aws_instance" "slave_3" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cluster_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("slave.sh")
  count                  = 1
  private_ip              = "172.33.5.4" # test
  tags = {
    Name = "sql-slave-1"
  }
}