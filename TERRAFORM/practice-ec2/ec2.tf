resource aws_key_pair my_key {
    key_name = "practice-key"
    public_key = file("practice-key.pub")
}

resource aws_default_vpc default {
  
}

resource "aws_security_group" "my_security_group" {
    name = "new_sg"
    description = "this will add a terraform generated security group"
    vpc_id = aws_default_vpc.default.id
    tags = {
        name = "my_security_group"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows ssh access from anywhere"
    }
    ingress {
        from_port =80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows http access from anywhere"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows https access from anywhere"
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows icmp access from anywhere"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows all egress traffic"
    }
}

resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    instance_type = var.aws_instance_type
    ami = var.ec2_ami
    user_data = file("install_nginx_and_docker.sh")
    root_block_device {
        volume_size = var.aws_root_storage_size
        volume_type = var.aws_root_storage_type
    }
    tags = {
        Name = "practice-instance"
    }
}