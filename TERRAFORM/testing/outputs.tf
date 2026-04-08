output "ec2_public_ip" {
  value = aws_instance.my_instance.public_ip
  description = "this is the public ip of the terraform generated instance"
}
output "ec2_public_dns" {
  value = aws_instance.my_instance.public_dns
  description = "this is the public dns of the terraform generated instance"
}
output "ec2_private_ip" {
  value = aws_instance.my_instance.private_ip
  description = "this is the private ip of my terraform generated instance"
}