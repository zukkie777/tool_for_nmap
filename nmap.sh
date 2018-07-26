#!/bin/bash

# Remove file
if test -e  error-file ; then
  rm  error-file
  echo "remove error-file"
fi
if test -e  NWADDR ; then
  rm  NWADDR
  echo "remove NWADDR"
fi

#WORKDIR=/home/tasuzuki/work
WORKDIR=/Users/zukkie/work

cd $WORKDIR

# ---------------------------
# for debug line
#NWADDR="192.168.0.53"
#NWADDR=""
#NWADDR= ｀ip r |grep "dev eno1 proto"|grep -v "default via"|cut -f 1 -d " "｀
# ---------------------------
#
# Search network Address
# echo "192.168.1.0/24" > NWADDR
#
#/sbin/ip r |grep "dev eno1 proto"|grep -v "default via"|cut -f 1 -d " " > NWADDR
/usr/local/bin/ip r |grep "dev eno1 proto"|grep -v "default via"|cut -f 1 -d " " > NWADDR

if test ! -s NWADDR ; then
#if test -z "$NWADDR" ; then
  echo "no ip error!  " > error-file

# Scan network
else
  echo "nmap start"
  #cat auth.txt | sudo -S nmap -sV -A $NWADDR -oX /tmp/result_scan_"%Y%m%d-%H%M%S".xml
  #cat auth.txt | sudo -S nmap -T4 -A  $NWADDR -oX /tmp/｀date "+%Y%m%d%H%M%S"｀.xml
  cat auth.txt | sudo -S /usr/local/bin/nmap -T4 -A -v --version-intensity 7  `cat NWADDR` -oX /tmp/`date "+%Y%m%d%H%M%S"`.xml

fi
