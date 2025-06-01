# Networkings
data "aws_vpc" "default" { default = true }

data "http" "myip" { url = "https://checkip.amazonaws.com" }

resource "aws_security_group" "clock_sg" {
  name        = "clock-sg"
  description = "Allow HTTP and your SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# AMI
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.al2023.value]
  }
}

# EC2 instance

resource "aws_instance" "clock" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.clock_sg.id]
  user_data                   = file("${path.module}/user-data.sh")
  tags = { Name = "clock-server" }
}

# Elastic IP

resource "aws_eip" "clock_eip" {
  instance = aws_instance.clock.id
  vpc      = true
}

# Output
output "clock_server_ip"  { value = aws_eip.clock_eip.public_ip }
output "clock_server_url" { value = "http://${aws_eip.clock_eip.public_ip}" }
