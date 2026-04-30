# 변수에 들어 있는 값을 활용해서 지역변수 만들어서 값 대입하기
locals {
    resource_name = "${var.project_name}-${var.env}-file"
}

resource "local_file" "example" {
    filename = "${path.module}/${local.resource_name}"
    content = "현재 환경은 ${var.env} 입니다."
}