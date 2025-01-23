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

  lifecycle_rule {
    id      = "delete-old-files"
    enabled = true

    expiration {
      days = 7
    }

    noncurrent_version_expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_object" "videos_folder" {
  bucket = aws_s3_bucket.video.bucket
  key    = "videos/"
}

resource "aws_s3_bucket_object" "zip_folder" {
  bucket = aws_s3_bucket.video.bucket
  key    = "zip/"
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

// Faz o upload do arquivo zip para o bucket
resource "aws_s3_object" "lambda_video_slicer" {
  bucket = aws_s3_bucket.lambdas.bucket
  key    = "video_slicer.zip"
  source = "${path.module}/video_slicer.zip"
}