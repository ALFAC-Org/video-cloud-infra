resource "aws_sns_topic" "video_erro_processamento" {
  name = "envia_email_erro_processamento"
  display_name = "Envia email de erro de processamento"
  kms_master_key_id = "alias/aws/sns" //encryption
}

resource "aws_sns_topic_subscription" "lambda_email_subscription" {
  topic_arn = aws_sns_topic.video_erro_processamento.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.envia_email_erro_processamento.arn

  depends_on = [
    aws_lambda_permission.allow_sns_invoke
  ]
}

//TODO:
// Adicionar access policy para o job que vai processar os status