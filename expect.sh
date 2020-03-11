#!/bin/bash
#
 ssh-keygen -P "" -t rsa -f /root/.ssh/id_rsa &> /dev/null
rpm -q expect &> /dev/null || yum install expect -y &> /dev/null
cat <<-EOF > host.pw
192.168.209.9 node1
192.168.209.49 node2
192.168.209.29 node3
192.168.209.39 node4
192.168.209.59 node5
EOF
while read IP PW;do
expect <<EOF
set timeout 20
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$IP
expect {
"yes/no" { send "yes\n";exp_continue }
"password" { send "$PW\n" }
}
expect eof
EOF
done < host.pw

