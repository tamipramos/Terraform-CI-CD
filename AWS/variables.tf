variable "instance_name_BE" {
  description = "Name of Backend Server"
  type        = string
  default     = "Backend_Server"
}

variable "instance_name_FE" {
  description = "Name of Frontend Server"
  type        = string
  default     = "Frontend_Server"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-3"
}

variable "ami_name" {
  description = "Ubuntu 24.04 LTS"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "instance_type" {
  description = "1vCPU-1GB RAM"
  type        = string
  default     = "t3.micro"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cmd_update" {
  description = "Update the server"
  type        = string
  default     = "sudo apt update && sudo apt upgrade -y"
}

variable "cmd_docker_install" {
  description = "Install Docker"
  type        = string
  default     = "sudo apt install docker.io -y && sudo systemctl start docker && sudo systemctl enable docker"
}

variable "cmd_docker_compose_install" {
  description = "Install Docker Compose"
  type        = string
  default     = "sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose"
}

variable "cmd_docker_permissions" {
  description = "Add ubuntu user to docker group"
  type        = string
  default     = "sudo usermod -aG docker ubuntu"
}

variable "cmd_reboot" {
  description = "Reboot the server"
  type        = string
  default     = "sudo reboot"
}

variable "cmd_nginx_install" {
  description = "Install Nginx"
  type        = string
  default     = "sudo apt install nginx -y && sudo systemctl start nginx && sudo systemctl enable nginx"
}

variable "cmd_nginx_copyToDist" {
  description = "Copy Nginx config to /etc/nginx/sites-available/default"
  type        = string
  default     = "sudo cp /app/nginx.conf /etc/nginx/sites-available/default && sudo systemctl restart nginx"
}

variable "cmd_git_install" {
  description = "Install Git"
  type        = string
  default     = "sudo apt install git -y"
}

variable "db_username" {
  description = "Database Username"
  type        = string
  default     = "admin"
}

variable "db_init_table" {
  description = "Database Initialization Table"
  type        = string
  default     = "CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, name VARCHAR(100), email VARCHAR(100));"
}

variable "download_repo_BE" {
  description = "GitHub Repository Backend"
  type        = string
  default     = "git clone --no-checkout https://github.com/tamipramos/Terraform-CI-CD.git && cd Terraform-CI-CD && git sparse-checkout init --cone && git sparse-checkout set AWS/Dockerfiles/backend-docker-compose.yml && git checkout main"
}

variable "download_repo_FE" {
  description = "GitHub Repository Frontend"
  type        = string
  default     = "git clone --no-checkout https://github.com/tamipramos/Terraform-CI-CD.git && cd Terraform-CI-CD && git sparse-checkout init --cone && git sparse-checkout set AWS/Dockerfiles/frontend-docker-compose.yml && git checkout main"
}
