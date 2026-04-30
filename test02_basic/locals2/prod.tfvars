# 파일명이 terraform.tfvars 가 아니기 때문에 
# terrform 실행할때 default로 읽어들이지 않는다.
# plan 이나 apply 할때 -var-file="prod.tfvars" 옵션으로 실행해야한다.
env             = "prod"
project_name    = "ktcloud-v1"
