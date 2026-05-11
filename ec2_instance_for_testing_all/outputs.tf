output "ec2_public_ip" {
    value = aws_instance.ec2_all.public_ip
}

output "ec2_public_dns" {
    value = aws_instance.ec2_all.public_dns
}

output "ec2_private_ip" {
    value = aws_instance.ec2_all.private_ip
}

output "ec2_private_dns" {
    value = aws_instance.ec2_all.private_dns
}