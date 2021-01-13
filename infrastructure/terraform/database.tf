resource "aws_dynamodb_table" "talents" {
  name           = "intera_talents"
  read_capacity  = 5
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "openings" {
  name           = "intera_openings"
  read_capacity  = 5
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
