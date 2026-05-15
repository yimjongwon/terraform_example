# vpc, subnet, 보안그룹 등...

# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "lecture-vpc" }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "lecture-igw" }
}

# 퍼블릭 서브넷 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  # 가용영역 (변수에 저장된 내용을 이용해서 설정)
  availability_zone       = var.avail_zone_1
  map_public_ip_on_launch = true
  tags                    = { Name = "lecture-subnet" }
}

# 퍼블릭 서브넷 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  # 가용영역 (변수에 저장된 내용을 이용해서 설정)
  availability_zone       = var.avail_zone_2
  map_public_ip_on_launch = true
  tags                    = { Name = "lecture-subnet" }
}

# 라우팅 테이블
resource "aws_route_table" "public_rt" {
  # 위에서 만든 vpc에 위치 시키기
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    # 위에서 만든 인터넷 gateway 연결 (public subnet에서 사용할 라우팅 테이블)
    gateway_id = aws_internet_gateway.igw.id
  }
}

# 라우팅 테이블을 subnet에 연결하기
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# 라우팅 테이블을 subnet에 연결하기
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}