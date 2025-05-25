resource "aws_apigatewayv2_api" "api" {
  name          = "tflabs-06-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "hello_world" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  description            = "Get a hello world"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.hello_world.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "echo" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  description            = "Echo endpoint"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.echo.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /hello-world"
  target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
}

resource "aws_apigatewayv2_route" "echo" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /echo"
  target    = "integrations/${aws_apigatewayv2_integration.echo.id}"
}


resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "dev"
  auto_deploy = true
}
