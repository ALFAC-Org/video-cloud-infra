resource "aws_sns_topic" "user_updates" {
  name = "envia_email_erro_processecamento"
  display_name = "Envia email de erro de processamento"
  kms_master_key_id = "alias/aws/sns" //encryption
}

resource "aws_sns_topic_subscription" "lambda_email_subscription" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.envia_email_erro_processamento.arn

  depends_on = [
    aws_lambda_permission.allow_sns_invoke
  ]
}