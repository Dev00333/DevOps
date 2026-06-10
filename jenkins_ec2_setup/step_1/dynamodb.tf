resource aws_dynamodb_table basic-dynamo-dynamodb {
    name = "remote-db-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
    tags = {
        Name = "remote-db-table"
        Environment = "production"
    }
}