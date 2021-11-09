resource "aws_vpc" "vpc-demo" {
  cidr_block = "10.175.0.0/16"

  tags = {
    project = "task"
  }
}

resource "aws_subnet" "sn-demo" {
  vpc_id            = aws_vpc.vpc-demo.id
  cidr_block        = "10.175.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sn-demo"
  }
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "for task"
  vpc_id      = aws_vpc.vpc-demo.id

  ingress = [
    {
      description      = "all ssh from subnet"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["10.175.0.0/16"]
      ipv6_cidr_blocks = []
      self             = null
      prefix_list_ids  = []
      security_groups  = []
    }
  ]

  egress = [
    {
      description      = "allow all out"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = true
      prefix_list_ids  = []
      security_groups  = []
    }
  ]

  tags = {
    Name = "demo-sg"
  }
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.sn-demo-public.id
  tags = {
    "Name" = "demo-ngw"
  }
}

output "nat_gateway_ip" {
  value = aws_eip.nat_gateway.public_ip
}

resource "aws_route_table" "rtb-demo" {
  vpc_id = aws_vpc.vpc-demo.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "rtb-demo-a" {
  subnet_id      = aws_subnet.sn-demo.id
  route_table_id = aws_route_table.rtb-demo.id
}

resource "aws_subnet" "sn-demo-public" {
  vpc_id            = aws_vpc.vpc-demo.id
  cidr_block        = "10.175.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sn-demo-public"
  }
}

resource "aws_internet_gateway" "igw-demo" {
  vpc_id = aws_vpc.vpc-demo.id

  tags = {
    Name = "igw-demo"
  }
}

resource "aws_route_table" "rtb-demo-public" {
  vpc_id = aws_vpc.vpc-demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-demo.id
  }
  tags = {
    Name = "rtb-demo-public"
  }
}

resource "aws_route_table_association" "rta-demo-public-a" {
  subnet_id      = aws_subnet.sn-demo-public.id
  route_table_id = aws_route_table.rtb-demo-public.id
}