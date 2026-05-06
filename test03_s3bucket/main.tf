# aws에 s3 bucket 을 만들어서 테스트

# version 명시하기
terraform {
  required_version = "~>1.14.0"
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}


# 1. provider 설정
provider "aws" {
    region = "ap-northeast-2" # 서울 리전
}


# 2. vpc 및 네트워크 생성 (인프라의 기초 공사)
# vpc
resource "aws_vpc" "main" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags                 = { Name = "lecture-vpc" }
}


# 인터넷 게이트 웨이
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags   = { Name = "lecture-igw"}
}


# 현재 리전에서 사용가능한(available) 가용 영역 데이터 가져오기
data "aws_availability_zones" "available" {
    state = "available"
}


# public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24" # 256 개의 ip 를 이방에 할당
   
    # 가용영역 하드코딩 대신 data 소스의 0번 방 데이터 연결
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true # 이방에 생기는 서버는 무조건 공인 ip 를 받는다.
    tags = {
        Name = "lecture-subnet"
    }
}


# 라우팅 테이블 : 트래픽 이정표
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}


# public subnet 을 위의 라우팅 테이블로 연결
resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}


# 3. pem 파일 관련 작업 (키 페어)
resource "tls_private_key" "pk" {
    algorithm = "RSA"
    rsa_bits  = 4096
}


resource "aws_key_pair" "kp" {
    key_name   = "lecture-key"
    public_key = tls_private_key.pk.public_key_openssh
}


resource "local_file" "ssh_key" {
    filename        = "${path.module}/lecture-key.pem"
    content         = tls_private_key.pk.private_key_pem
    file_permission = "0600" # 파일의 권한 설정 유지
}


# 4. 보안그룹
resource "aws_security_group" "ssh_sg" {
    name   = "allow-ssh"
    vpc_id = aws_vpc.main.id


    # 밖에서 안으로 들어오는 규칙  ingress
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
   
    # 기존 main.tf 에 있던 80 포트 허용 규칙 유지
    ingress {
        from_port   = 80
        to_port     = 80
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


# s3 버킷 및 IAM 설정(새로 추가할 로직)
resource "random_id" "bucket_suffix" {
    # 4byte 크기의 랜덤한 문자열을 얻어내기 위한 설정
    byte_length = 4
}

# s3 버킷 정의하기
resource "aws_s3_bucket" "my_bucket" {
    # s3 버킷의 이름은 전세계에서 유일해야 한다
    # 문자열을 너무 간단히 부여하면 에러가 나면서 만들어지지 않는다
    # 4 byte 크기의 random 한 16진수를 뒤에 붙여서 겹치지 않는 이름이 나오게 한다.
    bucket = "ktcloud-bucket-${random_id.bucket_suffix.hex}"
}

# 1단계: IAM role 정의하기 (신분증 만들기) 
resource "aws_iam_role" "ec2_s3_role"{
    # 신분증 이름은 마음대로
    name                = "EC2-S3-ACCESS-ROLE"
    # 정책은 정해진대로 작성
    assume_role_policy  = jsonencode({
    Version             = "2012-10-17"
    Statement           = [{
      Action            = "sts:AssumeRole"
      Effect            = "Allow"
      Principal         = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# 2단계: 신분증에 권한 적기
resource "aws_iam_role_policy_attachment" "s3_full_access" {
    role        = aws_iam_role.ec2_s3_role.name
    # s3 를 full access 할 수 있는 권한
    policy_arn  = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# 3단계: 신분증을 aws 가 인식할 수 있도록 case 에 담기
resource "aws_iam_instance_profile" "ec2_profile" {
    name = "EC2-S3-Instance-Profile"
    role = aws_iam_role.ec2_s3_role.name
}

# ec2 를 만들어서 ec2_profile 를 장착(연결) 하기
# ec2 에 설치할 amazon linux 최신 이미지 검색
data "aws_ami" "latest_al2023" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name" 
        values = ["al2023-ami-*-x86_64"]
    }
}

# ec2 만들기
resource "aws_instance" "my_ec2" {
    ami                    = data.aws_ami.latest_al2023.id
    instance_type          = "t3.micro" # 기존 main.tf의 사양 유지 
    subnet_id              = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.ssh_sg.id]
    key_name               = aws_key_pair.kp.key_name 
    # s3 접근을 위한 IAM 프로파일 연결 추가
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    tags = {
        Name = "my-ec2"
    }
}

# 생성된 ec2의 public ip 출력
output "instance_public_ip" {
    value = aws_instance.my_ec2.public_ip
}

# 생성된 s3의 버킷 이름 출력
output "s3_bucket_name" {
    description = "생성된 s3 버킷의 이름"
    value       = aws_s3_bucket.my_bucket.id
}