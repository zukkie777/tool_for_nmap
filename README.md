## Name
# **NMAP-SUPPORT-TOOL**  

## Overview
　これはNMAP利用時の支援ツールであり、主なスクリプトとその概要は以下2つである。
  ディスカバリを定期処理させる場合とnmapがもつMACアドレスを定期更新させるために作成した。

**1.nmap.sh**  
* LAN内のNWアドレス自体の探索   
* NMAP実行サーバ自身の全IPアドレスから、NWアドレスの計算(ipcalc)   
* 1の結果に対しディスカバリ(nmap)を実行し、XMLファイルへ出力    

**2.MAC-ADDRESS-Renewal.sh** 　  
* IEEEのウェブサイトからMACアドレス一覧(oui.txt)の取得(curl)   
* 1の結果に対し、NMAPフォーマットへ変換後(make-mac-prefixes.pl)に更新   
*make-mac-prefixes.plはnmapインストール時にnmapディレクトリ設置されるが、
　当該はoui.txtをnmap用のフォーマットに変換するのみで、IEEEのWebサイトへ取りに行く動作はないため、
　取りに行って更新させる内容とした。
  

## Description
**1.nmap.sh**  
1. nmap.sh実行開始時にsar.shがcallされ、リソース情報の収集を開始する。   
2. 実行サーバ自体の全IPアドレスから、全NWアドレスを計算する。   
3. 複数インタフェイスを持つ場合は、全て計算する。   
4. 2の実行結果をもとに全てのNWアドレスに対し、ディスカバリ(nmap)を実行し、   
5. 結果をXMLフォーマットに出力する。   
6. 1の実行開始直後にcallされたsar.shのリソース情報へnmapによるディスカバリ開始・終了時刻をマッピングする(sar-result_and_nmap-log.sh)   

**2.MAC-ADDRESS-Renewal.sh**
1. IEEEのWebサイトからMACアドレス一覧(oui.txt)の取得(curl)する。   
 　　IEEEのURLは適宜変更されることがあり、また応答ステータスコードが200以外の場合は、   
　　  正常取得不可となることがわかっているため、その場合は以降の全処理を停止させることとしている。   
2. 現在のnmapの持つMACアドレス一覧ファイル(nmap_mac_prefixes)のバックアップを取得する。   
3. 1の実行結果(oui.txt)をnmapフォーマット(nmap_mac_prefixes)に変換する。   
　　  *nmapインストール時に配置される：make-mac-prefixes.plを用いて実行する。   
4. 2のバックアップと3)の上書いた実行結果の差分を取得して全処理終了   
　　  *次回のnmap.sh実行時から、更新されたMACアドレスにて処理が実施される。   

## Demo

## VS. 

## Requirement
　事前にnmapとzenmapを以下本家サイトからインストールする必要がある。
　https://nmap.org/

## Usage
**1.nmap.sh**	  
`$ bash -x nmap.sh`  
若しくはcrontabに任意の実行ユーザ、任意の曜日時刻に定期実行するよう記述する。   
`01 14 * * * /usr/local/etc/nmap-tool/nmap.sh `  
   
**2.MAC-ADDRESS-Renewal.sh**   
`$bash -x MAC-ADDRESS-Renewal.sh`  
若しくはcrontabに任意の実行ユーザ、任意の曜日時刻に定期実行するよう記述する。   
`01 14 * * * /usr/local/etc/nmap-tool/MAC-ADDRESS-Renewal.sh` 

## Install  
`$ cd /usr/local/etc/  `  
`$ tar xvzf nmap-tool.tgz`  
    *必要な全ディレクトリ、全ファイルが展開される。   
`$ vi auth.txt ` 
sodoers上でnmapを許可したユーザのパスワードを記述する。   
もしくはnmap.shのスクリプトをrootで実行するようにcatからsudo -Sまでの記述を削除する。   
　　         cat auth.txt | sudo -S nmap -T4 -A -v -iL $NWADDR -oX /tmp/`date "+%Y%m%d%H%M%S"`.xml   
          nmap -T4 -A -v -iL $NWADDR -oX /tmp/`date "+%Y%m%d%H%M%S"`.xml;   


## Contribution
  1. Fork it ( https://github.com/zukkie777/tool_for_nmap )   
  2. Create your feature branch (git checkout -b my-new-feature)   
  3. Commit your changes (git commit -am 'Add some feature’)   
  4. Push to the branch (git push origin my-new-feature)   
  5. Create new Pull Request   

## Licence 


## Author
https://github.com/zukkie777   

