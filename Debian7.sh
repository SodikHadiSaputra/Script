#!/bin/bash

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://fs03n2.sendspace.com/dl/f78eaaa9424b22730fd5099ad9b08bbd/58b8de8d3e7c9603/dlx6y2/listdebian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update; apt-get -y upgrade;

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i venet0
service vnstat restart

# install screenfetch
cd
wget https://github.com/KittyKatt/screenFetch/raw/master/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://fs09n3.sendspace.com/dl/9d4745a444dec574e1a4f2986162171f/58b8de715dd58c2e/5so2md/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup By Sodik Hadi Saputra</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://fs06n1.sendspace.com/dl/3b0d66edea982fe8dc791ce5dec28d38/58b8de56618777cc/epsgdk/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.github.com/choirulanam217/script/master/conf/badvpn-udpgw"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install mrtg
wget -O /etc/snmp/snmpd.conf "https://fs02n4.sendspace.com/dl/59d0f406103607b0728bb774b5121842/58b8de2b0e6859db/pmp53i/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://fs11n5.sendspace.com/dl/cdfa69c198966bb940d8a49de365060d/58b8de042089d357/ohu1nj/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "https://fs08n3.sendspace.com/dl/334a3656db6735a3a272ca6896445dfb/58b8dddc5a25bc2d/ev4xe7/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i 's/eth0/venet0/g' config.php
sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.670_all.deb"
dpkg --install webmin_1.670_all.deb;
apt-get -y -f install;
rm /root/webmin_1.670_all.deb
service webmin restart
service vnstat restart

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://fs05n5.sendspace.com/dl/9d47c2a12cbc01132e984af7710e2974/58b8dd944f906cb4/e7ipl0/squid.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# downlaod script
wget "https://fs07n2.sendspace.com/dl/dd2a13e76c01428845243e45f8413f1a/58b8dd09533cdcb3/863er8/cekakun.sh"
cp ./cekakun.sh /usr/bin/cekakun
wget "https://fs08n1.sendspace.com/dl/ce509844f21202b822673eb9c20c4e40/58b8dd5a67b9cd36/sl1115/usernew.sh"
cp ./usernew.sh /usr/bin/usernew
chmod +x /usr/bin/usernew
chmod +x /usr/bin/cekakun
rm ./usernew.sh
rm ./cekakun.sh

# finalisasi
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php-fpm start
service vnstat restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service webmin restart
service squid3 restart

# info
echo "Webmin   : https://$MYIP:10000/"  | tee -a log-install.txt
echo "vnstat   : http://$MYIP/vnstat/"  | tee -a log-install.txt
echo "MRTG     : http://$MYIP/mrtg/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo "=============OpenSSH port 22, 143=============="
echo "===========DropBear port 109, 110, 443========="
echo "============Silahkan Reboot VPS Anda==========="
echo "========Script By Aa Sodik Hadi Saputra========"  | tee -a log-install.txt
echo "==============================================="  
