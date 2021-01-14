resource "aws_sqs_queue" "intera_talents_queue" {
  name                       = "intera_talents_queue"
  max_message_size           = 4096
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 30
}

resource "aws_lambda_event_source_mapping" "intera_talents_queue_lambda_event" {
  event_source_arn = aws_sqs_queue.intera_talents_queue.arn
  function_name    = aws_lambda_function.intera_talents_lambda.arn
  batch_size       = 1

  depends_on       = [
    aws_sqs_queue.intera_talents_queue,
    aws_lambda_function.intera_talents_lambda,
  ]
}

resource "aws_sqs_queue" "intera_talents_error_queue" {
  name                      = "intera_talents_error_queue"
  max_message_size          = 4096
  message_retention_seconds = 86400
  visibility_timeout_seconds = 30
}

resource "aws_sqs_queue" "intera_openings_queue" {
  name                      = "intera_openings_queue"
  max_message_size          = 4096
  message_retention_seconds = 86400
  visibility_timeout_seconds = 30
}

resource "aws_lambda_event_source_mapping" "intera_openings_queue_lambda_event" {
  event_source_arn = aws_sqs_queue.intera_openings_queue.arn
  function_name    = aws_lambda_function.intera_openings_lambda.arn
  batch_size       = 1

  depends_on       = [
    aws_sqs_queue.intera_openings_queue,
    aws_lambda_function.intera_openings_lambda,
  ]
}

resource "aws_sqs_queue" "intera_openings_error_queue" {
  name                      = "intera_openings_error_queue"
  max_message_size          = 4096
  message_retention_seconds = 86400
  visibility_timeout_seconds = 30
}

resource "aws_sqs_queue" "intera_match_queue" {
  name                      = "intera_match_queue"
  max_message_size          = 4096
  message_retention_seconds = 86400
  visibility_timeout_seconds = 30
}

resource "aws_lambda_event_source_mapping" "intera_match_queue_lambda_event" {
  event_source_arn = aws_sqs_queue.intera_match_queue.arn
  function_name    = aws_lambda_function.intera_match_lambda.arn
  batch_size       = 1

  depends_on       = [
    aws_sqs_queue.intera_match_queue,
    aws_lambda_function.intera_match_lambda,
  ]
}
