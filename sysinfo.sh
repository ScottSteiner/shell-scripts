#!/bin/bash
# Copyright (c) 2009-2012 ScottSteiner <nothingfinerthanscottsteiner@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# https://github.com/ScottSteiner/shell-scripts

cpuModel=`awk -F ': ' '/model name/ { print $2; exit }' /proc/cpuinfo | sed -e 's/(tm)//g;s/Dual Core Processor //g'`
cpuSpeed=`awk '/cpu MHz/ { print $4; exit }' /proc/cpuinfo | sed 's/\.[0-9]*//' `
#cpuusage=`mpstat 1 1| awk '/all/ { print 100-$12; exit }'`
#Show every partition.  Really spammy:
#disks=`df -h | awk '/^\/dev/ { print $6 ": " $3 "/" $2 " (" $5 ")"; exit}' | awk '{ str1=str1 $0 " "}END{ print str1 }'`
#Show only the totals:
disks=`df -lhx devtmpfs -x tmpfs -x rootfs --total|awk '/^total/ { print $3"/"$2" ("$5")"; exit }'`

if [ -e /etc/issue ] && [[ `grep -i Arch /etc/issue` == *Arch* ]];then os='Arch GNU/Linux'
elif [ -e /etc/issue.net ]; then os=`cat /etc/issue.net`
elif [ -e /etc/gentoo-release ]; then os=`sed 's/Gentoo/Gentoo GNU\/Linux/' /etc/gentoo-release`
elif [ -e /etc/slackware-version ]; then os=`cat /etc/slackware-version`
elif [ `uname -o` == 'GNU/Linux' ]; then os='Unknown GNU/Linux'
else os='N/A'
fi
hostname=`uname -n`
kernelName=`uname -s`
kernelVersion=`uname -r`
#memoryCurrent=`free -mo | awk '/Mem:/ { print $3; exit }'` #Includes cached memory (in megabytes)
memoryCurrent=`free -m | awk '/cache:/ { print $3; exit }'` #Doesn't include cached memory (in megabytes)
memoryMax=`free -mo | awk '/Mem:/ { print $2; exit }'`
memoryPercent=`echo 'scale=2;100*'$memoryCurrent'/'$memoryMax | bc`
#nettransfer=`ifconfig eth0 | awk '/RX bytes/ { print "Rec: "$3$4" Sent: " $7$8; exit }' | sed -e 's/(//g;s/)//g'`
procCount=$((`ps -e --noheading|wc -l`-1))
swapCurrent=`free -mo | awk '/Swap:/ { print $3; exit }'`
swapMax=`free -mo | awk '/Swap:/ { print $2; exit }'`
if [ $swapMax -gt 0 ]; then swapPercent=`echo 'scale=2;100*'$swapCurrent'/'$swapMax | bc`
else swapPercent='100'
fi
uptime=`uptime|awk -F 'up ' '{ print $2; exit }'|sed 's/,..[0-9] user.*$//'`
video=`lspci -v | grep -i 'VGA compatible controller' | sed -e 's/^.*controller: //g;s/ (prog.*$//g;s/ Technologies Inc//g;s/Advanced Micro Devices \[AMD\] nee //g'`
echo "Hostname: $hostname OS: $os Kernel: $kernelName $kernelVersion Up: $uptime CPU: $cpuModel ${cpuSpeed}MHz Video: $video Processes: $procCount RAM: ${memoryCurrent}mb/${memoryMax}mb (${memoryPercent}%) Swap: ${swapCurrent}mb/${swapMax}mb (${swapPercent}%) Disks: $disks $nettransfer"|sed  's/  / /g'
