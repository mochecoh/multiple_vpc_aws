module "vpc_cluster_1" {
  source = "./modules/vpc_cluster"

  region_aws = "us-east-2"
  instance_ami = "ami-05c1fa8df71875112"
  environment_tag = "first"
  public_key_name = "PublicKey_2"
  subnets           = {
    us-east-2a = "10.0.3.0/24"
    us-east-2b = "10.0.4.0/24"
  }

}