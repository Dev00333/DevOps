output ec2_public_ip {
    value = aws_instance.jenkins_instance.public_ip
}
output ec2_private_ip {
    value = aws_instance.jenkins_instance.private_ip
}
output ec2_public_dns {
    value = aws_instance.jenkins_instance.public_dns
}
output private_dns {
    value = aws_instance.jenkins_instance.private_dns
}