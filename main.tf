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
  region     = "us-east-1"
  access_key = "ASIAQVPOG3TTHJQ7P4UM"
  secret_key = "Y2BmGI5jtGQlVzFWkCbAmuxyd7Tbb9efzCxOlmzq"
  token      = "FwoGZXIvYXdzEFoaDCDLCW4qUWbn1iO/qSLEAcTgQ8BmzDems9AeVwtsMGCBzboPK5bBzQWJk9ltKd+SebGoxjBechGhxSd/O/AZyZB1LSLywpM8HRG1jSchfS+x3xYSalXDd/Z/DxKIY224Gpyj2cg/OYk8eE5s033Sf+QfMa5Op3jpSWVT9Kqj8gGpYNA/Pv+oqqjNBdUdiIgwCAvsEzJAPAUFJuIXE8hoEabgJbEFeiH/Hhyas78c+gW976Iv4wIHdTKzT9IS8+z54wksn5fzJEydjrvDWRcOZum2yWQoxLaJnQYyLdBnOC8cOOYR8cvxifwJBhXDvKlPm5kgotbeI4ork8Y7XQ6R31zVUelYc/Z86Q=="
}

resource "aws_security_group" "security_gp" {
  vpc_id = data.aws_vpc.default.id

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

# Creation of standalone sql instance
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


# Creation of master node for cluster
resource "aws_instance" "master" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("master.sh")
  count                  = 1
  subnet_id              = "subnet-0e56c7e46775aa919"
  private_ip             = "172.31.17.1"
  tags = {
    Name = "sql-master"
  }
}

# Creation of slave nodes for cluster
resource "aws_instance" "slave_1" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("slave.sh")
  count                  = 1
  subnet_id              = "subnet-0e56c7e46775aa919"
  private_ip             = "172.31.17.2" 
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
  subnet_id              = "subnet-0e56c7e46775aa919"
  private_ip             = "172.31.17.3"
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
  subnet_id              = "subnet-0e56c7e46775aa919"
  private_ip             = "172.31.17.4"
  tags = {
    Name = "sql-slave-3"
  }
}

# Creation of proxy node
resource "aws_instance" "proxy" {
    ami                    = "ami-0a6b2839d44d781b2"
    instance_type          = "t2.large"
    vpc_security_group_ids = [aws_security_group.security_gp.id]
    availability_zone      = "us-east-1c"
    user_data              = file("proxy.sh")
    subnet_id              = "subnet-0e56c7e46775aa919"
    private_ip             = "172.31.17.5"
    tags = {
      Name = "proxy"
    }
}