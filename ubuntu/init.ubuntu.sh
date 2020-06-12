#!/bin/bash
#
#   This script is used to initialization setup for ubuntu linux.
#

echo "[$(date +%F_%T%z)] Starting initialize." | tee -a /root/init.log 2>&1
grep $(hostname) /etc/hosts || echo "127.0.0.1 $(hostname)" >> /etc/hosts
chmod -R 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
ls -al /root | tee -a /root/init.log 2>&1
ls -al /root/.ssh | tee -a /root/init.log 2>&1
chattr -R +i /root/.ssh

###### Setting ufw ######
echo "[$(date +%F_%T%z)] Setting ufw rules." | tee -a /root/init.log
iptables -t filter -I INPUT 1 -p tcp --dport 22 -j ACCEPT
echo yes | ufw enable | tee -a /root/init.log 2>&1
cp /etc/default/ufw{,.default}
sed -i 's#^IPV6=.*#IPV6=no#g' /etc/default/ufw
ufw allow 22/tcp | tee -a /root/init.log 2>&1
ufw allow from 127.0.0.1 | tee -a /root/init.log 2>&1
ufw default deny incoming | tee -a /root/init.log 2>&1
# for segment in 10.158.0.0/16 10.159.0.0./16 10.49.0.0/16 100.64.0.0/10; do ufw allow from ${segment}; done
ufw status | tee -a /root/init.log 2>&1
[ "$(systemctl is-enabled ufw)" == "enabled" ]||systemctl enable ufw | tee -a /root/init.log 2>&1
grep '^echo y' /etc/rc.local || sed -i '/^exit 0/iecho y | ufw enable' /etc/rc.local 

###### Setting /etc/ssh/sshd_config ######
echo "[$(date +%F_%T%z)] Setting /etc/ssh/sshd_config." | tee -a /root/init.log
cp /etc/ssh/sshd_config{,.default} && cp /etc/ssh/sshd_config{,.$(date '+%F_%T')}
# sed -i 's#^Port 22#\#&#g' /etc/ssh/sshd_config
sed -i 's#^Protocol 1#\#&#' /etc/ssh/sshd_config
sed -i 's#^PasswordAuthentication\s*yes#\#&#' /etc/ssh/sshd_config
sed -i 's#^HostbasedAuthentication\s*yes#\#&#' /etc/ssh/sshd_config
sed -i 's#^PermitRootLogin\s*yes#\#&#' /etc/ssh/sshd_config
grep '^Protocol 2' /etc/ssh/sshd_config || echo 'Protocol 2' >> /etc/ssh/sshd_config
grep '^HostbasedAuthentication\s*no' /etc/ssh/sshd_config || echo 'HostbasedAuthentication no' >>  /etc/ssh/sshd_config
grep '^PasswordAuthentication no' /etc/ssh/sshd_config || echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
grep '^PubkeyAuthentication yes' /etc/ssh/sshd_config || echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
# grep '^ChallengeResponseAuthentication no' /etc/ssh/sshd_config || echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config
grep '^PermitRootLogin prohibit-password' /etc/ssh/sshd_config || echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config
grep '^PermitEmptyPasswords no' /etc/ssh/sshd_config || echo 'PermitEmptyPasswords no' >> /etc/ssh/sshd_config
grep '^LogLevel INFO' /etc/ssh/sshd_config || echo 'LogLevel INFO' >> /etc/ssh/sshd_config
grep '^IgnoreRhosts no' /etc/ssh/sshd_config || echo 'IgnoreRhosts no' >> /etc/ssh/sshd_config
grep '^PermitUserEnvironment no' /etc/ssh/sshd_config || echo 'PermitUserEnvironment no' >> /etc/ssh/sshd_config
grep '^LoginGraceTime 1m' /etc/ssh/sshd_config || echo 'LoginGraceTime 1m' >> /etc/ssh/sshd_config
# TODO: AllowUsers
systemctl restart ssh && netstat -nltp | tee -a /root/init.log 2>&1
[ "$(systemctl is-enabled ssh)" == "enabled" ]||systemctl enable ssh 

