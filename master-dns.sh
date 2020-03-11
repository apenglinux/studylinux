#!/bin/bash
. /etc/init.d/functions
package="bind"
name_conf="/etc/named.conf"
name_zone="/etc/named.rfc1912.zones"
zone="xuepeng.com"
zone_file="/var/named/${zone}.zone"
ip=192.168.43.9
slave_ip=192.168.43.19
rpm -q $package &> /dev/null
if [ $? -ne 0 ];then
        yum -q install $package -y && action "package bind install seccessful" true
fi
sed -i.bak -e '/listen-on/s@^@#@' -e '/allow-query/s@^@#@' -e '/allow-query/a\\tallow-transfer { '"$slave_ip"'; };' $name_conf
sed -i.bak '$a\zone "'"$zone"'" IN {\n\ttype master;\n\tfile "'"$zone"'.zone";\n};' ${name_zone}
cat <<EOF > ${zone_file}
\$TTL 1D
@ IN SOA master admin ( `date +%F|tr -dc [:digit:]` 1D 1H 1W 3H )
     NS  master
     NS  slave
master A $ip
slave  A ${slave_ip}
EOF
chgrp named ${zone_file}
chmod  640 ${zone_file}
named-checkconf &> /dev/null  && named-checkzone $zone  ${zone_file} &> /dev/null \
&& systemctl enable --now named && action "service named started" true

