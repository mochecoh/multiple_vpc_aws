# Multiple VPC with Port forwarding

This is a simple terraform module to build an infra of two VPC with the same CIDR, each one have same subnets CIDR and same instance private IP.

# Connection

The ip are private ip, the only way to ssh to the instance is to use the nat port forwarding.

    $ ssh ubuntu@<OUTPUT_IP> -p 9999 #for the first instance
    $ ssh ubuntu@<OUTPUT_IP> -p 9998 #for the second instance
    
 
##  Steps

 1. Terraform main.tf will build 2 times the same module which is the whole infra (VPC, subnet etc...).
 2. Each Nat instance will run the portforwarding.sh file which add iptables rules to portforwarding.
 3. For the second nat, main.tf run a script to redirect 9998 port to the 9999 port of the first nat.

![enter image description here](https://i.ibb.co/B4Qzd13/Screenshot-from-2019-12-19-15-00-35.png)
