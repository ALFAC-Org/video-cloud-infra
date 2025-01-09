terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
  }

  required_version = ">= 1.2.0"
}

# We don't define the provider's credentials here because we are using the AWS CLI to authenticate.
# https://registry.terraform.io/providers/hashicorp/aws/5.65.0/docs?utm_content=documentLink&utm_medium=Visual+Studio+Code&utm_source=terraform-ls#environment-variables
provider "aws" {
  region = var.aws_region
  alias  = "us-east-1"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.video_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.video_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.video_cluster_auth.token
}

# # S3 Bucket issues
# # ref: https://stackoverflow.com/a/62205598/3929980
# module "video-bucket" {
#   source = "mod-s3-bucket"
#   bucket_region = "us-east-1"
#   bucket_name = "hackathon-video-studio-bucket"
# }