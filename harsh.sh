#!/bin/bash
#Author : Harsh Patel
#Qualification : Master of Engineering in Internetworking at Dalhousie University, NS, Canada
#Date of creation : Jan 16 2021
#Date of modification : 9 june 2020
#Installing Samba on Ubuntu 20.*

hostnamectl set-hostname sambaserver

PACKAGES="firewalld samba"

for i in $PACKAGES;
do
	sudo dpkg --status $i | grep "install ok installed" &> /dev/null
	if [ $? -eq 0 ];
	then
		echo "$i already installed"
	else
		apt install -y $i
	fi
done

echo "Enter name of sharable directory"
read dir

mkdir /$dir

echo "Enter Group name"
read group_name

groupadd -r $group_name

chgrp $group_name /$dir
chmod 2775 /$dir 

echo "Enter Share Name"
read share_name

echo "[$share_name]
	comment = Samba server on Ubuntu
	path = /$dir
	read only = no
	browsable = yes" >> /etc/samba/smb.conf

echo "Enter Username"
read username

smbpasswd -a $username

echo "Start and Enable Service"
systemctl start smbd.service nmbd.service
systemctl enable smbd.service nmbd.service

echo "Adding Samba into Firewall"
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
