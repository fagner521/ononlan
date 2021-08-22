#!/bin/bash

ifconfig | grep "inet " | grep -v "127.0.0" | cut -d ' ' -f 10,13  # > /tmp/ipandnetmask.txt
while read y
do
netmask=$(echo $y | cut -d " " -f 2 )
ip=$(echo $y | cut -d ' ' -f 1)
{
    iprange=$(netmask $ip/$netmask)
} || {
    echo "Necessario o comando netmask para calcular o range"
    echo "Instale usando #apt -y install netmask"
}
{
    nhosts=$(ipcalc $iprange | grep 'Wildcard' | cut -d ' ' -f 3)
    second8bits=$(echo $nhosts | cut -d '.' -f 2)
    third8bits=$(echo $nhosts | cut -d '.' -f 3)
    quarter8bits=$(echo $nhosts | cut -d '.' -f 4)
    ipstart=$(echo $iprange | cut -d '/' -f 1)
    maxip=$(ipcalc $iprange | grep "HostMax" | cut -d ' ' -f 4)
} || {
    echo "Necessario o comando ipcalc para calcular o range"
    echo "Instale usando #apt -y install ipcalc"
}
if [ $second8bits -eq 0 ];
then
    echo $second8bits
    if [ $third8bits -eq 0 ];
    then
        if [ $quarter8bits -eq 0 ];
        then
            echo "Range vazia."
        else
        for quarter in `seq $(echo $ipstart | cut -d '.' -f 4) $(echo $maxip | cut -d '.' -f 4)`;do
            echo $(echo $ip | cut -d "." -f 1-3)".$quarter"
            #ping -c 1 $(echo $ip | cut -d '.' -f 1-)'.'$second | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
        done
        fi
    else
        for third in `seq $(echo $ipstart | cut -d '.' -f 3) $(echo $maxip | cut -d '.' -f 3)`;do
            for quarter in `seq $(echo $ipstart | cut -d '.' -f 4) $(echo $maxip | cut -d '.' -f 4)`;do
                echo $(echo $ip | cut -d "." -f 1-2)".$third.$quarter"
                #ping -c 1 $(echo $ip | cut -d '.' -f 1-)'.'$second | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
            done
        done
    fi
else
    for second in `seq $(echo $ipstart | cut -d '.' -f 2) $(echo $maxip | cut -d '.' -f 2)`;do
       for third in `seq $(echo $ipstart | cut -d '.' -f 3) $(echo $maxip | cut -d '.' -f 3)`;do
            for quarter in `seq $(echo $ipstart | cut -d '.' -f 4) $(echo $maxip | cut -d '.' -f 4)`;do
                echo $(echo $ip | cut -d "." -f 1)".$second.$third.$quarter"
                #ping -c 1 $(echo $ip | cut -d '.' -f 1-)'.'$second | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
            done
        done
    done
fi
done < /tmp/ipandnetmask.txt
#rm /tmp/ipandnetmask.txt

echo "by SoenShem."