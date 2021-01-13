########################################################
# APPSYNC GRAPHQL API
########################################################
resource "aws_iam_role" "api_intera" {
  name = "api_intera"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "appsync.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "iam_api_intera_policy" {
  statement {
    actions = [
      "lambda:InvokeFunction"
    ]

    effect = "Allow"

    resources = [
      aws_lambda_function.intera_talents_lambda.arn,
      aws_lambda_function.intera_openings_lambda.arn,
      aws_lambda_function.intera_match_lambda.arn,
    ]
  }
}

resource "aws_iam_policy" "iam_api_intera_match_policy" {
  name = "iam_api_intera_match_policy"
  policy = data.aws_iam_policy_document.iam_api_intera_policy.json
}

resource "aws_iam_role_policy_attachment" "iam_api_intera_match_policy_attach" {
  role       = aws_iam_role.api_intera.name
  policy_arn = aws_iam_policy.iam_api_intera_match_policy.arn

  depends_on = [
    aws_iam_role.api_intera
  ]
}

resource "aws_appsync_graphql_api" "api_intera" {
  authentication_type = "AWS_IAM"
  name                = "intera_api"
  schema              = file("${path.module}/schema.graphql")
}

########################################################
# APPSYNC TALENT DYNAMO DATASOURCE
########################################################
resource "aws_iam_role_policy" "api_intera_talents_policy" {
  name = "api_intera_talents_policy"
  role = aws_iam_role.api_intera.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_dynamodb_table.talents.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_appsync_datasource" "api_intera_talents_dynamo" {
  api_id           = aws_appsync_graphql_api.api_intera.id
  name             = "api_intera_talents_dynamo"
  service_role_arn = aws_iam_role.api_intera.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.talents.name
  }
}

########################################################
# APPSYNC TALENT LAMBDA DATASOURCE
########################################################
resource "aws_appsync_datasource" "api_intera_talents_lambda" {
  api_id           = aws_appsync_graphql_api.api_intera.id
  name             = "talents_lambda"
  service_role_arn = aws_iam_role.api_intera.arn
  type             = "AWS_LAMBDA"

  lambda_config {
    function_arn = aws_lambda_function.intera_talents_lambda.arn
  }
}

########################################################
# APPSYNC OPENINGS DYNAMO DATASOURCE
########################################################
resource "aws_iam_role_policy" "api_intera_openings_policy" {
  name = "api_intera_openings_policy"
  role = aws_iam_role.api_intera.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_dynamodb_table.openings.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_appsync_datasource" "api_intera_openings_dynamo" {
  api_id           = aws_appsync_graphql_api.api_intera.id
  name             = "api_intera_openings_dynamo"
  service_role_arn = aws_iam_role.api_intera.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.openings.name
  }
}

########################################################
# APPSYNC OPENINGS LAMBDA DATASOURCE
########################################################
resource "aws_appsync_datasource" "api_intera_openings_lambda" {
  api_id           = aws_appsync_graphql_api.api_intera.id
  name             = "openings_lambda"
  service_role_arn = aws_iam_role.api_intera.arn
  type             = "AWS_LAMBDA"

  lambda_config {
    function_arn = aws_lambda_function.intera_openings_lambda.arn
  }
}

########################################################
# APPSYNC RESOLVERS
########################################################

## Query/talents
resource "aws_appsync_resolver" "talents" {
  api_id      = aws_appsync_graphql_api.api_intera.id
  field       = "talents"
  type        = "Query"
  data_source = aws_appsync_datasource.api_intera_talents_dynamo.name

  request_template = <<EOF
{
    "version": "2018-05-29",
    "operation": "Scan",
    "select" : "ALL_ATTRIBUTES",
    "limit": $util.defaultIfNull($ctx.args.limit, 10),
    "nextToken": $util.toJson($util.defaultIfNullOrEmpty($ctx.args.nextToken, null)),
    "filter": $util.toJson($util.defaultIfNullOrEmpty($util.transform.toDynamoDBFilterExpression($ctx.args.filter), null))
}
EOF

  response_template = <<EOF
$util.toJson($ctx.result)
EOF
}

## Query/openings
resource "aws_appsync_resolver" "openings" {
  api_id      = aws_appsync_graphql_api.api_intera.id
  field       = "openings"
  type        = "Query"
  data_source = aws_appsync_datasource.api_intera_openings_dynamo.name

  request_template = <<EOF
{
    "version": "2018-05-29",
    "operation": "Scan",
    "select" : "ALL_ATTRIBUTES",
    "limit": $util.defaultIfNull($ctx.args.limit, 10),
    "nextToken": $util.toJson($util.defaultIfNullOrEmpty($ctx.args.nextToken, null)),
    "filter": $util.toJson($util.defaultIfNullOrEmpty($util.transform.toDynamoDBFilterExpression($ctx.args.filter), null))
}
EOF

  response_template = <<EOF
$util.toJson($ctx.result)
EOF
}

## Mutation/createTalent
resource "aws_appsync_resolver" "create_talent" {
  api_id      = aws_appsync_graphql_api.api_intera.id
  field       = "createTalent"
  type        = "Mutation"
  data_source = aws_appsync_datasource.api_intera_talents_lambda.name

  request_template = <<EOF
{
    "version": "2017-02-28",
    "operation": "Invoke",
    "payload": {
        "scope": "server",
        "field": "createTalent",
        "arguments":  {
          "data": $utils.toJson($ctx.arguments.data)
        }
    }
}
EOF

  response_template = <<EOF
## Raise a GraphQL field error in case of a datasource invocation error
#if ($ctx.error)
  $util.error($ctx.error.message, $ctx.error.type)
#end

$util.toJson($context.result)
EOF
}

## Mutation/createOpening
resource "aws_appsync_resolver" "create_opening" {
  api_id      = aws_appsync_graphql_api.api_intera.id
  field       = "createOpening"
  type        = "Mutation"
  data_source = aws_appsync_datasource.api_intera_openings_lambda.name

  request_template = <<EOF
{
    "version": "2017-02-28",
    "operation": "Invoke",
    "payload": {
        "scope": "server",
        "field": "createOpening",
        "arguments":  {
          "data": $utils.toJson($ctx.arguments.data)
        }
    }
}
EOF

  response_template = <<EOF
## Raise a GraphQL field error in case of a datasource invocation error
#if ($ctx.error)
  $util.error($ctx.error.message, $ctx.error.type)
#end

$util.toJson($context.result)
EOF
}
