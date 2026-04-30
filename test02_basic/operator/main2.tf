# operator/main2.tf

locals {
  # 테스트용 기준 데이터
  num_a = 10
  num_b = 5
 
  str_a = "dev"
  str_b = "prod"
}


# AWS 리소스 생성 없이 결과만 화면에 바로 출력합니다.
output "comparison_test_results" {
  description = "비교 연산자 종합 테스트 결과"
  value = {
    # 1. 같음 (==)
    "01_equal_num"    = local.num_a == 10          # 10 == 10 -> true
    "02_equal_str"    = local.str_a == local.str_b # "dev" == "prod" -> false
   
    # 2. 다름 (!=)
    "03_not_equal"    = local.num_a != local.num_b # 10 != 5 -> true
   
    # 3. 크다 (>)
    "04_greater_than" = local.num_a > local.num_b  # 10 > 5 -> true
   
    # 4. 크거나 같다 (>=)
    "05_greater_or_equal" = local.num_b >= 5       # 5 >= 5 -> true
   
    # 5. 작다 (<)
    "06_less_than"    = local.num_a < local.num_b  # 10 < 5 -> false
   
    # 6. 작거나 같다 (<=)
    "07_less_or_equal" = local.num_b <= 10         # 5 <= 10 -> true
  }
}
