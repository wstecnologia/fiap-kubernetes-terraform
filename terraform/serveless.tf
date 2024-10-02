# IAM Role para a Lambda
resource "aws_iam_role" "lambda_role" {
  name = "authClientByCPFRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy para a Lambda (Logs)
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "authClientByCPFLambdaPolicy"
  role   = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Pacote da Função Lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

# Função Lambda
resource "aws_lambda_function" "auth_client_by_cpf" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "authClientByCPF"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 10

  environment {
    variables = {
      # Adicione variáveis de ambiente se necessário
    }
  }
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "auth_api" {
  name        = "AuthClientAPI"
  description = "API para autenticação de clientes por CPF"
}

# Recurso /auth
resource "aws_api_gateway_resource" "auth_resource" {
  rest_api_id = aws_api_gateway_rest_api.auth_api.id
  parent_id   = aws_api_gateway_rest_api.auth_api.root_resource_id
  path_part   = "auth"
}

# Método POST no /auth
resource "aws_api_gateway_method" "auth_post" {
  rest_api_id   = aws_api_gateway_rest_api.auth_api.id
  resource_id   = aws_api_gateway_resource.auth_resource.id
  http_method   = "POST"
  authorization = "NONE"
}
# Integração Lambda para o método POST
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.auth_api.id
  resource_id             = aws_api_gateway_resource.auth_resource.id
  http_method             = aws_api_gateway_method.auth_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.auth_client_by_cpf.invoke_arn
}

# Permissão para API Gateway invocar a Lambda
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_client_by_cpf.function_name
  principal     = "apigateway.amazonaws.com"

  # O recurso ARN segue o padrão:
  # arn:aws:execute-api:{region}:{account_id}:{api_id}/*/{http_method}/{resource_path}
  source_arn = "${aws_api_gateway_rest_api.auth_api.execution_arn}/*/POST/auth"
}

# Habilitar CORS para o método POST (Opcional)
resource "aws_api_gateway_method_response" "auth_post_response" {
  rest_api_id = aws_api_gateway_rest_api.auth_api.id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = aws_api_gateway_method.auth_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "auth_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.auth_api.id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = aws_api_gateway_method.auth_post.http_method
  status_code = aws_api_gateway_method_response.auth_post_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_deployment" "auth_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_method_response.auth_post_response,
    aws_api_gateway_integration_response.auth_post_integration_response
  ]

  rest_api_id = aws_api_gateway_rest_api.auth_api.id
  stage_name  = var.stage_name
}

# Saída da URL da API
output "api_invoke_url" {
  description = "URL para invocar a API de Autenticação"
  value       = "${aws_api_gateway_deployment.auth_api_deployment.invoke_url}/auth"
}