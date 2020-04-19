provider "aws" {
  region = "ca-central-1"

}

resource "aws_instance" "web" {
  ami           = "ami-49f0762d"
  instance_type = "t2.micro"
  security_groups = [
        "ansible-node"
    ]

}