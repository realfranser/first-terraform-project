# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create VPC
resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "main vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main-internet-gateway" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    "Name" = "main internet gateway"
  }
}

# Create route table
resource "aws_route_table" "main-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = var.default_route
    gateway_id = aws_internet_gateway.main-internet-gateway.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main-internet-gateway.id
  }

  tags = {
    "Name" = "main route table"
  }
}

# Create a subnet
resource "aws_subnet" "main-subnet" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    "Name" = "main subnet"
  }
}

# Associate subnet to route table
resource "aws_route_table_association" "main-route-table-association" {
  subnet_id      = aws_subnet.main-subnet.id
  route_table_id = aws_route_table.main-route-table.id
}

# Create security group to allow 22, 80, 443 traffic
resource "aws_security_group" "main-security-group" {
  name        = "allow_web_traffic"
  description = "Allow inbound web traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description = "HTTPS"
    # from - to = range of ports
    from_port   = 433
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.default_route]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.default_route]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.default_route]
  }

  egress {
    from_port = 0
    to_port   = 0
    # all protocols allowed
    protocol    = "-1"
    cidr_blocks = [var.default_route]
  }

  tags = {
    "Name" = "main security group"
  }
}

# Create a network interface with an ip in the main subnet
resource "aws_network_interface" "main-network-interface" {
  subnet_id       = aws_subnet.main-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.main-security-group.id]

  tags = {
    "Name" = "main network interface"
  }
}

# Assign an elastic IP to the main network interface
resource "aws_eip" "main-elastic-ip" {
  vpc                       = true
  network_interface         = aws_network_interface.main-network-interface.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.main-internet-gateway]

  tags = {
    "Name" = "main elastic ip"
  }
}

# Create EC2 instance
resource "aws_instance" "main-server" {
  # ami								= var.amazon_linux_ami
  ami               = var.ubuntu_ami
  instance_type     = "t2.micro" # Free tier EC2 instance
  availability_zone = var.availability_zone
  key_name          = "main-key"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.main-network-interface.id
  }

  # User data for Ubuntu
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF

  # User data for Amazon Linux (not working)
  #	user_data = <<-EOF
  #								#!/bin/bash
  #								sudo yum update -y
  #								sudo yum install -y httpd.x86_64
  #								sudo systemctl start httpd.service
  #								sudo systemctl enable httpd.service
  #
  #								sudo bash -c 'echo WEB SERVER DEPLOYED! > /var/www/html/index.html'
  #								EOF

  tags = {
    "Name" = "main server"
  }
}

output "server_public_ip" {
  value = aws_eip.main-elastic-ip
}