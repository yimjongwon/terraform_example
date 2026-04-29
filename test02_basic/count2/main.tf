# 지역변수(상수) 만들기
locals {
    students_list = ["kim", "lee", "park"]
}

resource "local_file" "student_notes" {
    # list 의 요소 갯수만큼 만들기  length() 함수를 이용하면  list 의 size 를 알수가 있다.
    count = length(local.students_list)
    # count.index 를 활용해서 배열의 특정 item 참조 해서 활용하기
    filename = "${path.module}/student_${local.students_list[count.index]}.txt"
    content = "안녕하세요 ${local.students_list[count.index]} 학생의 실습 노트 입니다"
}

output "debug" {
    value = local_file.student_notes[*].filename
}

