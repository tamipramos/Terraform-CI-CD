# Region and provider
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

#Backend Server and DB
resource "aws_instance" "BE_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [ aws_security_group.default_security_group.id ]
  subnet_id = module.vpc.private_subnets[0]

  tags = {
    Name = var.instance_name_BE
  }

  provisioner "file" {
    source      = "../Dockerfiles/backend/*"
    destination = "/home/ubuntu/backend/"
  }

  provisioner "file" {
    source      = "../Dockerfiles/database/*"
    destination = "/home/ubuntu/database/"
  }

  connection {
    type        = "ssh"
    user       = "ubuntu"
    private_key = file("~/.ssh/terraform-key")
    host       = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      var.cmd_update,
      var.cmd_docker_install,
      var.cmd_docker_compose_install,
      var.cmd_docker_permissions,
      "cd /home/ubuntu/backend && docker-compose up -d",
      "cd /home/ubuntu/database && docker-compose up -d"
    ]
  }

}

#Frontend Server
resource "aws_instance" "FE_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [ aws_security_group.default_security_group.id ]
  subnet_id = module.vpc.private_subnets[0]

  tags = {
    Name = var.instance_name_FE
  }

  connection {
    type        = "ssh"
    user       = "ubuntu"
    private_key = file("~/.ssh/terraform-key")
    host       = self.public_ip
  }

  provisioner "file" {
    source      = "../Dockerfiles/frontend/*"
    destination = "/home/ubuntu/frontend/"
  }

  provisioner "remote-exec" {
    inline = [
      var.cmd_update,
      var.cmd_docker_install,
      var.cmd_docker_compose_install,
      var.cmd_docker_permissions,
      "cd /home/ubuntu/frontend && docker-compose up -d"
    ]
  }

}

#Security
resource "aws_security_group" "default_security_group" {
  name        = "default_security_group"
  description = "Allow inbound HTTP and SSH"
  vpc_id      = module.vpc.vpc_id

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

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 27017
    to_port     = 27017
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

#Key Pair
resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/terraform-key.pub")
}

#VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.14.2"
  name = "FEBEDB-VPC"
  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.available.names

  public_subnets = [cidrsubnet(var.vpc_cidr, 8, 0)]
  private_subnets = [cidrsubnet(var.vpc_cidr, 8, 1)]

  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
  single_nat_gateway = true

}