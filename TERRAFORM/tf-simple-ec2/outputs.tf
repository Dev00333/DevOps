output "ec2_public_ip" {
    value = aws_instance.my_instance[*].public_ip
}
output "ec2_public_dns" {
    value = aws_instance.my_instance[*].public_dns # this [*] is used to extract the value of all the instances if we have more than one instance and it will return a list of public dns for all the instances
}
output "ec2_private_ip" {
    value = aws_instance.my_instance[*].private_ip
}