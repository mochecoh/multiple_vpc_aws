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

resource "aws_security_group" "intra_node_communication" {
  name        = "intra-node-communication"
  description = "Default security group that allows all instances in the VPC to talk to each other over any port and protocol."
  vpc_id      = "${aws_vpc.vpc_aws.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
}

//  This security group allows public ingress to the instances for HTTP, HTTPS
//  and common HTTP/S proxy ports.
resource "aws_security_group" "public_ingress" {
  name        = "public_ingress"
  description = "Security group that allows public ingress to instances on HTTP and HTTPS."
  vpc_id      = "${aws_vpc.vpc_aws.id}"

  //  HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTP Proxy
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS Proxy
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}