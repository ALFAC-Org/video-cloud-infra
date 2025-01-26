resource "aws_lambda_function" "envia_email_erro_processamento" {
  function_name = "envia_email_erro_processamento"
  role          = var.arn_aws_lab_role
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  s3_bucket     = var.lambdas_bucket_name
  s3_key        = "envia_email_erro_processamento.zip"

  # Aqui só criamos um placeholder para evitar que o Terraform faça alterações no futuro
  environment {
    variables = {
      ALFAC_ORG_EMAIL          = "THIS_VALUE_WILL_BE_UPDATED_BY__SERVELESS_REPOSITORY"
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

resource "aws_lambda_function" "video_slicer" {
  function_name = "video_slicer"
  role          = var.arn_aws_lab_role
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  s3_bucket     = var.lambdas_bucket_name
  s3_key        = "video_slicer.zip"
  memory_size   = 256
  timeout       = 900
  vpc_config {
    security_group_ids = [aws_vpc.video_vpc.default_security_group_id]
    subnet_ids = [aws_subnet.video_private_subnet_1.id,
    aws_subnet.video_private_subnet_2.id]
  }

  ephemeral_storage {
    size = 1024
  }

  # Aqui só criamos um placeholder para evitar que o Terraform faça alterações no futuro
  environment {
    variables = {
      TO_PROCESS_QUEUE_URL = aws_sqs_queue.videos_to_process.url
      STATUS_QUEUE_URL     = aws_sqs_queue.update_processing_status.url
      LAMBDA_BUCKET_NAME   = aws_s3_bucket.video.bucket
    }
  }

  lifecycle {
    ignore_changes = [
      environment[0].variables
    ]
  }

  depends_on = [
    aws_s3_object.lambda_video_slicer,
  ]
}

// Adiciona permissões para o SQS
resource "aws_lambda_permission" "allow_sqs_invoke" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.video_slicer.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.videos_to_process.arn
}

// Adiciona o mapeamento de fonte de evento SQS para a lambda
resource "aws_lambda_event_source_mapping" "sqs_lambda_mapping" {
  event_source_arn = aws_sqs_queue.videos_to_process.arn
  function_name    = aws_lambda_function.video_slicer.arn
  batch_size       = 1
  enabled          = true
}