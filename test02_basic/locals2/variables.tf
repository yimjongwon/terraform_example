# 변수라기보다는 상수에 가깝다
variable "env" {
    type = string
    description = "현재 환경 (dev | prod)"
}
variable "project_name" {
    type = string
    description = "프로젝트 이름"
    default = "sample"
}