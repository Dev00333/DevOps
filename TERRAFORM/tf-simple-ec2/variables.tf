variable "aws_instance_type" {
    default = "t3.micro"
    type = string
}
variable "ec2_default_aws_root_storage_size" {
    default = 8
    type = number
}
variable "ec2_ami" {
    default = "ami-080254318c2d8932f"
    type = string
}
variable "aws_root_storage_type" {
    default = "gp3"
    type = string
}
variable "aws_instance_count" {
  default = 2
  type = number
}

variable "env" {
  default = "prd"
  type = string
}