# Create EC2 Instance - Amazon Linux
resource "aws_instance" "my-ec2-vm" {
  ami           = "ami-04db49c0fb2215364"
  instance_type = var.instance_type
  key_name      = "demo-ec2"
  #count = terraform.workspace == "default" ? 1 : 1    
	user_data = file("apache-install.sh")  
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  tags = {
    "Name" = "vm-${terraform.workspace}-0"
  }

  connection {
    type = "ssh"
    host = self.public_ip # Understand what is "self"
    user = "ec2-user"
    password = ""
    private_key = file("private-key/terraform-key.pem")
  } 
  
  # local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command = "echo ${aws_instance.my-ec2-vm.public_ip} >> inventory"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }

  provisioner "local-exec" {
    command = "sleep 60,ansible-playbook --private-key=private-key/terraform-key.pem -i local-exec-output-files/inventory Ansible-Wordpress-Deployment/deploy-wordpress.yml -u ec2-user"
     #on_failure = continue
  }

  # local-exec provisioner - (Destroy-Time Provisioner - Triggered during Destroy Resource)
  provisioner "local-exec" {
    when    = destroy
    command = "echo Destroy-time provisioner Instanace Destroyed at `date` >> destroy-time.txt"
    working_dir = "local-exec-output-files/"
  }


}

# # Create EC2 Instance - Amazon Linux
# resource "aws_instance" "my-ec2-vm" {
#   ami           = data.aws_ami.amzlinux.id 
#   instance_type = var.instance_type
#   key_name      = "demo-ec2"
#   #count = terraform.workspace == "default" ? 1 : 1    
# 	# user_data = file("apache-install.sh")  
#   vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
#   tags = {
#     "Name" = "vm-${terraform.workspace}-0"
#   }


#   provisioner "remote-exec" {
#     inline = [
#       "sleep 120",  # Will sleep for 120 seconds to ensure Apache webserver is provisioned using user_data
      
#     ]
#   }
#   # Connection Block for Provisioners to connect to EC2 Instance
#   connection {
#     type = "ssh"
#     host = self.public_ip # Understand what is "self"
#     user = "ec2-user"
#     password = ""
#     private_key = file("private-key/terraform-key.pem")
#   }  

#  # Copies the file-copy.html file to /tmp/file-copy.html
#   # provisioner "file" {
#   #   source      = "apps/file-copy.html"
#   #   destination = "/tmp/file-copy.html"
#   # }

# # Copies the file to Apache Webserver /var/www/html directory
#   # provisioner "remote-exec" {
#   #   inline = [
#   #     "sleep 120",  # Will sleep for 120 seconds to ensure Apache webserver is provisioned using user_data
#   #     "sudo cp /tmp/file-copy.html /var/www/html"
#   #   ]
#   # } 

#   provisioner "local-exec" {
#     command = "sleep 120; ansible-playbook --private-key ./private-key/terraform-key.pem -i '${aws_instance.my-ec2-vm.public_ip},' main.yml"
#   }


# }













