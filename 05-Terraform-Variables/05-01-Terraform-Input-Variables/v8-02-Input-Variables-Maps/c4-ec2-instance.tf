# Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami                    = var.ec2_ami_id
  #instance_type          = var.ec2_instance_type[0]
  instance_type = var.ec2_instance_type_map["small-apps"]
  key_name               = "demo-ec2"
  count                  = var.ec2_instance_count
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to Terraform Training ! AWS Infra created using Terraform in ap-south-1 Region</h1>" > /var/www/html/index.html
    EOF
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  tags = var.ec2_instance_tags
}
