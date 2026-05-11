resource aws_key_pair all {
    key_name = "all"
    public_key = file("all.pub")
}

resource "aws_default_vpc" "default" {
    
}

resource "aws_security_group" "all_sg" {
    name = "all_sg"
    description = "this security group is for a machine that is used to practice all the devops tools"
    vpc_id = aws_default_vpc.default.id
    tags = {
        Name = "all_sg"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
        description = "allows ssh access from the remote if key matches"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "this pport allows the http traffic to move and it is unsecured to test the tools"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "this pport allows the https traffic to move and it is unsecured to test the tools"
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "this protocol allows the instance to be tested from anywhere to check if its working or not" 
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "this protocol allows all the traffic to move from the instance to the internet"
    }
}

resource "aws_instance" "ec2_all" {
    depends_on = [aws_security_group.all_sg]
    key_name = aws_key_pair.all.key_name
    vpc_security_group_ids = [aws_security_group.all_sg.name]
    ami = var.ami_id
    instance_type =var.aws_instance_type
    user_data = file("user_data.sh")
    root_block_device {
        volume_type=var.aws_root_storage_type
        volume_size=var.aws_root_storage_size
    }
    tags={
        Name="ec2_all_for_practice"
    }
}