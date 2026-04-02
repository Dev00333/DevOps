output "ec2_public_ip" {
    value = aws_instance.my_instance.public_ip
    description = "the public ip address of the ec2 instance"  
}
output "ec2_public_dns" {
    value = aws_instance.my_instance.public_dns
    description = "the public dns of the ec2 instance"
}
output "ec2_private_ip" {
  value = aws_instance.my_instance.private_ip
  description = "the private ip address of the ec2 instance"
}