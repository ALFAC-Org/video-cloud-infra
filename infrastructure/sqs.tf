resource "aws_sqs_queue" "videos_to_process" {
  name = "videos_to_process"

# TODO: Adicionar essa police para permitir que o Video_Studio post a mensagem na fila e que o video_slicer receba a mensagem

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PolicyForLambdaAndEKSAccess",
  "Statement": [
    {
      "Sid": "AllowLambdaToReceiveMessages",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": [
        "SQS:ReceiveMessage",
        "SQS:DeleteMessage"
      ],
      "Resource": aws_sqs_queue.videos_to_process.arn,
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": aws_lambda_function.video_slicer.arn
        }
      }
    },
    {
      "Sid": "AllowEKSAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": [
        "SQS:SendMessage"
      ],
      "Resource": aws_sqs_queue.videos_to_process.arn
    }
  ]
}
POLICY
}

resource "aws_sqs_queue" "update_processing_status" {
  name = "update_processing_status"

# TODO: Adicionar police para que o video_slicer possa postar mensagens na fila e que o Video_Studio possa receber mensagens

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PolicyForLambdaAndEKSAccess",
  "Statement": [
    {
      "Sid": "AllowLambdaToReceiveMessages",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": [
        "SQS:SendMessage"
      ],
      "Resource": aws_sqs_queue.videos_to_process.arn,
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": aws_lambda_function.video_slicer.arn
        }
      }
    },
    {
      "Sid": "AllowEKSAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": [
        "SQS:ReceiveMessage",
        "SQS:DeleteMessage"
      ],
      "Resource": aws_sqs_queue.videos_to_process.arn
    }
  ]
}
POLICY
}