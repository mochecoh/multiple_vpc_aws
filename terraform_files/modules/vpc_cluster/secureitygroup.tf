resource "aws_security_group" "allow-ssh" {
    name        = "allow-ssh"
    vpc_id      = "${aws_vpc.vpc_aws.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = "-1"
        to_port = "-1"
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow-ssh"
    }
}

resource "aws_security_group" "allow-http" {
    name        = "allow-http"
    vpc_id      = "${aws_vpc.vpc_aws.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = "-1"
        to_port = "-1"
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow-http"
    }
}


resource "aws_security_group" "allow-portfor" {
    name        = "allow-portfor"
    vpc_id      = "${aws_vpc.vpc_aws.id}"

    ingress {
        from_port = 9999
        to_port = 9999
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 9998
        to_port = 9998
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = "-1"
        to_port = "-1"
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow-portfor"
    }
}