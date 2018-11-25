provider "aws" {
  region = "us-east-1"

}

resource "aws_instance" "web" {
  ami           = "ami-011b3ccf1bd6db744"
  instance_type = "t2.micro"
  security_groups = [
        "jenkins"
    ]
  key_name = "jenkins"
  tags {
    Name = "rhel-jenkins"
  }
  provisioner "remote-exec" {
    inline = [
      "hostname -f"
    ]
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key  = "${file("~/jenkins.pem")}"
  }
  }
  
   provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.web.public_ip}, install-jenkins.yml -b"
  }
}
