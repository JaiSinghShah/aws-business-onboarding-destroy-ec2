provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "ec2_sg" {
  name        = "My_EC2-SG"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My_EC2-SG"
  }
}

resource "aws_instance" "my_ec2" {
  ami                    = "ami-0e35ddab05955cf57"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              echo "Apache Server is running on EC2" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Jenkins-EC2"
  }
}
