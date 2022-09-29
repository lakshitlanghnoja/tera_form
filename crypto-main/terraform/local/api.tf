resource "aws_api_gateway_rest_api" "crypto_api" {
  # oak9: aws_api_gateway_rest_api.policy is not configured
  name        = "CryptoAPI"
  description = "This is a Crypto API"
}

resource "aws_api_gateway_resource" "crypto_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.crypto_api.id
  parent_id   = aws_api_gateway_rest_api.crypto_api.root_resource_id
  path_part   = "crypto"
}

resource "aws_api_gateway_method" "crypto_api_get" {
  rest_api_id   = aws_api_gateway_rest_api.crypto_api.id
  resource_id   = aws_api_gateway_resource.crypto_api_resource.id
  http_method   = "POST"
  authorization = "NONE" # oak9: authorization should be set to any of aws_iam, custom, cognito_user_pools
}

resource "aws_api_gateway_integration" "crypto_integration" {
  rest_api_id             = aws_api_gateway_rest_api.crypto_api.id
  resource_id             = aws_api_gateway_resource.crypto_api_resource.id
  http_method             = aws_api_gateway_method.crypto_api_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.crypto_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "crypto_deployment" {
  rest_api_id = aws_api_gateway_rest_api.crypto_api.id
  stage_name = "test"
}
