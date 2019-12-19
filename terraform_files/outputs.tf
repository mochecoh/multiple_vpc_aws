output "first_ip" {
  value = "${module.vpc_cluster_1.nat_ip}"
}
output "second_ip" {
  value = "${module.vpc_cluster_2.nat_ip}"
}