# Setting baseline for centos
echo "[$(date +%F_%T%z)] Setting security baseline." | tee -a /root/init.log
# /etc/login.defs
cp /etc/login.defs{,.default} && cp /etc/login.defs{,.$(date '+%F_%T')}
sed -i 's#^PASS_MAX_DAYS.*#PASS_MAX_DAYS\t1095#' /etc/login.defs
sed -i 's#^PASS_MIN_DAYS.*#PASS_MIN_DAYS\t7#g' /etc/login.defs
sed -i 's#^PASS_MIN_LEN.*#PASS_MIN_LEN\t16#' /etc/login.defs
useradd -D -f 1095
# /etc/sysctl.conf
cp /etc/sysctl.conf{,.default} && cp /etc/sysctl.conf{,.$(date '+%F_%T')} 
grep '^net.ipv4.conf.all.send_redirects' /etc/sysctl.conf||echo 'net.ipv4.conf.all.send_redirects=0' >> /etc/sysctl.conf
grep '^net.ipv4.conf.all.accept_redirects' /etc/sysctl.conf||echo 'net.ipv4.conf.all.accept_redirects=0' >> /etc/sysctl.conf
grep '^net.ipv6.conf.all.accept_ra' /etc/sysctl.conf||echo 'net.ipv6.conf.all.accept_ra=0' >> /etc/sysctl.conf
grep '^fs.file-max' /etc/sysctl.conf||echo 'fs.file-max=655350' >> /etc/securitysysctl.conf;
grep pam_limits.so /etc/pam.d/sudo||echo 'session    required     pam_limits.so' >> /etc/pam.d/sudo;
echo 1000000 > /proc/sys/fs/file-max;
ulimit -HSn 655350;

# /etc/security/limits.conf
grep '^# File Descriptor Limits' /etc/security/limits.conf>/dev/null 2>&1||cat >> /etc/security/limits.conf <<EOT
# File Descriptor Limits $(date +%F_%T%z)
*   soft    core    0
*   soft    nofile  102400
*   hard    nofile  655350
EOT

ulimit -s 64000
grep '^# stack' /etc/security/limits.conf || cat >> /etc/security/limits.conf <<EOT
# stack $(date +%F_%T%z)
*       soft    stack   64000
root    soft    stack   64000
EOT

grep '^# TIME_WAIT' /etc/sysctl.conf>/dev/null 2>&1||cat >> /etc/sysctl.conf <<EOT
# TIME_WAIT $(date +%F_%T%z)
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
EOT
# backlog
echo 20480 > /proc/sys/net/core/somaxconn;
echo 20480 > /proc/sys/net/ipv4/tcp_max_syn_backlog;
#sed -i 's#1024#'$(/usr/bin/free|awk '$1=="Mem:" {print int($2/128)}')'#' /etc/security/limits.d/90-nproc.conf
grep '^# backlog' /etc/sysctl.conf||cat >> /etc/sysctl.conf <<EOT
# backlog $(date +%F_%T%z)
net.core.somaxconn = 20480
net.core.netdev_max_backlog = 262144
EOT
sysctl -p
# /etc/rsyslog.conf
cp /etc/rsyslog.conf{,.default} && cp /etc/rsyslog.conf{,.$(date '+%F_$T')}
grep '^$FileCreateMode 0640' /etc/rsyslog.conf || echo '$FileCreateMode 0640' >> /etc/rsyslog.conf

# cron.*
rm -f /etc/cron.deny /etc/at.deny 
touch /etc/cron.allow /etc/at.allow 
chmod 0600 /etc/cron.allow /etc/at.allow
chmod -R 0600 /etc/crontab /etc/cron.d  /etc/{cron.hourly,cron.daily,cron.weekly,cron.monthly}
echo "[$(date +%F_%T%z)] Lock files." | tee -a /root/init.log
# acl permisson
#@TODO: 
sed -i 's#^%sudo.*#\#&#g' /etc/sudoers
echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
chattr +i /etc/sudoers
# chattr -R +i /etc/ssh ~/.ssh
# chmod 0600 /usr/bin/{chattr,lsattr}

