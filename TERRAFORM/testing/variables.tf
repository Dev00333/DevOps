variable "aws_instance_type" {
  description = "type of instance"
  default = "t3.micro"
  type = string
}
variable "aws_ami" {
  description = "ami id for the instance"
  default = "ami-080254318c2d8932f"
  type = string
}
variable "aws_key_pair" {
  description = "key pair for the instance"
  default = "testing"
  type = string
}
variable "aws_root_storage_size" {
  description = "size of the root storage volume in gb"
  default = 8
  type = number  
}
variable "aws_root_storage_type" {
  description = "type of root storage volume to create"
  default = "gp3"
  type = string  
}