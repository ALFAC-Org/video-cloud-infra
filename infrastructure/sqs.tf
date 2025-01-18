resource "aws_sqs_queue" "videos_to_process" {
  name = "videos_to_process"

# TODO: Adicionar essa police para permitir que o Video_Studio post a mensagem na fila e que o video_slicer receba a mensagem

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
#       },
#       "Action": "sqs:SendMessage",
#       "Resource": "${aws_sqs_queue.videos_to_process.arn}"
#     },
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
#       },
#       "Action": "sqs:ReceiveMessage",
#       "Resource": "${aws_sqs_queue.videos_to_process.arn}"
#     }
#   ]
# }
# POLICY
}

resource "aws_sqs_queue" "update_processing_status" {
  name = "update_processing_status"

# TODO: Adicionar police para que o video_slicer possa postar mensagens na fila e que o Video_Studio possa receber mensagens

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
#       },
#       "Action": "sqs:SendMessage",
#       "Resource": "${aws_sqs_queue.update_processing_status.arn}"
#     },
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
#       },
#       "Action": "sqs:ReceiveMessage",
#       "Resource": "${aws_sqs_queue.update_processing_status.arn}"
#     }
#   ]
# }
# POLICY
}
