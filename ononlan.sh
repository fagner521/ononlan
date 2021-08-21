#!/bin/bash

ifconfig | grep "inet " | grep -v "127.0.0" | cut -d ' ' -f 10,13 # > /tmp/ipandnetmask.txt
while read y
do
netmask=$(echo $y | cut -d " " -f 2 )
ip=$(echo $y | cut -d '.' -f 1-3)
{
    netmask $(echo $y | cut -d " " -f 1)/$netmask
} || {
    echo "Necessario o comando netmask para calcular o range"
    echo "Instale usando #apt -y install netmask"
}
exit 1
if [ $netmask == "255.255.255.0" ];
then
    for x in `seq 1 254`; do
    ping -c 1 $ip'.'$x | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
    done
fi
if [ $netmask == "25525500" ];
then
    for x in `seq 1 254`; do
    ping -c 1 $ip'.'$x | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
    done
fi
if [ $netmask == "255000" ];
then
    for x in `seq 1 254`; do
    ping -c 1 $ip'.'$x | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
    done
fi
done < /tmp/ipandnetmask.txt
#rm /tmp/ipandnetmask.txt

echo "by SoenShem."