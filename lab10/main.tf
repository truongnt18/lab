provider "aws" {
  region = "ap-southeast-1"
}



# IAM Role for Lambda function, adjust permissions as needed)
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-integration-apigw-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = [
    aws_iam_policy.lambda_putlog_policy.arn
  ]

}
resource "aws_iam_policy" "lambda_putlog_policy" {
  name   = "lambda-putlog-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_putlog_policy.json
}
data "aws_iam_policy_document" "lambda_putlog_policy" {
  #checkov:skip=CKV_AWS_111: Suspression

  statement {
    sid = "CreateLogGroup"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = ["arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    sid = "PutLogEvent"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/lambda-integration:*"]
  }

}



# Define the Lambda function
resource "aws_lambda_function" "integration_lambda" {
  filename      = "./lambda_function/lambda_integration.zip"
  function_name = "lambda-integration"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
}



resource "aws_apigatewayv2_api" "http_api" {
  name          = "person"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.integration_lambda.invoke_arn

  payload_format_version = "2.0"

}

resource "aws_apigatewayv2_route" "get_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /getPerson"
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_stage" "test" {
  api_id = aws_apigatewayv2_api.http_api.id
  name   = "test"
  auto_deploy = true
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIPersonInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.integration_lambda.arn
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*/getPerson"  #"arn:aws:execute-api:ap-southeast-1:150455926741:gijdccbs36/*/*/getPerson"
}

output "api_endpoint_url" {
  value = aws_apigatewayv2_stage.test.invoke_url 
}







