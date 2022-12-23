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
  access_key = "ASIAQVPOG3TTFWOHEYHI"
  secret_key = "Kp70gbrKwgIGRrnyWX57ttNQ1Zo2vgB9Z2izIXDb"
  token      = "FwoGZXIvYXdzEJ3//////////wEaDN/5Sq6nmY8Uq/lfPiLEAc3WXJUrQZBoas6a0SHXDdi9cfrlH5Vq/pMhkrPZuS7SwoniNVUylAOLQSmi2XeoImPC7Tc7qWtcnUNQ5E2wqOXzHtUFQedGhE1gnNgmOQHWqmUGuIf/sJylcfttw6O/y0FyIkVak6SYQo+F9dDxtlkdH0SzxjZAtCt7ztPkJdClV2gkP/LkjiHsJ8U1MBVt5GhMJym39lPYRWKA7i6r3WvYL6dghsDVWEeD7Mi81EtfKvkkMK6k19lvM87Qo8/cSmDkAr0o3PiXnQYyLWOaFKEEHtVqCakmdWMJjqWmIRPrJp58elU/RAMQh48iqUQr2sp64cF478VjwQ=="
}

# Creation of the security group in which we will put the instances. The vpc used is the default AWS vpc. 
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

# Creation of instances. All instances have vockey so they can be connected to by downloading the SSH key from AWS Details. 
# The private_ip_addresses are within the subnet defined in subnet_id (in AWS subnets page)
# Creation of standalone sql instance
resource "aws_instance" "standalone" {
  ami                    = "ami-0a6b2839d44d781b2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("standalone.sh")
  key_name               = "vockey"
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
  subnet_id              = "subnet-0e56c7e46775aa919"
  private_ip             = "172.31.17.1"
  key_name               = "vockey"
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
  subnet_id              = "subnet-0e56c7e46775aa919"
  private_ip             = "172.31.17.2" 
  key_name               = "vockey"
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
  subnet_id              = "subnet-0e56c7e46775aa919"
  private_ip             = "172.31.17.3"
  key_name               = "vockey"
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
  subnet_id              = "subnet-0e56c7e46775aa919"
  private_ip             = "172.31.17.4"
  key_name               = "vockey"
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
    key_name               = "vockey"
    tags = {
      Name = "proxy"
    }
}