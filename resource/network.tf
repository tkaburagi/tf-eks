resource "aws_vpc" "eks-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eks",
  }
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

resource "aws_subnet" "eks-subnet" {
  count = 2
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block  = cidrsubnet(aws_vpc.eks-vpc.cidr_block, 8, count.index)
  availability_zone = var.az[count.index]
  tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
    Name = "eks"
  }
}

resource "aws_security_group" "eks-master" {
  name        = "eks-master-sg"
  description = "EKS master security group"
  vpc_id = aws_vpc.eks-vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_security_group" "eks-node" {
  name        = "eks-node-sg"
  description = "EKS node security group"
  vpc_id = aws_vpc.eks-vpc.id

  ingress {
    description     = "Allow cluster master to access cluster node"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks-master.id]
  }

  ingress {
    description     = "Allow cluster master to access cluster node"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks-master.id]
    self            = false
  }

  ingress {
    description = "Allow inter pods communication"
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

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  count          = 2
  subnet_id      = element(aws_subnet.eks-subnet.*.id, count.index)
  route_table_id = aws_route_table.rt.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks-vpc.id
}