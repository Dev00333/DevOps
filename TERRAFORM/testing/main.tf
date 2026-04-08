resource "aws_key_pair" "my_key" {
    key_name = "testing"
    public_key = file("testing.pub")
}
resource "aws_default_vpc" "default" {  
}
resource "aws_security_group" "my_security_group" {
  name = "testing-sg"
  description = "this will add a terraform generated security group"
  vpc_id = aws_default_vpc.default.id
  tags = {
    name = "my_security_group"
  }
  ingress {
    from_port = 22
    to_port =22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}
resource "aws_instance" "my_instance" {
  key_name = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [ aws_security_group.my_security_group.id ]
  instance_type = var.aws_instance_type
  ami = var.aws_ami
  user_data = file("user_data.sh")
  root_block_device {
    volume_size = var.aws_root_storage_size
    volume_type = var.aws_root_storage_type
    delete_on_termination = true
  }
  tags = {
    Name = "testing-instance"
  }
}