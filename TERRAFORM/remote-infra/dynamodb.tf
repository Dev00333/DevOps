resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "my_dynamodb_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = "my_dynamodb_table"
    Environment = "production"
  }
}