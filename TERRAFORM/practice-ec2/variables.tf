variable "aws_instance_type" {
    description = "the type of aws instance to create"
    default = "t3.micro"
    type = string
}
variable "aws_root_storage_size" {
    description = "the size of the root storage volume in gb"
    default = 8
    type = number
}
variable "ec2_ami" {
    description = "the exact machine image id we are going to use"
    default = "ami-09dbc7ce74870d573"
    type = string
}
variable "aws_root_storage_type" {
    description = "the type of root storage volume to create"
    default = "gp3"
    type = string
}