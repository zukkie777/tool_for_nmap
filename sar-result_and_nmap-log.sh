#!/bin/bash
WORKDIR=/usr/local/etc/nmap-tool
TMPDIR=$WORKDIR/tmp-dir
NMAPLOGFILE=$TMPDIR/nmap-logfile
NMAPSTARTTIME=$TMPDIR/nmap-start-time
NMAPFINISHTIME=$TMPDIR/nmap-finish-time
SARDIR=$WORKDIR/sar-dir
CPUDATA=$SARDIR/cpu-data
MEMORYDATA=$SARDIR/memory-data
DEVICEDATA=$SARDIR/device-data
LOADAVELAGEDATA=$SARDIR/load-avelage-data
SWAPDATA=$SARDIR/swap-data
CONTEXTDATA=$SARDIR/context-data


grep nmap-start  $NMAPLOGFILE |awk -F"/" '{print $4}'> $NMAPSTARTTIME
grep nmap-finish $NMAPLOGFILE |awk -F"/" '{print $4}'> $NMAPFINISHTIME
###### cpu
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-start/'  $CPUDATA ; done < $NMAPSTARTTIME 
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-finish/' $CPUDATA ; done < $NMAPFINISHTIME

###### memory
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-start/'  $MEMORYDATA ; done < $NMAPSTARTTIME 
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-finish/' $MEMORYDATA ; done < $NMAPFINISHTIME

###### device
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-start/'  $DEVICEDATA ; done < $NMAPSTARTTIME 
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-finish/' $DEVICEDATA ; done < $NMAPFINISHTIME

###### load-avelage
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-start/'  $LOADAVELAGEDATA ; done < $NMAPSTARTTIME 
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-finish/' $LOADAVELAGEDATA ; done < $NMAPFINISHTIME

###### swap-avelage
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-start/'  $SWAPDATA ; done < $NMAPSTARTTIME 
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-finish/' $SWAPDATA ; done < $NMAPFINISHTIME

###### context-avelage
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-start/'  $CONTEXTDATA ; done < $NMAPSTARTTIME 
while read line ; do  sed -i  -e 's/'$line'.../'$line'-nmap-finish/' $CONTEXTDATA ; done < $NMAPFINISHTIME
