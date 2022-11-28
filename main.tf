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
  access_key = "ASIAQVPOG3TTGR3S2IHE"
  secret_key = "zOLADuZNZc5PabFSccbfrO9ZBKCAWGIfD2RGmPxG"
  token      = "FwoGZXIvYXdzEDMaDIYpa8cGWfi71w/aSyLEAUuP4Qx3iQTAycc9sZ8iPwba3ZgHK3dm/Uii8yhnYUT/zpPkqOggkSc8lse9ey1vnkFr/jlp5DsGOr8yvbQVvAIiL7ZdzfIB1+eBClPFj0ixylhrPoHYj6j61Tt1IzlQ5at7JGXmfNGFBatw5lJ4Q06BQYK0Owc0ZhCIMhQ5SEf70D69Mfli1KXCoucu2BZX8000j7Ac8j31I6Ab2J4Pvcdfv7y41d5YhtbjnqEDiezE3TNHwgfu8SFtCJt0abg7mYTj/sUopaeQnAYyLSTiIzfSPAlUoXLuL7NK0MJN0Grr/qi6udakS7WT1Cd0WsphfruHW2gYBbERNQ=="
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

resource "aws_instance" "instance_micro" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1c"
  user_data              = file("userdata.sh")
  count                  = 1
  tags = {
    Name = "micro"
  }
}
