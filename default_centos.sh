#! /bin/bash

# 检查运行账户信息
if [ "$UID" -ne 0 ];then
        echo "当前用户 $(whoami) 不是管理员账身份，请使用管理员身份运行"
        exit 1
fi

#配置bash命令提示符颜色
echo "PS1='[\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;36m\]\W\[\033[00m\]]\$ '" >> /etc/profile
echo "已配置bash命令提示符颜色"

#配置history命令时间显示
echo "export HISTTIMEFORMAT='%F %T '"  >> /etc/profile
echo "已配置history命令时间显示"

#10分钟无操作，自动注销root账户
sed -i '/HISTSIZE=/a\TMOUT=600' /etc/profile
echo "已配置root10分钟无操作自动注销账户"

#全局生效环境变量
source /etc/profile
echo "已全局生效环境变量Profile"

#同步NTP时间，并设置时区为上海
yum install -y ntp 
ntpdate ntp.aliyun.com
timedatectl set-timezone Asia/Shanghai
echo "* 2 * * * * root /usr/sbin/ntpdate ntp.aliyun.com" >> /etc/crontab
echo "已完成NTP时间同步"

#关闭防火墙、Selinux
systemctl stop firewalld.service
systemctl disable firewalld.service
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
setenforce 0
echo "已关闭防火墙 selinux"

#安装必要软件，并yum upgrade
if ping -c2 www.bing.com &>/dev/null ;then
        echo "正在YUM初始化程序... ..."
yum install -y net-tools vim lrzsz wget curl 
#yum upgrade -y 
else
        echo "检查网络！"
        exit 2
fi
echo "YUM 初始化已完成"

#创建用户并设置nopasswd sudo权限

#配置SSH只允许指定ip登录
echo "allowusers stkops@172.16.98.227" >>  /etc/ssh/sshd_config
echo "allowusers stkdev@172.16.98.227" >>  /etc/ssh/sshd_config
echo "allowusers root@172.16.98.168" >> /etc/ssh/sshd_config
echo "allowusers itlocal@172.16.98.168" >> /etc/ssh/sshd_config
systemctl restart sshd

#写入root ansible server 公钥
RSA="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYyqq1KCWN3DqXuCPbFE34pg2ZGtueHkhuqdY3EGEIgFtAZSOh1RABkrfjJdJsfOjkfbMjcokeMf2fd7JjeZJj02ok7+kARU7gCP/61jDcbgONJEAQwwWKKfv/VE5ODf4zQ6SPNIQsr+aBhBPNQc6bvbRkrIL7Mm/umbos50+GquyJlxb9yWk3mL2TraHOhdqPv66cOUs8Ldt2QQG93vsu//4fyWL/7f5fJ2QRTYTSXByK5cidvqSgYPkTkwBVtVv+WIGRigOM/Xmfl7XuynY0t+/wt/O2tpHdeNze+jjai6lWm2T2L42FlTobZEBGMsIianpYVh1ZVJNOMK1Ct9YD root@Ansible"

if [ ! -f "/root/.ssh/authorized_keys" ];then
   mkdir /root/.ssh/
   touch /root/.ssh/authorized_keys
   chmod 600 /root/.ssh/authorized_keys
   echo $RSA >> /root/.ssh/authorized_keys
else
   echo $RSA >> /root/.ssh/authorized_keys
fi
echo "已完成ansible root公钥拷贝"

#写入itlocal ansible server 公钥
RSA1="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsHkiZd5EH+Xr6yYNxMf7DFe3Cgx2l3lcDNrP7MgCnQrOgIpS+/53uyn/g/ROVWBtrCNKjyvPuid2CaoFJsuRQ+wITTzD4s4PMdfTz9QGwhlszLEoxH8jchQ4Dpg5SVmXeU5C/bYxJlulbaYxCW3tx1qknMrRsgW4VGwV2i4CpEwPL++KueQOjmrEO/D3/CHnW0Gd7Y5T2JP83816X8PHZrWMjv9hDhMP7+PvgmlfnTRg7zwdyzi10HU1kTv+vW6ZjnZgBkBPgzKYze+jVU4jaDvhf3kqRNUaeDxMFf1/t5U5sF164e6TR73RpfXapXrE0qdTt7+0g19xqc23oUOMN itlocal@Ansible"

if [ ! -f "/home/itlocal/.ssh/authorized_keys" ];then
   mkdir /home/itlocal/.ssh/
   touch /home/itlocal/.ssh/authorized_keys
   chmod 600 /home/itlocal/.ssh/authorized_keys
   chmod 700 /home/itlocal/.ssh
   chown itlocal:itlocal /home/itlocal/.ssh/ -R
   echo $RSA1 >> /home/itlocal/.ssh/authorized_keys
else
   echo $RSA1 >> /home/itlocal/.ssh/authorized_keys
fi
echo "已完成ansible itlocal公钥拷贝"

#配置MOTD
echo 'ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
oooooooooooooo/         \oooooooooooooooooo/     =oooooooooooooooooooooooooooooooo^   =ooooooooo`,]] =ooooooooooooooo
ooooooooooooo     ]]`    ,ooooooooooooooooo    ,oooo[   =ooooo[   oooooooooooooooo^   =ooooooooo ^  o ooooooooooooooo
oooooooooooo^    ooooo    ooooooo[[[\oooooo    ooooo    =ooooo    ooooooo/[[[ooooo^   =ooooooooo^ ,` /ooooooooooooooo
oooooooooooo^     ,[\oooooooo/         ,o        ^         ^         o/         \o^   =o/    /ooooooooooooooooooooooo
ooooooooooooo\          ,\oo^    ooo`    oo    ooooo    =ooooo    ooo^   ,oo\    o^   =`   ,ooooooooooooooooooooooooo
ooooooooooooooooo\]`      =o    =oooo    =o    ooooo    =ooooo    ooo            =^       =oooooooooooooooooooooooooo
oooooooooooo    \ooooo    =o    =oooo    /o    ooooo    =ooooo    ooo    ,]]]]]]]/^   =    =ooooooooooooooooooooooooo
oooooooooooo`    [\/[     /o\    \oo`   ,oo    ooooo    =ooooo    =oo^    oo/    o^   =o    ,oooooooooooooooooooooooo
ooooooooooooo`          ,ooooo`        /ooo    ooooo^      ooo^      o\         /o^   =oo`    \oooooooooooooooooooooo
ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo' > /etc/motd

#初始化完成，重启系统
#for time in `seq 9 -1 0` ;
#do
#       echo -n -e "已完成系统初始化，$time秒后将重启服务器\r"
#       sleep 1
#done
#reboot
