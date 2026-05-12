terraform {
    required_version = ">= 1.14.0" # github action 에서 에러나지 않게 일부 수정
    required_providers {
      aws = {
            source = "hashicorp/aws"
            version = "~> 6.0" 
      }
    }
}

resource "aws_dynamodb_table" "members" {
    name = "members"             #테이블명
    billing_mode = "PAY_PER_REQUEST"    #비용 지불 방식 (요청 개수당 과금하겠다 비용미미)
    # partition key
    hash_key = "num"                 #카테고리명 마음대로 가능
    # 정렬이 필요하다면 sort key 도 추가한다
    # range_key = "정렬의 기준이 되는 칼럼"

    # 속성을 이용해서
    attribute {
        name = "num" # 카테고리의
        type = "N" # 데이터 type을 설정한다 S는 문자열 N은 숫자
    }
    tags = {
        Name = "members Table"
    }
}
