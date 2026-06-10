resource aws_key_pair jenkins_key {
    key_name = "jenkins"
    public_key = file("jenkins.pub")
}

resource aws_vpc jenkins_vpc {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
}

resource aws_internet_gateway jenkins_igw {
    depends_on = [ aws_vpc.jenkins_vpc ]
    vpc_id = aws_vpc.jenkins_vpc.id
}

resource aws_subnet jenkins_subnet {
    depends_on = [ aws_vpc.jenkins_vpc ]
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.jenkins_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-north-1a"
}

resource aws_route_table jenkins_rt {
    depends_on = [ aws_internet_gateway.jenkins_igw ]
    vpc_id = aws_vpc.jenkins_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.jenkins_igw.id
    }
}

resource aws_route_table_association jenkins_rta {
    depends_on = [ aws_subnet.jenkins_subnet, aws_route_table.jenkins_rt ]
    subnet_id = aws_subnet.jenkins_subnet.id
    route_table_id = aws_route_table.jenkins_rt.id
}

resource aws_security_group jenkins_group {
    depends_on = [ aws_subnet.jenkins_subnet ]
    name = "jenkins"
    description = "this security group is specially configured for the machine that hosts the jenkins"
    vpc_id = aws_vpc.jenkins_vpc.id
    tags = {
        Name = "jenkins-sg"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows the ssh from anywhere if the person has the keys"
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allows the communication with jenkins"
    }
    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "this is a future port that is opened only for future purpose for testing the applications"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "this is the protocol that allows the stateful firewalls to work seamlessly without any interference"
    }
}

resource aws_instance jenkins_instance {
    depends_on = [ aws_security_group.jenkins_group, aws_key_pair.jenkins_key ]
    associate_public_ip_address = true
    key_name = aws_key_pair.jenkins_key.key_name
    vpc_security_group_ids = [aws_security_group.jenkins_group.id]
    subnet_id = aws_subnet.jenkins_subnet.id
    ami = var.ami_id
    instance_type = var.aws_instance_type
    user_data = file("user_data.sh")
    root_block_device {
        volume_size = var.aws_root_storage_size
        volume_type = var.aws_root_storage_type
    }
    tags = {
      Name="jenkins_instance"
    }
}