provider "aws" {
  region = "ap-south-1"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "tf-generated-key"
  public_key = file("C:/Users/JaiShah/.ssh/id_rsa.pub")
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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
}

resource "aws_instance" "web_server" {
  ami           = "ami-0e35ddab05955cf57"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl enable apache2
              sudo systemctl start apache2
            EOF

  tags = {
    Name = "WebServer"
  }
}
