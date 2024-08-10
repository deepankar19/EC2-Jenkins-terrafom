resource "aws_vpc" "tf_terra_ec2_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Tf_terra_ec2_vpc"
  }
}

resource "aws_subnet" "tf_terra_ec2_public_subnet" {
  vpc_id            = aws_vpc.tf_terra_ec2_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = " Tf_terra_ec2_public_subnet"
  }
}

resource "aws_subnet" "tf_terra_ec2_private_subnet" {
  vpc_id            = aws_vpc.tf_terra_ec2_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Tf_terra_ec2_private_subnet"
  }
}

resource "aws_internet_gateway" "tf_terra_ec2_ig" {
  vpc_id = aws_vpc.tf_terra_ec2_vpc.id

  tags = {
    Name = "Tf_terra_ec2_ig"
  }
}

resource "aws_route_table" "tf_terra_ec2_public_rt" {
  vpc_id = aws_vpc.tf_terra_ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_terra_ec2_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.tf_terra_ec2_ig.id
  }

  tags = {
    Name = "Tf_terra_ec2_public_rt"
  }
}

resource "aws_route_table_association" "tf_terra_ec2_public_1_rt_a" {
  subnet_id      = aws_subnet.tf_terra_ec2_public_subnet.id
  route_table_id = aws_route_table.tf_terra_ec2_public_rt.id
}