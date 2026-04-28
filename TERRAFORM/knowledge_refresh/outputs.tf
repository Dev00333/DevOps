# output "instance_public_ip" {
#   value = aws_instance.knowledge_instance.public_ip
# }
# output "instance_private_ip" {
#   value = aws_instance.knowledge_instance.private_ip
# }
# output "instance_public_dns" {
#   value = aws_instance.knowledge_instance.public_dns
# }
output "public_instance_public_ip" {
  value = [
    for instance in aws_instance.public_knowledge_instance : instance.public_ip
  ]
}
output "public_instance_private_ip" {
  value = [
    for instance in aws_instance.public_knowledge_instance : instance.private_ip
  ]
}
output "public_instance_public_dns" {
  value = [
    for instance in aws_instance.public_knowledge_instance : instance.public_dns
  ]
}
output "private_instance_public_ip" {
  value = [
    for instance in aws_instance.private_knowledge_instance : instance.public_ip
  ]
}
output "private_instance_private_ip" {
  value = [
    for instance in aws_instance.private_knowledge_instance : instance.private_ip
  ]
}
output "private_instance_public_dns" {
  value = [
    for instance in aws_instance.private_knowledge_instance : instance.public_dns
  ]
}