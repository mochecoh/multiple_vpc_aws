output "first_ip" {
  value = "${module.vpc_cluster_1.nat_ip}"
}
