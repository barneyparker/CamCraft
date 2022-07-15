#!/bin/bash

ipaddress=$(/bin/curl http://169.254.169.254/latest/meta-data/public-ipv4)
/bin/echo $ipaddress
# use sed to change IPADDRESS to $ipaddress in /tmp/dns.json
/bin/sed -i "s/IPADDRESS/$ipaddress/g" /tmp/dns.json
/bin/aws route53 change-resource-record-sets --hosted-zone-id Z042580720MXYMGJHPNQ6 --change-batch file:///tmp/dns.json
# ✨
aws s3 cp s3://minecrafttestbucket/world /opt/minecraft --recursive
systemctl start minecraft