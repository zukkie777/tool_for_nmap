#!/bin/bash
#
export PATH="$PATH/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
export LANG=C

# define directory & files
WORKDIR=/usr/local/etc/nmap-tool
TMPDIR=$WORKDIR/tmp-dir
NMAPLOGFILE=$TMPDIR/nmap-logfile
NWADDR=$TMPDIR/nwaddr
IPADDRTMP=$TMPDIR/ipaddr-tmp

### resorce information ###
### cpu,memory etc,etc
./sar.sh &

sleep 360

# Remove TMP file
if [ test -e  $TMPDIR/* ; then
   cd $TMPDIR
   rm *
   echo "tmp-file"
fi


cd $WORKDIR

# ---------------------------
# for debug line
#$NWADDR="192.168.0.53"
#$NWADDR=""
#$NWADDR= `ip r |grep "dev eno1 proto"|grep -v "default via"|cut -f 1 -d " "`
# ---------------------------
#
# Search network Address
   echo "-----------------------------------"                                                                          >  $NMAPLOGFILE
   echo "search network address : `date "+%Y/%m/%d/%H:%M:%S"`"                                                         >> $NMAPLOGFILE
#echo "192.168.0.53" > $NWADDR
#
# for single Interface(Please modify divice name)
#/usr/sbin/ip r |grep "dev eno1 proto"|grep -v "default via"|cut -f 1 -d " " 				 > $NWADDR
#
# for MacOS
#ipcalc -n `ip addr   | grep "inet " |awk '{print $2}'|grep -v ^127.0.0.1`|grep Network |awk '{print $2}' > $NWADDR

# for Multi Interface
#ip addr   | grep "inet " |awk '{print $2}'|grep -v ^127.0.0.1 > 							$IPADDRTMP
ip addr   | grep "inet " |awk '{print $2}'|grep -v ^127.0.0.1 > 							$IPADDRTMP
   echo "search network finish : `date "+%Y/%m/%d/%H:%M:%S"`"                                                              >> $NMAPLOGFILE
   echo "-----------------------------------"                                                                              >> $NMAPLOGFILE
   echo "NW-address calclation : `date "+%Y/%m/%d/%H:%M:%S"`"                                                              >> $NMAPLOGFILE
while read line;
 do  ipcalc -np   $line;
 done < $IPADDRTMP|sed -e "N;s/\n/,/g"|awk -F',' '{print $2,$1}'|sed -s "s/NETWORK=//"|sed -s "s/ PREFIX=/\//"> 	$NWADDR
   echo "NW-address calclation finish : `date "+%Y/%m/%d/%H:%M:%S"`"                                                       >> $NMAPLOGFILE
   echo "-----------------------------------"                                                                              >> $NMAPLOGFILE




if test !-s $NWADDR ; then
   echo "no ip error!  " > $TMPDIR/error-file

# Scan network
else
   echo "-----------------------------------"                                                                            >> $NMAPLOGFILE
   #echo "nmap-start : `date "+%Y/%m/%d/%H:%M:%S"`"                                                                      >> $NMAPLOGFILE
   echo "nmap-start : `date "+%Y/%m/%d/%H:%M"`"                                                                          >> $NMAPLOGFILE

   #cat auth.txt | sudo -S nmap -sV -A $NWADDR -oX /tmp/result_scan_"%Y%m%d-%H%M%S".xml
   #cat auth.txt | sudo -S nmap -T4 -A  $NWADDR -oX /tmp/`date "+%Y%m%d%H%M%S"`.xml
   #cat auth.txt | sudo -S /usr/bin/nmap -T4 -A -v  `cat $NWADDR` -oX /tmp/`date "+%Y%m%d%H%M%S"`.xml
   #cat auth.txt | sudo -S nmap -T4 -A -v  `cat $NWADDR` -oX /tmp/`date "+%Y%m%d%H%M%S"`.xml

# Multi Interface discovery
   cat auth.txt | sudo -S nmap -T4 -A -v -iL $NWADDR -oX /tmp/`date "+%Y%m%d%H%M%S"`.xml;

   #echo "nmap-finish : `date "+%Y/%m/%d/%H:%M:%S"`"                                                                      >> $NMAPLOGFILE
   echo "nmap-finish : `date "+%Y/%m/%d/%H:%M"`"                                                                          >> $NMAPLOGFILE

###

sleep 480

###
### Mapping result-of-sar_and_nmap-log
###
  ./sar-result_and_nmap-log.sh

fi
