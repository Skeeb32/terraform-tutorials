# Create EC2 Instance
resource "aws_instance" "web" {
  ami = "ami-04db49c0fb2215364" # Amazon Linux
  instance_type = "t2.micro"
  tags = {
    "Name" = "web-2"
  }
  # lifecycle {
  #   prevent_destroy = true # Default is false
  # }
}

