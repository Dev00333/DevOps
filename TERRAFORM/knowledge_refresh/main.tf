resource "aws_key_pair" "my_key_pair" {
  key_name   = "knowledge"
  public_key = file("./knowledge.pub")
}

resource "aws_key_pair" "private_key_pair" {
  key_name   = "private_key"
  public_key = file("./private_key.pub")
}

resource "aws_security_group" "public_security_group" {
  name        = "knowledge_security_group"
  description = "a security group for knowledge refresh"
  vpc_id      = module.vpc.vpc_id
  tags = {
    name = "knowledge_security_group"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_security_group" {
  name        = "knowledge_private_security_group"
  description = "a security group for knowledge refresh private instances"
  vpc_id      = module.vpc.vpc_id
  tags = {
    name = "knowledge_private_security_group"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_knowledge_instance" {
  key_name = aws_key_pair.my_key_pair.key_name
  depends_on = [module.vpc]
  for_each = tomap({
    "public_subnet_1" = 0,
    "public_subnet_2" = 1,
    "public_subnet_3" = 2,
  })
  instance_type          = var.aws_instance_type
  subnet_id              = module.vpc.public_subnets[each.value]
  vpc_security_group_ids = [aws_security_group.public_security_group.id]
  ami                    = var.aws_ami
  user_data              = file("./user_data.sh")
  associate_public_ip_address = true
  root_block_device {
    volume_size           = var.aws_root_storage_size
    volume_type           = var.aws_root_storage_type
    delete_on_termination = true
  }
  tags = {
    Name = "public_knowledge_instance_${each.key}"
  }
}

resource "aws_instance" "private_knowledge_instance" {
  key_name = aws_key_pair.private_key_pair.key_name
  depends_on = [module.vpc]
  for_each = tomap({
    "private_subnet_1" = 0,
    "private_subnet_2" = 1,
    "private_subnet_3" = 2,
  })
  instance_type          = var.aws_instance_type
  subnet_id              = module.vpc.private_subnets[each.value]
  vpc_security_group_ids = [aws_security_group.private_security_group.id]
  ami                    = var.aws_ami
  user_data              = file("./user_data.sh")
  root_block_device {
    volume_size           = var.aws_root_storage_size
    volume_type           = var.aws_root_storage_type
    delete_on_termination = true
  }
  tags = {
    Name = "private_knowledge_instance_${each.key}"
  }
}