#!/bin/bash
sudo sysctl net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eth0 -s 10.0.0.0/16 -j MASQUERADE
sudo iptables -t nat -A PREROUTING -p tcp --dport 9999 -j DNAT --to-destination 10.0.0.5:22