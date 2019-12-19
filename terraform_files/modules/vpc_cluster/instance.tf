
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