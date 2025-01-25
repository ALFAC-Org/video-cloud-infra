# EKS Cluster
resource "aws_eks_cluster" "video_cluster" {
  name     = var.cluster_name
  role_arn = var.arn_aws_lab_role

  vpc_config {
    subnet_ids = [
      aws_subnet.video_public_subnet_1.id,
      aws_subnet.video_public_subnet_2.id,
      aws_subnet.video_private_subnet_1.id,
      aws_subnet.video_private_subnet_2.id
    ]
    
    security_group_ids = [aws_security_group.eks_security_group.id]
  }

  tags = {
    Name = "video_cluster"
  }
}

data "aws_eks_cluster_auth" "video_cluster_auth" {
  name = aws_eks_cluster.video_cluster.name
}

# EKS Node Group
resource "aws_eks_node_group" "video_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "video_node_group"
  node_role_arn   = var.arn_aws_lab_role
  subnet_ids      = [
    aws_subnet.video_private_subnet_1.id, 
    aws_subnet.video_private_subnet_2.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  lifecycle {
    prevent_destroy = false
  }

  instance_types = [var.instance_type]
  disk_size      = 20

  # remote_access {
  #   ec2_ssh_key = var.ssh_key_name
  #   # source_security_group_ids = [aws_security_group.video_sg.id]
  # }

  ami_type = "AL2_x86_64"

  depends_on = [aws_eks_cluster.video_cluster]

  labels = {
    environment = var.environment
  }

  tags = {
    Name        = "video_node_group"
    Environment = var.environment
  }
}

# resource "aws_key_pair" "video_ssh_key" {
#   key_name   = var.ssh_key_name
#   public_key = file("${var.ssh_key}.pub")
# }

# Security group to EKS Cluster
resource "aws_security_group" "eks_security_group" {
  vpc_id = aws_vpc.video_vpc.id
  description = "Allow traffic for EKS Cluster"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-sg"
    Environment = var.environment
  }
}
