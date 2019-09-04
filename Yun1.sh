#!/bin/bash

apt-get update
sleep 5
apt-get install lrzsz make cmake g++ cron nginx expect qv4l2 minicom apache2-utils -y
sleep 5

expect << EOF
spawn fdisk /dev/nvme0n1

expect "*Command (m for help):*"
      send "n\r";
expect "*Select (default p):*"
      send "p\r";
expect "*Partition number (1-4, default 1):*"
      send "\r";
expect "*First sector*"
      send "\r";
expect "*Last sector, +sectors or*"
      send "\r";
expect "*Command (m for help):*"
      send "p\r";
expect "*Command (m for help):*"
      send "w\r";

spawn mkfs.ext4 /dev/nvme0n1p1

expect "*Proceed anyway? (y,N)*"
      send "y\r";

expect eof
EOF
#echo "mount>>>>>>>>>>>>>>>>>>111>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
mkdir /data
echo "/dev/nvme0n1p1  /data   ext4    defaults        0       0" >> /etc/fstab

mount -a

df -lh

#str=`date | cut -d ' ' -f5`
#if [ $str == UTC ]; then
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#fi
#echo "net-install>>>>>>>>>>>>>>111>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

echo "auto lo" >> /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo "auto eth0" >> /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "address 192.168.1.230" >> /etc/network/interfaces
echo "netmask 255.255.255.0" >> /etc/network/interfaces
echo "#gateway 10.0.0.1" >> /etc/network/interfaces

#echo "passwd>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

expect << EOF
spawn passwd
expect "*Enter new UNIX password:*"
	send "Ilovetyjw!\r";
expect "*Retype new UNIX password:*"
	send "Ilovetyjw!\r";
expect eof
EOF
#echo "ssh->>>>>>>>>>>>>>>>>>>111>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

if grep -w "Port" /etc/ssh/sshd_config
then
	sed -i 's/^#Port 22/Port 22/' /etc/ssh/sshd_config
else
	echo "Port 22" >> /etc/ssh/sshd_config
fi

if grep -w "ListenAddress 0.0.0.0" /etc/ssh/sshd_config
then
	sed -i 's/^#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
else
	echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config
fi

if grep -w "ListenAddress ::" /etc/ssh/sshd_config
then
	sed -i 's/^#ListenAddress ::/ListenAddress ::/' /etc/ssh/sshd_config
else
	echo "ListenAddress ::" >> /etc/ssh/sshd_config
fi

if grep -w "PermitRootLogin prohibit-password" /etc/ssh/sshd_config
then
	sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
else
	echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
fi

if grep -w "PasswordAuthentication yes" /etc/ssh/sshd_config
then
	sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
else
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
fi

if grep -w "ChallengeResponseAuthentication no" /etc/ssh/sshd_config
then
	sed -i 's/^#ChallengeResponseAuthentication no/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
else
	echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
fi

if grep -w "UsePAM yes" /etc/ssh/sshd_config
then
	sed -i 's/^#UsePAM yes/UsePAM yes/' /etc/ssh/sshd_config
else
	echo "UsePAM yes" >> /etc/ssh/sshd_config
fi

if grep -w "UseLogin no" /etc/ssh/sshd_config
then
	sed -i 's/^#UseLogin no/UseLogin yes/' /etc/ssh/sshd_config
else
	echo "UseLogin yes" >> /etc/ssh/sshd_config
fi
reboot
exit 0 
