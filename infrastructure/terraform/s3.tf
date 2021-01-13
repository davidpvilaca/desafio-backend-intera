resource "aws_s3_bucket" "intera_lambda_repository" {
  bucket = "intera-lambda-repository"
  acl    = "private"
}
