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
  access_key = "ASIAQVPOG3TTNDRWE6N3"
  secret_key = "WKPtT+IxtmMx2a+ZQX2/wttVT33zDTsgaRrnFMUE"
  token      = "FwoGZXIvYXdzEJn//////////wEaDAY4SXsIAw+PAxH9UCLEAYHX+186mcs/LTWt5pAyM7IM6p4tvrlNWVBDYcwP3YG0aFtz/AG6i6VoaPRLByCPJa6iu35MvkPmJKAcEaY5NiAqZiduzv1t5TGOeHWjkKxb4JsZCXniNhTnfMWlrWuz2uRifJ8tkoClWGl/u2j9irz67dzovktNIkCMOQfZlRQqT9qSbWHvhXyUEv9jEiD4WyL0L58bAGR3xMAHnwCnXYvce1ggEAimu1xvK6npR3z6znNFLRReOcp+QoA16WPT3zty/REo+ZOXnQYyLYW/QP4/OjR0mrOA3OFubggENF5VGycSFjcYqYYlM+iJG94LrSPJvmZ5SZ9a+Q=="
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