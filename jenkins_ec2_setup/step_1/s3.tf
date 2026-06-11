resource aws_s3_bucket remote-s3-devang {
    bucket = "remote-backend-backup"
    force_destroy = true
    tags = {
        Name = "remote-backend-backup"
        environment = "Dev"
    }
}