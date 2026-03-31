resource aws_key_pair my_key {
  key_name = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

resource aws_default_vpc default {
    
}

resource aws_security_group my_security_group {
    name = "new-sg"
    description = "this will add a teraform generated gecurity group"
    vpc_id = aws_default_vpc.default.id #this is interpolation : it is a way in which we can inherit or extract values from other resources"
    tags = {
        name = "my_security_group"
    }
    #inbound rules(ingress)
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows ssh access from anywhere"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows http access from anywhere"
    }
    ingress {
        from_port =443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows https access from anywhere"
    }

    #outbound rules(egress)
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" # -1 means all protocols and it can be used for both tcp and udp and this data is from documentation
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows all outbound traffic to anywhere"
    }
}

resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    instance_type = "t3.micro"
    ami = "ami-080254318c2d8932f"
    root_block_device {
      volume_size = 8
      volume_type = "gp3"
    }
    tags = {
        Name = "tf-instance"
    }
}