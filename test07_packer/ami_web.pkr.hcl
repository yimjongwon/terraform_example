packer {
    # packer로 aws 에 접속해서 작업하기 위한 플러그인
    required_plugins {
        amazon = {
            version = ">= 1.2.8"
            source  = "github.com/hashicorp/amazon"
        }
        # packer로 ansible을 이용해서 AMI 에 패키지 설치를 할 수 있도록 설정
        ansible = {
            version = ">= 1.1.0"
            source  = "github.com/hashicorp/ansible"
        }
    }
}

#우리가 만든 ami 이미지는 aws의 EBS에 저장이된다 (약간의 비용발생)
source "amazon-ebs" "web_image" {
    ami_name        = "ami-web-{{timestamp}}"
    instance_type   = "t3.micro"
    region          = "ap-northeast-2"
    source_ami      = "ami-0b6cacee0430cdb2c" # amazon linux 최신 AMI
    ssh_username    = "ec2-user"
}

# build 정보
build {
    sources = ["source.amazon-ebs.web_image"]
    # ansible 을 이용해서 nginx 를 셋팅
    provisioner "ansible" {
        playbook_file   = "./nginx_setup.yml"
        user            = "ec2-user"
        use_proxy       = false
    }
}