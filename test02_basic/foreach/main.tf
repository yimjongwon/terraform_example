# 1. 데이터 정의 (학생 명단)
locals {
    students = ["kim", "park"]
}

# set 또는 map을 들어있는 정보를 이용해 반복문 돌면서 여러개의 자원을 만들어야 할때가있다.

# 2. for_each 를 사용하여 파일 생성
# local_file.student_notes 는 map type 이다
resource "local_file" "student_notes" {
    # list 를 set 으로 변환하여 for_each 에 넣어주기
    # for_each 에 대입할 수 있는 것은 set type 또는 map type 만 가능하다
    # list type은 안됨
    for_each = toset(local.students)
    # set를 넣어 주면 ${each.key}와 ${each.value} 가 동일하다
    # map을 넣어 주면 ${each.key}와 ${each.value} 가 다르다
    filename = "${path.module}/student_${each.key}.txt"
    content = "안녕하세여! ${each.value} 학생의 실습 노트 입니다"
}

output "debug" {
    description = "생성된 파일들의 전체 경로 목록"
    # item은 local_file.student_notes map 에 저장된 아이템 중 하나
    value = [for item in local_file.student_notes : item.filename]
}