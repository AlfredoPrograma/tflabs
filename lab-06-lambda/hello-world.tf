data "archive_file" "hello_world_zip" {
  type        = "zip"
  source_file = "${local.builds_dir}/hello-world/${local.entrypoint}"
  output_path = "${local.builds_dir}/hello-world/${local.entrypoint}.zip"
}

resource "aws_lambda_function" "hello_world" {
  filename         = "${local.builds_dir}/hello-world/${local.entrypoint}.zip"
  role             = aws_iam_role.lambda.arn
  source_code_hash = data.archive_file.hello_world_zip.output_base64sha256
  function_name    = "tflabs-06-lambda-hello-world"
  runtime          = "provided.al2023"
  handler          = "bootstrap"
}

resource "aws_lambda_permission" "hello_world_permission" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.hello_world.function_name
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*"
}

