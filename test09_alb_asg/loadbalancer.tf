# 1. ALB 전용 보안 그룹 (Security Group)
# 외부 손님이 들어올 수 있게 80(HTTP)과 443(HTTPS)을 열어줍니다.
resource "aws_security_group" "alb_sg" {
  name        = "lecture-alb-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main.id # 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

# 2. ALB 본체 (Load Balancer L7)
resource "aws_lb" "web_alb" {
    name = "lecture-alb"
    internal = false # 외부 노출용
    load_balancer_type = "application" # 로드밸랜서 종류
    security_groups = [aws_security_group.alb_sg.id] # 위에서 정의한 보안그룹 적용
    # 고가용성을 위해 최소 2개의 public subnet 을 제공해야 한다.
    subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    # tag
    tags =  {
        Name = "lecture-alb"
    }
}

# 3. ALB가 받은 요청을 최종적으로 전달할 대상그룹
resource "aws_lb_target_group" "web_tg" {
    name = "lecture-tg"
    # 대상 ec2에서 돌아가는 web 서버의 port 번호(변경가능)
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
    # 헬스 체크: 로드밸런서가 각 EC2에게 "너 살아있니?"라고 주기적으로 물어보는 설정입니다.
    # 아래 설정은 health_check 를 생략했을때 적용되는 default 옵션
    health_check {
    enabled             = true           # 헬스 체크 기능을 활성화합니다.
    path                = "/"            # EC2의 어느 경로로 접속해서 확인할지 결정합니다. (기본 루트 페이지)
    port                = "traffic-port" # 위에서 설정한 80포트를 그대로 사용하여 확인합니다.
    protocol            = "HTTP"         # 상태 확인 시 사용할 통신 규약입니다.
    
    # [판단 기준]
    healthy_threshold   = 5  # 연속 5번 성공하면 "이 친구 건강하네!"라고 판단 (서비스 투입)
    unhealthy_threshold = 2  # 연속 2번 실패하면 "이 친구 아프네?"라고 판단 (서비스 제외)
    
    # [시간 설정]
    timeout             = 5  # 응답을 기다리는 최대 시간(초). 이 시간 넘기면 실패로 간주합니다.
    interval            = 30 # 다음 확인까지 기다리는 주기(초). 너무 짧으면 서버에 부담을 줍니다.
  }
}

# 4. ALB 리스너
resource "aws_lb_listener" "web_listener" {
  # 이 리스너가 설치될 로드밸런서(ALB)의 고유 주소(ARN)를 지정
  load_balancer_arn = aws_lb.web_alb.arn
  # ALB가 외부(인터넷)로부터 귀를 기울일 포트 번호 (표준 웹 포트: 80)
  port              = "80"
  # 통신 규약 설정 (여기서는 암호화되지 않은 HTTP 사용)
  protocol          = "HTTP"
  # 기본 동작: 80번 포트로 요청이 들어왔을 때 무엇을 할 것인가?
  default_action {
    # "forward"는 받은 요청을 그대로 전달하겠다는 뜻
    type             = "forward"
    # 요청을 전달할 목적지 바구니(Target Group)의 주소 지정
    # 즉, "80번으로 들어온 손님은 web_tg에 담긴 EC2들에게 보내라!"는 명령
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

output "alb_dns_name" {
  description = "여기로 접속하세요!"
  value       = aws_lb.web_alb.dns_name
}