resource "aws_lambda_function" "envia_email_erro_processamento" {
  function_name = "envia_email_erro_processamento"
  role          = var.node_role_arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  s3_bucket     = var.lambdas_bucket_name
  s3_key        = "envia_email_erro_processamento.zip"

  depends_on = [
    aws_s3_object.lambda_envia_email_erro_processamento,
  ]
}

// Adiciona o SNS como trigger para a lambda
resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.envia_email_erro_processamento.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.user_updates.arn
}