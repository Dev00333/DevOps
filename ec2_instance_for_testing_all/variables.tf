variable "aws_instance_type" {
    default = "m7i-flex.large"
    type = string
}
variable "ami_id" {
    default = "ami-05d62b9bc5a6ca605"
    type = string
}
variable "aws_root_storage_type" {
    default = "gp3"
    type = string
}
variable "aws_root_storage_size" {
    default = 30
    type = number
}