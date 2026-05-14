# version 명시하기 
terraform {
  required_version = "~>1.14.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}

# 1. provider 설정
provider "aws" {
    region = "ap-northeast-2" # 서울 리전 
}

# 2. VPC 및 네트워크 생성 (인프라의 기초 공사)
resource "aws_vpc" "main" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags                 = { Name = "lecture-vpc" }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "igw" {
    vpc_id  = aws_vpc.main.id
    tags    = { Name = "lecture-igw"}
}

# 가용 영역 데이터 가져오기
data "aws_availability_zones" "available"{
    state = "available"
}

# Public Subnet (NAT GW가 위치할 곳)
resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24" 
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true 
    tags = { Name = "lecture-public-subnet" }
}

# Public 라우팅 테이블
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    # vpc 대역이 아닌 다른 모든 ip 에 대한 요청은 internet gateway 로보내겠다
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

# public subnet 을 public_rt 로 연결
resource  "aws_route_table_association" "public_a" {
    subnet_id      = aws_subnet.public_subnet.id 
    route_table_id = aws_route_table.public_rt.id 
}

# NAT Gateway용 탄력적 IP(EIP)
resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags   = { Name = "lecture-nat-eip" }
}

# NAT Gateway 생성 (반드시 Public Subnet에 위치해야 함)
resource "aws_nat_gateway" "nat_gw" {
    # 탄력적 ip를 NAT에 연결
    allocation_id = aws_eip.nat_eip.id
    # 인터넷이 가능한 subnet 에 위치 시키기
    subnet_id     = aws_subnet.public_subnet.id
    tags          = { Name = "lecture-nat-gw" }
    
    # 인터넷 게이트웨이가 먼저 생성되어 있어야 NAT GW가 정상 작동합니다.
    depends_on    = [aws_internet_gateway.igw]
}

# ----------------------------------------------------
# Private Subnet 구성 (EC2가 위치할 곳)
# ----------------------------------------------------
resource "aws_subnet" "private_subnet" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.2.0/24" 
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false # Public IP 할당 안 함
    tags = { Name = "lecture-private-subnet" }
}

# Private 라우팅 테이블
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id
    
    # 외부(인터넷)로 나가는 모든 트래픽을 NAT Gateway로 전송
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }
}

resource "aws_route_table_association" "private_a" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}

# ----------------------------------------------------
# Tailscale 온프레미스 연동 라우팅 (Public & Private 모두 적용)
# ----------------------------------------------------
# Public Subnet에서 172.16.8.0/24로 갈 때 대장 EC2를 거치도록 설정 (my_ec2 는 아래에 정의할 예정)

# aws_route 는 미리 만들어 놓은 aws_route_table 에 라우팅 정보를 추가하는 용도로 사용할 수 있다.
resource "aws_route" "to_onpremise_public" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "172.16.8.0/24"
  network_interface_id   = aws_instance.my_ec2.primary_network_interface_id
}

# Private Subnet에서 172.16.8.0/24로 갈 때 대장 EC2를 거치도록 설정
resource "aws_route" "to_onpremise_private" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "172.16.8.0/24"
  network_interface_id   = aws_instance.my_ec2.primary_network_interface_id
}

# 3. 보안 및 키 설정
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