###### Format and mount data disk ######
echo "[$(date +%F_%T%z)] Format and mount data disk." | tee -a /root/init.log
[[ -e /dev/vdb ]] && { \
    grep '^/dev/vdb' /etc/fstab || echo "/dev/vdb  /opt ext4 defaults,nofail 0 2" >> /etc/fstab; \
    echo data | mkfs.ext4 /dev/vdb && mkdir -p /opt && mount -a | tee -a /root/init.log 2>&1; \
}
[[ -e /dev/sdb ]] && { \
    grep '^/dev/sdb' /etc/fstab || echo "/dev/sdb  /opt ext4 defaults,nofail 0 2" >> /etc/fstab; \
    echo data | mkfs.ext4 /dev/sdb && mkdir -p /opt && mount -a | tee -a /root/init.log 2>&1; \
}
df -h | tee -a /root/init.log 2>&1
fdisk -l | tee -a /root/init.log 2>&1

###### update & update & Install Packages ######
echo 1|dpkg --configure -a | tee -a /root/init.log 2>&1
apt-get -y update | tee -a /root/init.log 2>&1
apt-get -y install ca-certificates && update-ca-certificates | tee -a /root/init.log 2>&1
apt-get -y install vim language-pack-zh-hant language-pack-zh-hans | tee -a /root/init.log 2>&1
apt-get -y install bash-completion git zip unzip | tee -a /root/init.log 2>&1
apt-get -y install mlocate tree dig telnet  | tee -a /root/init.log 2>&1
apt-get -y install lsof strace iftop htop iotop nmon screen| tee -a /root/init.log 2>&1
apt-get -y install python python-dev python3 python3-dev | tee -a /root/init.log 2>&1
apt-get -y install build-essential libssl-dev libevent-dev libjpeg-dev libxml2-dev libxslt-dev | tee -a /root/init.log 2>&1
apt-get -y install python-pip | tee -a /root/init.log 2>&1
apt-get -y autoremove | tee -a /root/init.log 2>&1
# upgrade system & kerner and need to reboot after run by hand.

###### Install pip Packages ######
echo "[$(date +%F_%T%z)] Installing pip packages." | tee -a /root/init.log
pip install pip --upgrade | tee -a /root/init.log 2>&1
grep ali /etc/apt/sources.list.d/* >/dev/null 2>&1 && pip install aliyun-ecs --upgrade | tee -a /root/init.log 2>&1

###### Set user-agent for wget & curl ######
echo 'user_agent = Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3405.0 Safari/537.36' >> /root/.wgetrc
echo '' > /root/.curlrc

# Install Docker
echo "[$(date +%F_%T%z)] Install docker-ce." | tee -a /root/init.log
apt-get -y install apt-transport-https ca-certificates curl software-properties-common | tee -a /root/init.log 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - | tee -a /root/init.log 2>&1
sudo apt-key fingerprint 0EBFCD88 | tee -a /root/init.log 2>&1
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee -a /root/init.log 2>&1
apt-get update && apt-get -y install docker-ce --allow-unauthenticated| tee -a /root/init.log 2>&1
systemctl start docker | tee -a /root/init.log 2>&1
systemctl enable docker | tee -a /root/init.log 2>&1
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "[$(date +%F_%T%z)] Setting bootstrap." | tee -a /root/init.log
echo 'TODO: bootstrap' | tee -a /root/init.log

echo -e "\n\n$(hostname) $(ifconfig|grep 'inet addr:'|grep -v 127|awk '{print $2}'|tr -d 'addr:'|tr '\n' ' ')\n" | tee -a /root/init.log 2>&1
echo "[$(date +%F_%T%z)] Done" | tee -a /root/init.log  | tee -a /root/init.log 2>&1
echo "apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y autoremove && reboot" | tee -a /root/init.log 2>&1

###### Install oracle-java8 ######
# apt-get -y install software-properties-common &&
# add-apt-repository ppa:webupd8team/java && apt-get update &&
# apt-get -y install oracle-java8-installer 
# echo "\n" | update-alternatives --config java
# dpkg --configure -a