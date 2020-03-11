#!/bin/bash
. /etc/init.d/functions
package="bind"
name_conf="/etc/named.conf"
name_zone="/etc/named.rfc1912.zones"
zone="xuepeng.com"
zone_file="/var/named/${zone}.zone"
ip=192.168.43.9
rpm -q $package &> /dev/null
if [ $? -ne 0 ];then
        yum -q install $package -y && action "package bind install seccessful" true
fi
sed -i.bak -e '/listen-on/s@^@#@' -e '/allow-query/s@^@#@' -e '/allow-query/a\\tallow-transfer { none; };' $name_conf
sed -i.bak '$a\zone "'"$zone"'" IN {\n\ttype slave;\n\tmasters { '"$ip"'; };\n\tfile "slaves/'"$zone"'.zone";\n};' ${name_zone}
named-checkconf &> /dev/null  && systemctl enable --now named && action "service named started" true