resource "aws_security_group" "ssh_sg" {
    name   = "allow-ssh"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port   = 22 
        to_port     = 22 
        protocol    = "tcp" 
        cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
        from_port   = 5432 
        to_port     = 5432 
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

#  EC2 인스턴스 검색
data "aws_ami" "latest_al2023" {
    most_recent   = true
    owners        = ["amazon"]
    filter {
        name   = "name"
        values = ["al2023-ami-*-x86_64"] 
    }
}

resource "aws_instance" "my_ec2" {
    ami                     = data.aws_ami.latest_al2023.id 
    instance_type           = "t3.micro" 
    
    # [수정] EC2를 Private Subnet에 배치
    subnet_id               = aws_subnet.private_subnet.id       
    
    vpc_security_group_ids  = [aws_security_group.ssh_sg.id] 
    key_name                = aws_key_pair.kp.key_name  
    source_dest_check       = false  
    
    # 대장 ec2가 만들어지는 시점에 tailscale에 접속해서 vpn 연결을 활성화 하는 작업을 script 구현하겠다
    # 조금 복잡하지만 다음 예제에서는 이걸 tailscale terraform 의 기능을 이용해서 조금더 간단히 구현할 수 있다.
    user_data = <<-EOF
        #!/bin/bash
        # 로그 파일 생성 및 모든 출력 기록
        exec > >(tee -a /var/log/user_data_final.log) 2>&1

        # 1. 호스트네임 및 시스템 기본 설정
        hostnamectl set-hostname "${var.host_name}"
        echo "127.0.0.1 ${var.host_name}" >> /etc/hosts
        dnf install -y jq

        # 2. Tailscale 설치 및 IP 포워딩 활성화
        curl -fsSL https://tailscale.com/install.sh | sh
        systemctl enable --now tailscaled
        
        # 3. IP Forwarding 활성화
        cat <<EOT > /etc/sysctl.d/99-tailscale.conf
        net.ipv4.ip_forward = 1
        net.ipv6.conf.all.forwarding = 1
        EOT
        sysctl -p /etc/sysctl.d/99-tailscale.conf

        # 4. Tailscale 로그인 및 경로 광고 (Subnet Router 설정)
        tailscale up --authkey=${var.tailscale_auth_key} --advertise-routes=${aws_vpc.main.cidr_block} --accept-routes

        # 5. 기기 찾기 : 최대 6번(총 2분) 동안 기기 ID를 찾을 때까지 재시도
        DEVICE_ID=""
        for i in {1..6}; do
            echo "API 조회 시도 $i/6..."
            
            DEVICES_JSON=$(curl -s -u "${var.tailscale_api_key}:" "https://api.tailscale.com/api/v2/tailnet/${var.tailnet_name}/devices")
            DEVICE_ID=$(echo $DEVICES_JSON | jq -r --arg HOST "${var.host_name}" '.devices[] | select(.hostname == $HOST) | .id')

            if [ -n "$DEVICE_ID" ] && [ "$DEVICE_ID" != "null" ]; then
                echo "기기 발견! ID: $DEVICE_ID"
                break
            fi
            
            echo "아직 기기가 목록에 없습니다. 20초 후 다시 시도합니다..."
            sleep 20
        done

        # 6. ID가 확인되면 라우팅 승인 API 전송
        if [ -z "$DEVICE_ID" ] || [ "$DEVICE_ID" == "null" ]; then
            echo "Error: Device ID not found. Please check Tailscale Admin Console."
        else
            echo "Sending Route Approval API..."
            curl -s -u "${var.tailscale_api_key}:" -X POST "https://api.tailscale.com/api/v2/device/$DEVICE_ID/routes" \
                 -H "Content-Type: application/json" \
                 -d "{\"routes\": [\"${aws_vpc.main.cidr_block}\"]}"
            echo "Process Completed Successfully."
        fi
    EOF
    
    tags = {
        Name = "my-ec2"
    }
}

# Public IP 출력 제거 및 Private IP만 유지
output "instance_private_ip"{
    description = "만들어진 ec2 의 private ipv4 주소"
    value = aws_instance.my_ec2.private_ip
}

resource "local_file" "ansible_inventory"{
    filename = "${path.module}/inventory.yml"
    content = yamlencode({
        all = {
            hosts = {
                # [수정] 인벤토리에 EC2의 Private IP 기록
                "${aws_instance.my_ec2.private_ip}" = {
                    ansible_user = "ec2-user"
                    ansible_ssh_private_key_file = "${path.module}/lecture-key.pem"
                }
            }
        }
    })
}

resource "local_file" "ansible_config"{
    filename = "${path.module}/ansible.cfg"
    content = <<-EOF
        [defaults]
        inventory = ./inventory.yml
        host_key_checking = False
    EOF
}

resource "terraform_data" "wait_for_instance"{
    depends_on = [aws_instance.my_ec2, local_file.ansible_inventory, local_file.ansible_config]
    triggers_replace = aws_instance.my_ec2.id

    provisioner "local-exec" {
        # user_data에서 Tailscale 세팅이 완벽히 끝날 때까지 넉넉하게 대기 (2분 30초)
        # Tailscale 경로가 PC까지 갱신되어야 Ansible이 Private IP로 접근 가능합니다.
        command = "sleep 150"
    }
}

resource "terraform_data" "ansible_run"{
    depends_on = [ terraform_data.wait_for_instance ]
    triggers_replace = {
        instance_id = aws_instance.my_ec2.id
        always_run  = "${timestamp()}" 
    }
    provisioner "local-exec" {
      # command = "ANSIBLE_SSH_PIPELINING=1 ansible-playbook site.yml"
        command = "echo 'tailscale success!' "
    }
}

# 변수정의
variable "host_name" {
    type = string
    default = "db-server"
}
variable "tailnet_name"{
    type = string
}
variable "tailscale_auth_key"{
    type = string
    sensitive = true
}
variable "tailscale_api_key"{
    type = string
    sensitive = true
}
