provider "aws" {
  region = var.aws_region
}

# Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "tls_private_key" "terraform" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.terraform.public_key_openssh
}

resource "aws_security_group" "default_security_group" {
  name        = "default-security-group"
  description = "Allow HTTP traffic"
  vpc_id      = module.vpc.vpc_id

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend API
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend (Vite / React)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH (ONLY if you really need it)
  ingress {
    from_port   = 22
    to_port     = 22
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


resource "aws_instance" "BE_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.default_security_group.id]
  key_name               = aws_key_pair.terraform_key.key_name

  user_data = file("${path.module}/scripts/be_init.sh")

  tags = {
    Name = var.instance_name_BE
  }
}

resource "aws_instance" "FE_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.default_security_group.id]
  key_name               = aws_key_pair.terraform_key.key_name

  user_data = file("${path.module}/scripts/fe_init.sh")

  tags = {
    Name = var.instance_name_FE
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.14.2"

  name = "FEBEDB-VPC"
  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.available.names

  public_subnets  = [cidrsubnet(var.vpc_cidr, 8, 0)]
  private_subnets = [cidrsubnet(var.vpc_cidr, 8, 1)]

  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_nat_gateway = true
  single_nat_gateway = true
}
