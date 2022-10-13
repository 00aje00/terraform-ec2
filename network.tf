# setting up our virtual private cloud (vpc).

resource "aws_vpc" "test-env" {
  cidr_block = "178.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
  tags = {
    Name = "test-environment"
  }
}

# can the subnet configuration fit here?(subnets.tf) Here we define our subnets.

resource "aws_subnet" "subnet-uno" {
  cidr_block              = cidrsubnet(aws_vpc.test-env.cidr_block, 3, 1)
  vpc_id                  = aws_vpc.test-env.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

# here we are setting up a public Elastic ip for our server/instance.

resource "aws_eip" "ip-test-env" {
  instance = aws_instance.test-ec2-instance.id
  vpc      = true
}

# setting up the internet gateway routes traffic from the internet into our vpc.

resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = aws_vpc.test-env.id
  tags = {
    Name = "test-env-gw"
  }
}

# here are definning the route tables we would use to attach to our internet gateway ^ above.
# and also we are linking the route table to our subnet ^ above.

resource "aws_route_table" "route-table-test-env" {
  vpc_id = aws_vpc.test-env.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-env-gw.id
  }
  tags = {
    Name = "test-env-route-table"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet-uno.id
  route_table_id = aws_route_table.route-table-test-env.id
}
