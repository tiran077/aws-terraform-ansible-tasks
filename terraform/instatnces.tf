### The private instancesresource

resource "aws_instance" "demo" {
  ami                    = var.ami
  availability_zone      = var.az
  instance_type          = var.ec2_type
  key_name               = var.ssh-key
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id              = aws_subnet.sn-demo.id

  tags = {
    Name   = "demo"
    Projet = var.projet
  }

  volume_tags = {
    Name   = "demo"
    Projet = var.projet
  }

  root_block_device {
    volume_size = 8
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = var.ebs_type
    volume_size = 8
  }

  count = var.ec2_nb
}