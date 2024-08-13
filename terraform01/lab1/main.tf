# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Create a Route Table
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "main_rta" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

# Create an EC2 Instance
resource "aws_instance" "main_instance" {
  ami           = "ami-04a81a99f5ec58529" # Amazon Linux 2 AMI (Replace with the latest AMI ID for your region)
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.main_subnet.id
 # security_groups             = [aws_security_group.main_sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "MyEC2Instance"
  }
 }
