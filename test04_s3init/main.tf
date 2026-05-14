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

# s3 버킷 및 IAM 설정(새로 추가할 로직)
resource "random_id" "bucket_suffix" {
    # 4byte 크기의 랜덤한 문자열을 얻어내기 위한 설정
    byte_length = 4
}

# s3 버킷 정의하기
resource "aws_s3_bucket" "db_backup_bucket" {
    # s3 버킷의 이름은 전세계에서 유일해야 한다
    # 문자열을 너무 간단히 부여하면 에러가 나면서 만들어지지 않는다
    # 4 byte 크기의 random 한 16진수를 뒤에 붙여서 겹치지 않는 이름이 나오게 한다.
    bucket = "db-backup-storage-${random_id.bucket_suffix.hex}"
}

# 1단계: IAM role 정의하기 (신분증 만들기) 
resource "aws_iam_role" "db_backup_role"{
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
    role        = aws_iam_role.db_backup_role.name
    # s3 를 full access 할 수 있는 권한
    policy_arn  = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# 3단계: 신분증을 aws 가 인식할 수 있도록 case 에 담기
resource "aws_iam_instance_profile" "db_backup_profile" {
    name = "EC2-S3-Instance-Profile"
    role = aws_iam_role.db_backup_role.name
}

# 생성된 s3의 버킷 이름 출력
output "s3_bucket_name" {
    description = "생성된 s3 버킷의 이름"
    value       = aws_s3_bucket.db_backup_bucket.id
}