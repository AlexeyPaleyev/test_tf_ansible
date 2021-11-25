provider "aws" {
  region = "eu-central-1"
}


data "aws_ami" "ubuntu" {
  #find latest AMI image id in region
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}

resource "aws_internet_gateway" "gw" {
  #create gateway
  vpc_id = aws_vpc.lux.id

  tags = {
    Name    = "Lux"
    project = "WAH"
    owner   = "alx"
  }
}

resource "aws_route_table" "lux" {
  #add default route in vpc route table
  vpc_id = aws_vpc.lux.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "lux"
    project = "WAH"
    owner   = "alx"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.lux_subnet.id
  route_table_id = aws_route_table.lux.id
}

resource "aws_vpc" "lux" {
  #create vpc
  cidr_block       = "10.8.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name    = "Lux"
    project = "WAH"
    owner   = "alx"
  }
}
resource "aws_subnet" "lux_subnet" {
  #create sublet in vpc
  vpc_id     = aws_vpc.lux.id
  cidr_block = "10.8.0.0/24"

  tags = {
    Name    = "Lux_subnet"
    project = "WAH"
    owner   = "alx"

  }
}

resource "aws_security_group" "allow_80" {
  #create sg and add rules
  name        = "allow_80_22_icmp"
  description = "Allow 80_22_icmp inbound traffic"
  vpc_id      = aws_vpc.lux.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "icmp"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "allow_80_22_icmp"
    project = "WAH"
    owner   = "alx"
  }
}

resource "aws_key_pair" "master" {
  #import existing public key for SSH connection
  key_name   = "master"
  public_key = "ssh-rsa ..............................IoQT master"
}


resource "aws_instance" "web-a" {
  #create instance a
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.allow_80.id]
  subnet_id                   = aws_subnet.lux_subnet.id
  associate_public_ip_address = "true"
  key_name                    = "master"
  user_data = <<-EOF
    #!/bin/bash
    echo "<html><h1>Web server a webpage 1</h1></br> IP address is " > /home/ubuntu/index.html
    echo "$(curl -s  http://169.254.169.254/latest/meta-data/public-ipv4/) " >> /home/ubuntu/index.html
    echo "</html>" >> /home/ubuntu/index.html
  EOF

  tags = {
    Name    = "Web-a-server"
    project = "WAH"
    owner   = "alx"
  }
}

resource "aws_instance" "web-b" {
  # create instance b
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.allow_80.id]
  subnet_id                   = aws_subnet.lux_subnet.id
  associate_public_ip_address = "true"
  key_name                    = "master"

  user_data = <<-EOF
    #!/bin/bash
    echo "<html><h1>wWeb server b webpage 2</h1></br> IP address is " > /home/ubuntu/index.html
    echo "$(curl -s  http://169.254.169.254/latest/meta-data/public-ipv4/) " >> /home/ubuntu/index.html
    echo "</html>" >> /home/ubuntu/index.html
  EOF



  tags = {
    Name    = "Web-b-server"
    project = "WAH"
    owner   = "alx"
  }
}

