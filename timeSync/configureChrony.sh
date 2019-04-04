#Simple script to install and configure chrony as recommended by the CIS CentOS Linux Benchmark

#!/bin/bash

###############################################################################################
#Create a file to record changes
outputFile=./outputFiles/info.`date +%d-%m-%y:%H:%M:%S`

#First check if chrony is installed on the systemc and, if not, install it using yum

while read package
do
	if  rpm -qa | grep $package &> /dev/null
	then
		echo "$package is already installed on this system" >> ./$outputFile
	else
		yum -y install $package &> /dev/null
		echo "$package has been installed on this system" >> ./$outputFile	
	fi
done < ./inputFiles/yumInstall

#Next backup the original chrony.conf and chronyd files 
#Then replace them with the corresponding files in ./newFiles

mv /etc/chrony.conf ./backupFiles/chrony.conf.`date +%d-%m-%y:%H:%M:%S`
cp ./newFiles/chrony.conf /etc

mv /etc/sysconfig/chronyd ./backupFiles/chronyd.`date +%d-%m-%y:%H:%M:%S`
cp ./newFiles/chronyd /etc/sysconfig


#Now enable and start chronyd

systemctl enable chronyd
systemctl start chronyd
