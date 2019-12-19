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

<img src="https://doc-0g-30-docs.googleusercontent.com/docs/securesc/ge0nbdv1kn3foov8toc932l8b0o10vn0/r7akn2jihv8mdn9g7c1625v6f0jlkgbn/1576756800000/07023896017298246041/07023896017298246041/11awS7OkNT44wlCaN2MUyFPkmYLGSfog3?e=view&authuser=0&nonce=kpsblab5vqljm&user=07023896017298246041&hash=v5kn98t1h38edg1fmdchsr1a3fohdoro" />
