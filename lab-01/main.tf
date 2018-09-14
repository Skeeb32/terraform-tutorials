# provider "aws" {
#   region = "ca-central-1"

# }

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
  key_name = "ansible"
  tags {
    Name = "rhel"
  }
  provisioner "remote-exec" {
    inline = [
      "hostname -f"
    ]
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key  = "${file("~/ansible.pem")}"
  }
  }
  
   provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.web.public_ip}, install-jenkins.yml"
  }
}