provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "video" {
  bucket = "video-bucket"

  tags = {
    Name = "video-bucket"
  }

  # Garante que irá destruir o bucket 
  # quando o comando terraform destroy for executado
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "zip" {
  bucket = "zip-bucket"

  tags = {
    Name = "zip-bucket"
  }

  # Garante que irá destruir o bucket 
  # quando o comando terraform destroy for executado
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}
