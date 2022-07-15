#!/bin/bash
players_online=$(netstat -pant | grep :25565 | grep ESTABLISHED | wc -l)
echo "Players: $players_online"

if [ $players_online -gt 0 ]
then
    echo "0" >/opt/minecraft/counter
else
    index=$(tail -1 /opt/minecraft/counter)           #get the counter
    tmp=`expr $index + 1`                #clone and increase the counter
    echo "shutdown countdown: $index"
    echo ${tmp} >/opt/minecraft/counter               #insert clone

    if [ $index -gt 14 ]
    then
        systemctl stop minecraft
        aws s3 sync /opt/minecraft/world s3://minecrafttestbucket/world
        aws autoscaling   set-desired-capacity --auto-scaling-group-name minecraftgroup --desired-capacity 0 --region eu-west-1
    fi
fi