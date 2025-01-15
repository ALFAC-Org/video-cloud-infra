terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "video" {
  bucket   = "hackathon-video-studio-bucket"
  provider = aws.main

  tags = {
    Name = "hackathon-video-studio-bucket"
  }

  # Garante que irá destruir o bucket 
  # quando o comando terraform destroy for executado
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "zip" {
  bucket   = "hackathon-video-studio-zip-bucket"
  provider = aws.main

  tags = {
    Name = "hackathon-video-studio-zip-bucket"
  }

  # Garante que irá destruir o bucket 
  # quando o comando terraform destroy for executado
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

//Cria o bucket para as lambdas
resource "aws_s3_bucket" "lambdas" {
  bucket   = var.lambdas_bucket_name
  provider = aws.main

  tags = {
    Name = "lambdas"
  }
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

// Faz o upload do arquivo zip para o bucket
resource "aws_s3_object" "lambda_envia_email_erro_processamento" {
  bucket = aws_s3_bucket.lambdas.bucket
  key    = "envia_email_erro_processamento.zip"
  source = "${path.module}/envia_email_erro_processamento.zip"
}