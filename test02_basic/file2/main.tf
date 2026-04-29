# local_file 을 이용해서 ansible.cfg 파일을 만들어 보자
resource "local_file" "ansible_config" {
    # 파일명
    filename = "${path.module}/ansible.cfg"
    # 파일의 내용
    content = <<-EOF
        [defaults]
        # 인벤토리 파일의 위치( yml 파일로 만들 예정)
        inventory = ./inventory.yml
        # 새로운 서버 접속시 yes/no 확인 과정 생략 (자동화의 필수)
        host_key_checking = False
    EOF
}

# 결과 확인용 메시지
output "debug" {
    value = "ansible 설정 파일 ${local_file.ansible_config.filename} 생성이 완료 되었습니다"
}