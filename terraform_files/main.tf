module "vpc_cluster_1" {
  source = "./modules/vpc_cluster"

  region_aws = "us-east-2"
  instance_ami = "ami-05c1fa8df71875112"
  environment_tag = "first"
  public_key_name = "PublicKey_2"
}

module "vpc_cluster_2" {
  source = "./modules/vpc_cluster"

  region_aws = "us-west-1"
  instance_ami = "ami-0dd655843c87b6930"
  environment_tag = "second"
  public_key_name = "PublicKey_1"
}

resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
    triggers = {
        my_instance_id = "${module.vpc_cluster_2.nat_id}"
        other_instance_ip = "${module.vpc_cluster_1.nat_ip}"
    }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
    connection {
            type = "ssh"
            user = "ubuntu"
            private_key = "${file("~/.ssh/id_rsa")}"
            host =  "${module.vpc_cluster_2.nat_ip}"
    }
    provisioner "remote-exec" {
    inline = [
      "sudo iptables -t nat -A PREROUTING -p tcp --dport 9998 -j DNAT --to-destination ${module.vpc_cluster_1.nat_ip}:9999",
      "sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE",
    ]
  }
}