# operator/main3.tf 파일의 내용


locals {
  # 테스트용 기준 데이터
  is_admin = true
  is_guest = false
 
  user_age = 25
}


output "logical_test_results" {
  description = "논리 연산자 종합 테스트 결과"
  value = {
    # 1. AND 연산자 (&&) : 양쪽 모두 true여야 true
    "01_and_true"  = local.is_admin && true           # true && true -> true
    "02_and_false" = local.is_admin && local.is_guest # true && false -> false
   
    # 2. OR 연산자 (||) : 둘 중 하나만 true여도 true
    "03_or_true"   = local.is_guest || local.is_admin # false || true -> true
    "04_or_false"  = local.is_guest || false          # false || false -> false
   
    # 3. NOT 연산자 (!) : 결과를 반대로 뒤집음
    "05_not_true"  = !local.is_guest                  # !false -> true
    "06_not_false" = !local.is_admin                  # !true -> false
   
    # 4. 실무형 복합 예제 (비교 연산자 + 논리 연산자)
    # "나이가 20살 이상이면서(AND) 관리자인가?"
    "07_complex"   = (local.user_age >= 20) && local.is_admin
  }
}



