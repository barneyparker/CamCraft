# For Trello
aws route53 list-hosted-zones-by-name --dns-name camparker.me.uk --query "HostedZones[].Id" --output text
aws route53 change-resource-record-sets --hosted-zone-id Z042580720MXYMGJHPNQ6 --change-batch file://sample.json
curl http://169.254.169.254/latest/meta-data/public-ipv4
aws s3 sync . s3://minecrafttestbucket/world
aws autoscaling   set-desired-capacity --auto-scaling-group-name minecraftgroup --desired-capacity 0