provider "aws" {
  region = "us-east-2"
}

module "vpc_cluster_1" {
  source = "./modules/vpc_cluster"

  environment_tag = "first"
  public_key_name = "PublicKey_2"
}

module "vpc_cluster_2" {
  source = "./modules/vpc_cluster"

  environment_tag = "second"
  public_key_name = "PublicKey_1"
}