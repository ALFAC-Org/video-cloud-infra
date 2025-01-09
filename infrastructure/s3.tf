terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "video" {
  bucket = "hackathon-video-studio-bucket"
  region = "us-east-1"

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
  bucket = "hackathon-video-studio-zip-bucket"
  region = "us-east-1"

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
