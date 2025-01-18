resource "aws_lambda_function" "envia_email_erro_processamento" {
  function_name = "envia_email_erro_processamento"
  role          = var.node_role_arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  s3_bucket     = var.lambdas_bucket_name
  s3_key        = "envia_email_erro_processamento.zip"

  # Aqui só criamos um placeholder para evitar que o Terraform faça alterações no futuro
  environment {
    variables = {
      ALFAC_ORG_EMAIL = "THIS_VALUE_WILL_BE_UPDATED_BY__SERVELESS_REPOSITORY"
      ALFAC_ORG_EMAIL_PASSWORD = "THIS_VALUE_WILL_BE_UPDATED_BY_SERVELESS_REPOSITORY"
    }
  }

  # E aqui é onde garantimos que o Terraform não faça alterações nas variáveis de ambiente
  lifecycle {
    ignore_changes = [
      environment[0].variables
    ]
  }

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
  source_arn    = aws_sns_topic.video_erro_processamento.arn
}
