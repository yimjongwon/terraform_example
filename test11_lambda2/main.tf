provider "aws" {
    region = "ap-northeast-2" # 서울 리전
}

# 1. python 소스코드 직접 준비
resource "local_file" "lambda_code" {
  filename = "${path.module}/hello_lambda.py"
  content  = <<-EOT
    import json
    def handler(event, context):
        return {
            'statusCode': 200,
            'body': json.dumps('Hello from Serverless Lambda! [LIVE TEST SUCCESS]')
        }
  EOT
}

# nodejs (javascript) 소스코드
resource "local_file" "node_code" {
  filename = "${path.module}/src_node/index.js"
  content  = <<-EOT
    exports.handler = async (event) => {
        const response = {
            statusCode: 200,
            body: JSON.stringify('Hello from Node.js 18 Lambda! [SUCCESS]'),
        };
        return response;
    };
  EOT
}

# javascript code 도 압축하기
data "archive_file" "node_zip" {
  type        = "zip"
  source_file = local_file.node_code.filename
  output_path = "${path.module}/dist/hello_node.zip"
}

resource "aws_lambda_function" "node_lambda" {
  filename         = data.archive_file.node_zip.output_path
  function_name    = "Serverless-Test-Node"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler" # 💡 파일명.수출함수명 (index.js 의 exports.handler 명세)
  source_code_hash = data.archive_file.node_zip.output_base64sha256
  runtime          = "nodejs18.x"     # 💡 모던 정석 Node 런타임 주파수 매핑
}

# =========================================================================
#  2. 생성된 파이썬 파일을 AWS 배포용 ZIP 파일로 압축
# =========================================================================
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = local_file.lambda_code.filename
  output_path = "${path.module}/hello_lambda.zip"
}

# =========================================================================
#  3. 람다 기본 일꾼 전용 최소 실행 권한 신분증 (IAM Role)
# =========================================================================
resource "aws_iam_role" "lambda_role" {
  # name = "serverless_lambda_test_role"
  # 
  name_prefix = "serverless_lambda_test_role-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# AWS 순정 람다 베이직 실행 권한 정책(CloudWatch 로그 기록용 권한) 추가 바인딩
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# =========================================================================
# 4. AWS Lambda 단독 함수 엔진 
# =========================================================================
resource "aws_lambda_function" "hello" {
    # 압축 해제한 파일명
    filename         = data.archive_file.lambda_zip.output_path
    # 함수의 이름은 마음대로
    function_name    = "ServerlessTestHandler"
    # role 정보 연결
    role             = aws_iam_role.lambda_role.arn
    # hello_lambda 파일 안에 있는 handler 라는 이름의 함수를 사용하겠다는 의미
    handler          = "hello_lambda.handler" # [파이썬파일명].[함수명] 매핑
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256 # 코드 바뀔 때마다 변경 감지 자동 갱신
    # python 3.9 환경에서 실행되도록 한다
    runtime          = "python3.9"
}

# =========================================================================
# 5. API Gateway 없이 호출할수 있는 Function URL
# =========================================================================
resource "aws_lambda_function_url" "lambda_url" {
  function_name      = aws_lambda_function.hello.function_name
  authorization_type = "NONE" # 웹 브라우저나 포스트맨에서 퍼블릭으로 요청할수 있게 오픈
  
  # 프론트엔드 CORS 허용
  cors {
    allow_origins = ["*"]
    allow_methods = ["GET"]
  }
}

resource "aws_lambda_function_url" "node_url" {
  function_name      = aws_lambda_function.node_lambda.function_name
  authorization_type = "NONE"
  cors {
    allow_origins = ["*"]
    allow_methods = ["GET"]
  }
}

# =========================================================================
# 6. Output (테스트용 최종 API )
# =========================================================================
output "test_lambda_url" {
  value       = aws_lambda_function_url.lambda_url.function_url
  description = "배포 완료 후 웹 브라우저나 크롬창에 생자로 복붙해서 테스트할 다이렉트 주소!"
}

output "test_lambda_url2" {
  value       = aws_lambda_function_url.node_url.function_url
  description = "노드JS(자바스크립트) 람다 호출 주소"
}
