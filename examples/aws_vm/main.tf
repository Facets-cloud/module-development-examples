locals {
  test = false
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20250115"]
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.instance_name}-${var.environment.unique_name}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "vm" {
  key_name      = aws_key_pair.deployer.key_name
  count         = var.instance.spec.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance.spec.instance_type

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "Facets-VM-${count.index}"
  }
}

resource "aws_security_group" "ssh" {
  name        = "${var.instance_name}-${var.environment.unique_name}-sg"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
