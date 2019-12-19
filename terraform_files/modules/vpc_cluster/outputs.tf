output "nat_ip" {
  value = "${aws_instance.instance_nat.public_ip}"
}
output "nat_id" {
  value = "${aws_instance.instance_nat.id}"
}
