resource "aws_lambda_function" "intera_talents_lambda" {
  function_name = "intera_talents_lambda"
  role          = aws_iam_role.iam_intera_talents_lambda_role.arn
  handler       = "index.handler"
  s3_bucket     = aws_s3_bucket.intera_lambda_repository.bucket
  s3_key        = "talents/latest.zip"
  runtime       = "nodejs12.x"
  timeout       = 30

  depends_on = [
    aws_iam_role.iam_intera_talents_lambda_role
  ]

  environment {
    variables = {
      "SQS_QUEUE_URL"       = "https://sqs.us-east-2.amazonaws.com/459214935376/intera_talents_queue",
      "SQS_ERROR_QUEUE_URL" = "https://sqs.us-east-2.amazonaws.com/459214935376/intera_talents_error_queue",
      "SQS_MATCH_QUEUE_URL" = "https://sqs.us-east-2.amazonaws.com/459214935376/intera_match_queue",
      "DYNAMO_DB"           = "intera_talents"
    }
  }
}

resource "aws_lambda_function" "intera_openings_lambda" {
  function_name = "intera_openings_lambda"
  role          = aws_iam_role.iam_intera_openings_lambda_role.arn
  handler       = "index.handler"
  s3_bucket     = aws_s3_bucket.intera_lambda_repository.bucket
  s3_key        = "openings/latest.zip"
  runtime       = "nodejs12.x"
  timeout       = 30

  depends_on = [
    aws_iam_role.iam_intera_openings_lambda_role
  ]

  environment {
    variables = {
      "SQS_QUEUE_URL"       = "https://sqs.us-east-2.amazonaws.com/459214935376/intera_openings_queue",
      "SQS_ERROR_QUEUE_URL" = "https://sqs.us-east-2.amazonaws.com/459214935376/intera_openings_error_queue",
      "SQS_MATCH_QUEUE_URL" = "https://sqs.us-east-2.amazonaws.com/459214935376/intera_match_queue",
      "DYNAMO_DB"           = "intera_openings"
    }
  }
}

resource "aws_lambda_function" "intera_match_lambda" {
  function_name = "intera_match_lambda"
  role          = aws_iam_role.iam_intera_match_lambda_role.arn
  handler       = "index.handler"
  s3_bucket     = aws_s3_bucket.intera_lambda_repository.bucket
  s3_key        = "match/latest.zip"
  runtime       = "nodejs12.x"
  timeout       = 30

  depends_on = [
    aws_iam_role.iam_intera_match_lambda_role
  ]
}
