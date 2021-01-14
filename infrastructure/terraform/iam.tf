########################################################
# TALENTS LAMBDA PERMISSIONS
########################################################
resource "aws_iam_role" "iam_intera_talents_lambda_role" {
  name = "iam_intera_talents_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "intera_talents_lambda_log_group" {
  name              = "/aws/lambda/intera_talents_lambda"
  retention_in_days = 7
}

data "aws_iam_policy_document" "iam_intera_talents_lambda_policy" {
  statement {
    actions = [
      "dynamodb:*"
    ]

    effect = "Allow"

    resources = [
      aws_dynamodb_table.talents.arn,
    ]
  }

  statement {
    actions = [
      "sqs:*"
    ]

    effect = "Allow"

    resources = [
      aws_sqs_queue.intera_talents_queue.arn,
      aws_sqs_queue.intera_talents_error_queue.arn,
      aws_sqs_queue.intera_match_queue.arn,
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect = "Allow"

    resources = [
      aws_cloudwatch_log_group.intera_talents_lambda_log_group.arn,
      "${aws_cloudwatch_log_group.intera_talents_lambda_log_group.arn}:log-stream:*",
    ]
  }
}

resource "aws_iam_policy" "iam_intera_talents_lambda_policy" {
  name = "iam_intera_talents_lambda"
  policy = data.aws_iam_policy_document.iam_intera_talents_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "iam_intera_talents_lambda_attach" {
  role       = aws_iam_role.iam_intera_talents_lambda_role.name
  policy_arn = aws_iam_policy.iam_intera_talents_lambda_policy.arn

  depends_on = [
    aws_iam_role.iam_intera_talents_lambda_role
  ]
}

########################################################
# OPENINGS LAMBDA PERMISSIONS
########################################################
resource "aws_iam_role" "iam_intera_openings_lambda_role" {
  name = "iam_intera_openings_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "intera_openings_lambda_log_group" {
  name              = "/aws/lambda/intera_openings_lambda"
  retention_in_days = 7
}

data "aws_iam_policy_document" "iam_intera_openings_lambda_policy" {
  statement {
    actions = [
      "dynamodb:*"
    ]

    resources = [
      aws_dynamodb_table.openings.arn,
    ]
  }

  statement {
    actions = [
      "sqs:*"
    ]

    resources = [
      aws_sqs_queue.intera_openings_queue.arn,
      aws_sqs_queue.intera_openings_error_queue.arn,
      aws_sqs_queue.intera_match_queue.arn,
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect = "Allow"

    resources = [
      aws_cloudwatch_log_group.intera_openings_lambda_log_group.arn,
      "${aws_cloudwatch_log_group.intera_openings_lambda_log_group.arn}:log-stream:*",
    ]
  }
}

resource "aws_iam_policy" "iam_intera_openings_lambda_policy" {
  name = "iam_intera_openings_lambda"
  policy = data.aws_iam_policy_document.iam_intera_openings_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "iam_intera_openings_lambda_attach" {
  role       = aws_iam_role.iam_intera_openings_lambda_role.name
  policy_arn = aws_iam_policy.iam_intera_openings_lambda_policy.arn

  depends_on = [
    aws_iam_role.iam_intera_openings_lambda_role
  ]
}

########################################################
# MATCH LAMBDA PERMISSIONS
########################################################
resource "aws_iam_role" "iam_intera_match_lambda_role" {
  name = "iam_intera_match_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "intera_match_lambda_log_group" {
  name              = "/aws/lambda/intera_match_lambda"
  retention_in_days = 7
}

data "aws_iam_policy_document" "iam_intera_match_lambda_policy" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [
      aws_dynamodb_table.talents.arn,
      aws_dynamodb_table.openings.arn,
    ]
  }

  statement {
    actions = [
      "sqs:*"
    ]

    resources = [
      aws_sqs_queue.intera_match_queue.arn
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect = "Allow"

    resources = [
      aws_cloudwatch_log_group.intera_match_lambda_log_group.arn,
      "${aws_cloudwatch_log_group.intera_match_lambda_log_group.arn}:log-stream:*",
    ]
  }
}

resource "aws_iam_policy" "iam_intera_match_lambda_policy" {
  name = "iam_intera_match_lambda"
  policy = data.aws_iam_policy_document.iam_intera_match_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "iam_intera_match_lambda_attach" {
  role       = aws_iam_role.iam_intera_match_lambda_role.name
  policy_arn = aws_iam_policy.iam_intera_match_lambda_policy.arn

  depends_on = [
    aws_iam_role.iam_intera_match_lambda_role
  ]
}
