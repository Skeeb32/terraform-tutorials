provider "aws" {
  region = "ca-central-1"

}

data "aws_ami" "rhel" {
  most_recent = true
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-49f0762d"
  instance_type = "t2.micro"
  security_groups = [
        "ansible-node"
    ]

  tags {
    Name = "rhel"
  }
}