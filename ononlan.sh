#!/bin/bash

ifconfig | grep "inet " | cut -d ' ' -f 10 | cut -d '.' -f 1-3 > /tmp/ip.txt
while read y
do
ip=$y
for x in `seq 1 254`; do
ping -c 1 $ip'.'$x | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" | grep -v "127.0.0" &
done
done < /tmp/ip.txt
rm /tmp/ip.txt

echo "by SoenShem."