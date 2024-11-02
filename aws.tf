resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "myVPC"
    }
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "myIGW"
    }
}

resource "aws_subnet" "my_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true

    tags = {
        Name = "myPublicSubnet"
    }
}

resource "aws_route_table" "my_rt" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
}

resource "aws_route_table_association" "myrt_ass" {
    subnet_id = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.my_rt.id
}

resource "aws_security_group" "my_sg" {
     vpc_id = aws_vpc.my_vpc.id

     ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        
     }

     tags = {
         Name = "mySG"
     }
}

resource "aws_instance" "my-test" {
    ami = "ami-06b21ccaeff8cd686"
    instance_type= "t2.micro"

    subnet_id = aws_subnet.my_subnet.id
    vpc_security_group_ids = [aws_security_group.my_sg.id]
}