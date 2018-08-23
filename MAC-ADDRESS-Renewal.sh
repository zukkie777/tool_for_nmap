#!/bin/bash

WORKDIR=/home/tasuzuki/work
BACKUPDIR=$WORKDIR/backup

#NMAP_DIR=/usr/share/nmap/
#NMAP_DIR=/usr/local/bin/nmap
NMAP_DIR=/usr/bin/nmap

#NMAP_MAC_ADDR_DIR=/usr/local/share/nmap
NMAP_MAC_ADDR_DIR=/usr/share/nmap/
NMAP_MAC_PREFIXES=nmap-mac-prefixes
CURRENT_NMAC_MAC=$NMAP_MAC_ADDR_DIR/$NMAP_MAC_PREFIXES
#BACKUP_NMAC_MAC=$BACKUPDIR/nmap-mac-prefixes_`cat DATE_TIME`

#PERL_PATH=/bin/perl
#CURL_PATH=/bin/curl
PERL_PATH=/usr/bin/perl
CURL_PATH=/usr/bin/curl

echo `date "+%Y%m%d%H%M%S"` > DATE_TIME

cd $WORKDIR


echo "------------------------"
echo "NEW-MAC-ADDRESS-LIST GET START!!"
echo "------------------------"

$CURL_PATH -OL  http://standards.ieee.org/regauth/oui/oui.txt
cp oui.txt today_dir/oui.txt_`cat DATE_TIME`

echo "------------------------"
echo "Backup the Current-MAC-ADDRESS-DATA."
echo "------------------------"

cat auth.txt |sudo -S cp $CURRENT_NMAC_MAC $BACKUPDIR/nmap_mac_prefixes_`cat DATE_TIME`

echo "------------------------"
echo "Convert format OUI and update NMAP-MAC-Prefixes. "
echo "------------------------"

cat auth.txt | sudo -S  $PERL_PATH make-mac-prefixes.pl oui.txt $CURRENT_NMAC_MAC

echo "------------------------"
echo "Check the difference for  before and after"
echo "------------------------"

diff $CURRENT_NMAC_MAC $BACKUPDIR/nmap_mac_prefixes_`cat DATE_TIME` >$BACKUPDIR/`cat DATE_TIME`_diff
 
