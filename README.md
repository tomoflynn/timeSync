#Simple script to automate the installation and configuration of chrony on CentOS 7 by Tom O'Flynn:

This scripts automates the installation and configuration of chrony as a client on CentOS 7. This is a recommendation of the CIS CentOS Linux 7 Benchmark Guide (see https://www.cisecurity.org/benchmark/centos_linux/). 

While this script should work on most of the latest RedHat variants (and possibly other Linux releases with basic modifications) it has only been tested on a minimum install of CentOS 7 (CentOS release 7.6.1810 (Core)).

The author makes no claims to originality as all settings are based on information in the public domain. Similar scripts are no doubt available elsewhere so anyone interested in this work is encouraged to investigate other options. The author created this script because he felt more comfortable working with code of his own creation. In the event of there being a programming error it can be easier to troubleshoot code you have written yourself than somebody else's work.

In order to run this script download all files and folders to a suitable location and run configureChrony.sh as root. In its present form the script will run without any user input. However, this will change when further options are added in the future (see below).

There are a number of folders containing files used by configureChrony.sh. They are detailed below:

1. backupFiles - Before any system files are modified they are backed up to this folder. Files are labelled originalName.<date/time> where <date/time> takes the form of dd-mm-yy:hour:minute:second and represents the time at which configureChrony.sh was run. At present only two files are backed up. These are /etc/chrony.conf and /etc/sysconfig/chronyd.
2. inputFiles- this folder contains files which are read by configureChrony.sh when running commands. At present only one file is present. This file named yumInstall contains a single entry - the word "chrony" which is the name of the software used for time synchronisation.
3. newFiles - this folder contains two files name chrony.conf and chronyd used to replace the original versions on a Linux system. chronyd does not require any modifiction prior to running the script. However, in the case of chrony.conf the lines "server <enter ip address or FQDN of server here>" must be modified. The entire expression after "server " (including brackets) should be replaced with either the ip address or FQDN of the ntp server(s) with which the system is due to be synchronised. Any unused lines should either be commented out or deleted.
4. outputFiles - as the code runs information about modifications made are saved to a file in this folder. The filename is info.<date/time> where <date/time> takes the same format as given in point 1 above. 

The above folder and filename structure is also used by code in the cis.sh script found at https://github.com/tomoflynn/cisBenchmark. This is because once further work (and related testing) is complete configureChrony.sh will be merged with cis.sh. Users who wish to merge both scripts themselves should add the contents of timeSync/inputFiles/yumInstall to the equivalent file in cisBenchmark/inputFiles/. Next the following lines from configureChrony.sh should be added to cis.sh:

#Next backup the original chrony.conf and chronyd files 
#Then replace them with the corresponding files in ./newFiles

mv /etc/chrony.conf ./backupFiles/chrony.conf.`date +%d-%m-%y:%H:%M:%S`
cp ./newFiles/chrony.conf /etc

mv /etc/sysconfig/chronyd ./backupFiles/chronyd.`date +%d-%m-%y:%H:%M:%S`
cp ./newFiles/chronyd /etc/sysconfig


#Now enable and start chronyd

systemctl enable chronyd

systemctl start chronyd

Future Work:
At present this script checks to see if chrony is installed and, if not, installs it using yum. It then configures the system as a client for the ntp server(s) specified in timeSync/newFiles/chrony.conf. In the future the script will ask the user whether or not the system should act as an ntp server and, if a positive answer is received, appropriate changes will be made to facilitate this. These changes will include the option to use a non-standard port, generate symmetric keys for authentication and any firewall and selinux modifications required. It is envisaged that work on the next phase of this script will begin before June 2019

