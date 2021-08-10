#!/bin/bash
arch=$(uname -a)
cpu=$(grep 'physical ID' /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep '^processor' /proc/cpuinfo | uniq | wc -l)
memoryused=$(free -m | grep Mem | awk '{print $3}')
memorytot=$(free -m | grep Mem | awk '{print $2}')
memorypercent=$(free -m | grep Mem | awk '{print $3/$2 * 100.0}')
diskused1=$(lsblk | grep 'sda5_crypt' | awk '{print($4)}')
diskused=$(df -BG | grep '^/dev/'| grep -v '/boot$' | awk '{fd += $2} END {print fd}')
diskspace=$(df -BG | grep '^/dev/'| grep -v '/boot$' | awk '{ud += $3} END {print ud}')
diskpercent=$(df -Bm | grep '^/dev/'| grep -v '/boot$' | awk '{ud += $3} {fd += $2} END {printf("%d"), ud/fd*100}')
cpuload=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvmtest=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [ $lvmtest -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(grep 'TCP:' /proc/net/sockstat{,6} | awk '{print($3)}')
usrlog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip a | grep 'link/ether' | awk '{print($2)}')
su=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "#Architecture: $arch
#CPU physical: $cpu
#vCPU : $vcpu
#Memory usage : $memoryused/${memorytot}MB ($memorypercent%)
#Disk usage : $diskspace/${diskused1}B ($diskpercent%)
#Cpu Load : $cpuload 
#Last Boot : $lboot
#LVM use : $lvm
#Connexions TCP : ${ctcp} ESTABLISHED
#User log : $usrlog
#Network : IP $ip ($mac)
#Sudo : $su cmd"
