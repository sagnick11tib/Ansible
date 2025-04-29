# Key Pair Login

resource "aws_key_pair" "ec2_key" {
  key_name   = "ansible-key-ec2"
  public_key = file("ansible-key-ec2.pub")
}

# VPC & Security Group

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security_group" {
  name        = "ansible-sg"
  description = "This will generate a security group for ansible master and workers EC2 instances"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = var.allow_ssh ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH access from anywhere"
    }
  }

  dynamic "ingress" {
    for_each = var.allow_http ? [1] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP access from anywhere"
    }
  }

  dynamic "ingress" {
    for_each = var.allow_nodeport ? [1] : [] # Only create NodePort rule if allow_nodeport is true
    content {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "NodePort access from anywhere"
    }
  }

  dynamic "egress" {
    for_each = var.outbound_traffic_allowed ? [1] : [] # Create egress if allowed
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # All protocols
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  }
}

# EC2 Instance

resource "aws_instance" "my_instance" {
  for_each = tomap({
    Ansible-Master      = "t2.micro",
    Ansible-WorkerOne   = "t2.micro",
    Ansible-WorkerTwo   = "t2.micro",
    Ansible-WorkerThree = "t2.micro",
  })
  key_name        = aws_key_pair.ec2_key.key_name
  ami             = var.ec2_ami_id
  instance_type   = each.value
  security_groups = [aws_security_group.my_security_group.name]
  user_data       = each.key == "Ansible-Master" ? file("install_ansible.sh") : null
  depends_on      = [aws_security_group.my_security_group, aws_key_pair.ec2_key]
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
  }
}

