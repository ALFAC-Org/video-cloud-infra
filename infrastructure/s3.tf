terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "video" {
  bucket = "video-bucket"

  # Garante que irá destruir o bucket 
  # quando o comando terraform destroy for executado
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "zip" {
  bucket = "zip-bucket"

  # Garante que irá destruir o bucket 
  # quando o comando terraform destroy for executado
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}
