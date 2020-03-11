#!/bin/bash
. /etc/init.d/functions
rpm -q httpd &> /dev/null
if [ $? -ne 0 ];then
        yum -q install httpd -y && action "package httpd is installed"
fi
cat <<-EOF > /etc/httpd/conf.d/test.conf
<virtualhost *:80>
        documentroot /var/www/html
        servername www.xuepeng.com
        <directory /var/www/html>
                require all granted
        </directory>
</virtualhost>
EOF
echo "www.xuepeng.com" > /var/www/html/index.html
killall -0 httpd &> /dev/null || systemctl enable --now httpd && action "service httpd started"

