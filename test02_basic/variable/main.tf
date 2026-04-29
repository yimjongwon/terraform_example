# test02_basic/variable/main.tf 파일
# variable 사용해 보기

# project_name 이라는 변수를 만들어서 기본값 "lecture" 를 대입
variable "project_name" {
    default = "lecture"
}


# env 라는 이름의 변수를 만들어서 기본값  "dev" 를 대입
variable "env" {
    default = "dev"
}

# 1. String (문자열 type)
# 가장 기본이 되는 문자열 type 입니다. 이름이나 리전등을 지정할때 사용
variable "vpc_name" {
    type        = string                # option (type을 명시적으로 지정)
    description = "vpc 이름 지정"        # option (설명)
    default     = "lecture-vpc"         # 기본값
}

# 2. Number (숫자 type)
variable "instance_count" {
    type        = number
    description = "생성할 인스턴스의 개수입니다"
    default     = 3
}

# 3. List (배열 type)
variable "avail_zones" {
    type        = list(string)
    description = "사용할 가용영역 리스트"
    default     = [ "ap-northeast-2a", "ap-northeast-2c", "ap-northeast-2d" ]
}

# 4. Map (dict 형태)
variable "common_tags" {
    type = map(string)
    description = "모든 리소스에 공통으로 붙일 태그"
    default = {
      env       = "dev"
      project   = "terraform-study"
      owner     = "kim"
    }
}

# 5. bool (논리 type)
variable "is_production" {
    type = bool
    description = "운영환경이면 true, 개발환경이면 false"
    default = false
}


# 변수에 저장된 내용 출력하기
output "debug01_project_name" {
    # 변수 참조 하는 방법 ->  var.변수명
    value = var.project_name
}


output "debug02_env" {
    value = var.env
}

output "debug03_info" {
    #문자열 보관법을 이용해서 원하는 문자열 형식을 만들어서 출력할 수 있다.
    value = "프로젝트명 : ${var.project_name}, 환경 : ${var.env}"
}

output "debug04_vpc_name" {
    value = "vpc 이름 : ${var.vpc_name}"
}

output "debug04_count" {
    value = "인스턴스 count : ${var.instance_count}"
}

output "debug06_list_all" {
    value = join(",", var.avail_zones)
}

output "debug07_map_value" {
    value = "프로젝트 환경은 ${var.common_tags.env}"
}

output "debug07_map_value2" {
    value = "프로젝트 환경은 ${var.common_tags["owner"]}"
}