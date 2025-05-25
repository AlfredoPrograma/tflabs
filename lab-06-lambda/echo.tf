data "archive_file" "echo_file_zip" {
  type        = "zip"
  source_file = "${local.builds_dir}/echo/${local.entrypoint}"
  output_path = "${local.builds_dir}/echo/${local.entrypoint}.zip"
}

resource "aws_lambda_function" "echo" {
  filename         = "${local.builds_dir}/echo/${local.entrypoint}.zip"
  role             = aws_iam_role.lambda.arn
  source_code_hash = data.archive_file.echo_file_zip.output_base64sha256
  function_name    = "tflabs-06-lambda-echo"
  runtime          = "provided.al2023"
  handler          = "bootstrap"
}

resource "aws_lambda_permission" "echo_permission" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.echo.function_name
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*"
}

