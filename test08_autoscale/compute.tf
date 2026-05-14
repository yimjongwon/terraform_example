# 1. SSH 키 페어 생성 (TLS 라이브러리 활용)
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "lecture-key"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${path.module}/lecture-key.pem"
  content         = tls_private_key.pk.private_key_pem
  file_permission = "0600"
}

# 2. 보안 그룹 (ASG용)
resource "aws_security_group" "asg_sg" {
  name   = "allow-ssh-http"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. 최신 Amazon Linux 2023 AMI 조회
data "aws_ami" "latest_al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# 4. ASG Launch Template (ec2 의 설계도) 만들기
resource "aws_launch_template" "lt" {
    # 생성되는 ec2 이름의 접두어 정의하기
    name_prefix = "lecture-asg-"
    # ami 선택 (우리가 직접만든 ami를 선택할수도 있다)
    image_id = data.aws_ami.latest_al2023.id
    # 인스턴스 type
    instance_type = var.instance_type # 변수에 있는 내용을 참조
    # 생성되는 ec2가 공통으로 사용할 보안그룹
    vpc_security_group_ids = [aws_security_group.asg_sg.id]
    
    # 사용할 키의 이름
    key_name = aws_key_pair.kp.key_name

    # 프로비저닝 후에 실행할 user_data (여기서는 테스트용으로 nginx 를 설치및 시작)
    user_data = base64encode(<<-EOF
        #!/bin/bash
        dnf update -y
        dnf install -y nginx
        systemctl enable --now nginx
        echo "<h1>Hello from ASG Instance</h1>" > /usr/share/nginx/html/index.html
    EOF
    )
    # 시작 템플릿을 통해 생성될 리소스에 대한 상태 태그 설정
    tag_specifications {
        # 태그를 적용할 리소스의 종류
        resource_type = "instance"
        # ASG 가 인스턴스를 생성할 때마다 이 이름을 붙여준다.
        tags = { Name = "asg-instance" }
    }
}

# 5. 위의 설계도를 이용해서 실제 동작할 Auto Scaling Group 정의
resource "aws_autoscaling_group" "asg" {
    name = "lecture-asg"
    # ec2 가 위치할 서브넷을 등록
    vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    # 이상적인(원하는) ec2의 개수
    desired_capacity = var.desired_capacity
    # 늘린다면 가능한 최대 개수
    max_size = var.max_size
    # 줄인다면 가동되어야 하는 최소 개수
    min_size = var.min_size
    # 위에서 만든 template 정보를 등록
    launch_template {
        id = aws_launch_template.lt.id
        # 항상 최신의 이미지를 사용하도록(항상 최신의 template을 사용하도록)
        version = "$Latest"
    }
}

# 6. ASG 에 의해 생성된 실제 인스턴스의 정보 조회
data "aws_instances" "asg_nodes" {
  # ASG가 먼저 생성되어야 된다 
  # ASG 생성이 완료될 때까지 이 조회를 기다리도록 순서를 강제합니다.
  depends_on = [aws_autoscaling_group.asg]

  # 필터링 조건: 수많은 인스턴스 중 어떤 녀석을 골라낼지 정합니다.
  instance_tags = {
    # AWS가 ASG 소속 인스턴스에 자동으로 붙여주는 "소속 태그"를 이용합니다.
    # "이 ASG 이름(lecture-asg)을 가진 그룹에 속한 애들 다 모여!" 라는 뜻입니다.
    "aws:autoscaling:groupName" = aws_autoscaling_group.asg.name
  }

  # 상태 필터: 꺼져 있거나(stopped) 생성 중인 애들은 빼고, 
  # 지금 바로 접속해서 일할 수 있는 'running' 상태인 애들만 쏙 골라냅니다.
  instance_state_names = ["running"]
}

# 7. 조회된 인스턴스 정보 출력

output "asg_instance_ips" {
  description = "Auto Scaling Group 인스턴스들의 Public IP"
  value       = data.aws_instances.asg_nodes.public_ips
}