resource "aws_sqs_queue" "videos_to_process" {
  name                      = "videos_to_process"
  visibility_timeout_seconds = 900
}

resource "aws_sqs_queue" "update_processing_status" {
  name = "update_processing_status"
}

resource "aws_sqs_queue_policy" "videos_to_process_policy" {
  queue_url = aws_sqs_queue.videos_to_process.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForLambdaAndEKSAccess"
    Statement = [
      {
        Sid       = "AllowLambdaToReceiveMessages"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action   = [
          "SQS:ReceiveMessage",
          "SQS:DeleteMessage"
        ]
        Resource = aws_sqs_queue.videos_to_process.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_lambda_function.video_slicer.arn
          }
        }
      },
      {
        Sid       = "AllowEKSAccess"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action   = [
          "SQS:SendMessage"
        ]
        Resource = aws_sqs_queue.videos_to_process.arn
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "update_processing_status_policy" {
  queue_url = aws_sqs_queue.update_processing_status.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForLambdaAndEKSAccess"
    Statement = [
      {
        Sid       = "AllowLambdaToReceiveMessages"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action   = [
          "SQS:SendMessage"
        ]
        Resource = aws_sqs_queue.update_processing_status.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_lambda_function.video_slicer.arn
          }
        }
      },
      {
        Sid       = "AllowEKSAccess"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action   = [
          "SQS:ReceiveMessage",
          "SQS:DeleteMessage"
        ]
        Resource = aws_sqs_queue.update_processing_status.arn
      }
    ]
  })
}