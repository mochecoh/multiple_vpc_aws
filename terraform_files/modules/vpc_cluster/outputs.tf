output "nat_ip" {
  value = "${aws_instance.instance_nat.public_ip}"
}
