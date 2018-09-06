#!/bin/bash
export PATH="$PATH/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
export LANG=C

# define directory & files
WORKDIR=/usr/local/etc/nmap-tool
MTMPDIR=$WORKDIR/mtmp-dir
MACADDRLOGFILE=$MTMPDIR/macaddr-logfile
PROGRAMSTOPPEDREASON=$MTMPDIR/program_stopped_reason
CURLHTTPSTATUSCODE=$MTMPDIR/curl_http-status_code
DATETIME=$MTMPDIR/date-time
BACKUPDIR=$WORKDIR/backup

NMAP_DIR=nmap

# for MacPC
# NMAP_MAC_ADDR_DIR=/usr/local/share/nmap

# for Linux
NMAP_MAC_ADDR_DIR=/usr/share/nmap/

NMAP_MAC_PREFIXES=nmap-mac-prefixes
CURRENT_NMAC_MAC=$NMAP_MAC_ADDR_DIR/$NMAP_MAC_PREFIXES
#BACKUP_NMAC_MAC=$BACKUPDIR/nmap-mac-prefixes_`cat $DATETIME`

#if test -e  $DATETIME ; then
#   rm  $DATETIME
#   echo "remove $DATETIME file "
#fi

# Remove TMP file
if [ test -e  $MTPMDIR/* ; then
   cd $MTPMDIR
   rm *
   echo "tmp-file"
fi


echo `date "+%Y%m%d%H%M%S"` > $DATETIME

cd $WORKDIR


echo "------------------------"
echo "NEW-MAC-ADDRESS-LIST GET START : `date "+%Y%m%d%H%M%S"`" 										> $MACADDRLOGFILE

#curl -OL -f http://standards.ieee.org/regauth/oui/oui.txt
#curl http://standards-oui.ieee.org/oui/oui.txt -o /dev/null -w "%{http_code}\t\n" 2> /dev/null
#curl http://standards-oui.ieee.org/oui/oui.txt -o /dev/null -w "%{http_code}\t\n" 2> /dev/null > curl_start_time-and-status_code

echo "curl start time is" `date "+%Y%m%d%H%M%S"` >> $MACADDRLOGFILE
curl -OL -f http://standards-oui.ieee.org/oui/oui.txt  -w "%{http_code}\t\n" 2> /dev/null    > $CURLHTTPSTATUSCODE
#curl -OL -f http://standards.ieee.org/regauth/oui/oui.txt  -w "%{http_code}\t\n" 2> /dev/null > $CURLHTTPSTATUSCODE
echo "NEW-MAC-ADDRESS-LIST GET Finish : `date "+%Y%m%d%H%M%S"`" 									>> $MACADDRLOGFILE

if test 200  != `cat $CURLHTTPSTATUSCODE` ; then
	echo "				" ;
	echo "				" ;
	echo "This program has been stopped."                         > $PROGRAMSTOPPEDREASON
	echo "curl http status code is `cat $CURLHTTPSTATUSCODE`"  >> $PROGRAMSTOPPEDREASON
	echo "stopped time is" `date "+%Y%m%d%H%M%S"`                >> $PROGRAMSTOPPEDREASON
   else
	#curl -OL -f   http://standards-oui.ieee.org/oui/oui.txt
	cp oui.txt today_dir/oui.txt_`cat $DATETIME`

	echo "------------------------" 													>> $MACADDRLOGFILE
	echo "Backup the Current-MAC-ADDRESS-DATA: `date "+%Y%m%d%H%M%S"`" 									>> $MACADDRLOGFILE

	cat auth.txt |sudo -S cp $CURRENT_NMAC_MAC $BACKUPDIR/nmap_mac_prefixes_`cat $DATETIME`
	echo "Backup finish: `date "+%Y%m%d%H%M%S"`" >> $MACADDRLOGFILE
	echo "------------------------" >>$MACADDRLOGFILE

	echo "------------------------" >>$MACADDRLOGFILE
	echo "Convert format OUI and update NMAP-MAC-Prefixes. : `date "+%Y%m%d%H%M%S"`" 							>> $MACADDRLOGFILE
	cat auth.txt | sudo -S  perl make-mac-prefixes.pl oui.txt $CURRENT_NMAC_MAC
	echo "Convert finish : `date "+%Y%m%d%H%M%S"`" 												>> $MACADDRLOGFILE

	echo "------------------------" >>$MACADDRLOGFILE
	echo "Check the difference for  before and after: : `date "+%Y%m%d%H%M%S"`" 								>> $MACADDRLOGFILE
	diff $CURRENT_NMAC_MAC $BACKUPDIR/nmap_mac_prefixes_`cat $DATETIME` >$BACKUPDIR/`cat $DATETIME`_diff
	echo "Check finish : `date "+%Y%m%d%H%M%S"`" 												>> $MACADDRLOGFILE
	echo "------------------------" 													>> $MACADDRLOGFILE
 
	echo "finish the this process: : `date "+%Y%m%d%H%M%S"`" 										>> $MACADDRLOGFILE

fi
