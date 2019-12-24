
resource "aws_key_pair" "ec2key" {
  key_name = "${var.public_key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "instance_ec2" {
    ami = "${var.instance_ami}"
    instance_type = "${var.instance_type}"
    subnet_id ="${aws_subnet.subnet-private.id}"
    vpc_security_group_ids = [
                                "${aws_security_group.allow-ssh.id}",
                                "${aws_security_group.allow-http.id}"
                            ]
    key_name = "${aws_key_pair.ec2key.key_name}"
    tags = {
        Name = "${var.environment_tag}"
    }
    associate_public_ip_address = "false"
    private_ip = "${var.instance_ip}"

}

/* resource "aws_launch_configuration" "cluster_node" {

  name_prefix   = "cluster-node-"
  image_id                    = "${var.instance_ami}"
  instance_type               = "${var.instance_type}"

  //  Recommended for auto-scaling groups and launch configurations.
  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    "${aws_security_group.allow-ssh.id}",
    "${aws_security_group.allow-http.id}",
  ]
  associate_public_ip_address = "false"
  key_name = "${aws_key_pair.ec2key.key_name}"
}

resource "aws_autoscaling_group" "cluster_node" {
  name                        = "cluster_node"
  min_size                    = "2"
  max_size                    = "3"
  desired_capacity            = "2"
  vpc_zone_identifier         = ["${aws_subnet.public-subnet.*.id}"]
  launch_configuration        = "${aws_launch_configuration.cluster_node.name}"
  health_check_type           = "ELB"

  //  Recommended for auto-scaling groups and launch configurations.
  lifecycle {
    create_before_destroy = true
  }
}

# A load balancer for the cluster.
resource "aws_alb" "cluster-alb" {
    name                = "cluster-alb"
    security_groups     = [
      "${aws_security_group.public_ingress.id}",
      "${aws_security_group.intra_node_communication.id}"
    ]
    subnets             = ["${aws_subnet.public-subnet.*.id}"]
}

resource "aws_alb_target_group" "web" {
  name     = "web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.cluster.id}"
}

resource "aws_alb_listener" "web_listener" {  
  load_balancer_arn = "${aws_alb.cluster-alb.arn}"  
  port              = 80  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_alb_target_group.web.arn}"
    type             = "forward"  
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "web-attachment" { */
  autoscaling_group_name = "${aws_autoscaling_group.cluster_node.id}"
  alb_target_group_arn   = "${aws_alb_target_group.web.arn}"
}

resource "aws_instance" "instance_nat" {
    ami = "${var.instance_ami}"
    instance_type = "${var.instance_type}"
    subnet_id ="${aws_subnet.subnet-public.id}"
    source_dest_check = "false"
    vpc_security_group_ids = [
                                "${aws_security_group.allow-ssh.id}",
                                "${aws_security_group.allow-http.id}",
                                "${aws_security_group.allow-portfor.id}"
                            ]
    key_name = "${aws_key_pair.ec2key.key_name}"
    tags = {
        Name = "${var.environment_tag}"
    }
    associate_public_ip_address = "true"
    connection {
            type = "ssh"
            user = "ubuntu"
            private_key = "${file("~/.ssh/id_rsa")}"
            host = "${self.public_ip}"
    }
    provisioner "file" {
        source      = "portforwarding.sh"
        destination = "/home/ubuntu/portforwarding.sh"
    }
    provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/portforwarding.sh",
      "/home/ubuntu/portforwarding.sh",
    ]
  }

}

terraform {
 backend "s3" {
 encrypt = true
 bucket = "ww-develeap"
 region = "us-east-2"
 key = "ww/terraform.tfstate"
 }
}