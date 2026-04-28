resource "aws_s3_bucket" "remote-s3-devang" {
    bucket = "my-remote-s3-bucket-devang"
    tags = {
        Name = "my-remote-s3-bucket-devang"
        environment = "Dev"
    }
}