#!/bin/bash

# Program: 新建SFTP用户，并初始化目录及权限
# Author : Duke.Guan@softtek.com
# Date   : 2020-11-11
# Version: 2.0

#读取新建的用户名
read -p '请输入你需要创建的用户名,比如XXX_YYY_S: ' USER
if [ -z "$USER" ];then
    echo -e '请输入你需要创建的用户名！'
    exit
fi

#读取用户SFTP目录
read -p '请指定新用户的SFTP的目录名，比如XXX_YYY:  ' DIRNAME
if [ -z "$DIRNAME"  ];then
    echo -e '请指定新用户的SFTP的目录名！'
    exit
fi

BASHPATH="/data/SFTP"
WORKPATH=$(dirname $0)
GROUP=${DIRNAME}
PWD="Abbott${USER:0:3}!"
 
#检查SFTP根目录
if [ ! -d "${BASHPATH}" ];then
   echo "SFTP根目录不存在，请再次检查$BASHPATH"
   exit
fi

#检查用户组
egrep "^$GROUP" /etc/group >& /dev/null
if [ $? -ne 0 ];then
    groupadd $GROUP
else
    echo "用户组已存在，请再次检查参数！"
    exit
fi

#判断用户是否存在，不存在则创建用户&目录及授权
egrep "^$USER" /etc/passwd >& /dev/null
if [ $? -ne 0 ] ;then
    useradd -g $GROUP -s /sbin/nologin -M $USER
    echo "$PWD" | passwd --stdin $USER
    mkdir $BASHPATH/$DIRNAME/$DIRNAME -p
    mkdir $BASHPATH/$DIRNAME/$DIRNAME"_TEST" -p
    chown root:$GROUP -R $BASHPATH/$DIRNAME
    chmod 755 $BASHPATH/$DIRNAME
    chmod 770 $BASHPATH/$DIRNAME/$DIRNAME
    chmod 770 $BASHPATH/$DIRNAME/$DIRNAME"_TEST"
	
#记录新增用户信息到日志文件
    echo -e "$(date +"%Y%m%d %H:%M%S")\t用户名：$USER\t密码：$PWD\t上传路径：$BASHPATH/$DIRNAME\n" >> $WORKPATH/add_sftpUser_$(date +"%Y%m%d").log
    echo "$WORKPATH/add_sftpUser_$(date +"%Y%m%d").log记录已更新"

#添加用户配置至SSH配置文件
    if [ ! -d "/etc/ssh/sshd_config_bak" ];then
       mkdir /etc/ssh/sshd_config_bak
    fi
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bak/sshd_config_`date +%Y%m%d%H%M`.bak
    cat>>/etc/ssh/sshd_config<<EOF
#添加SFTP用户$USER
Match user $USER
ChrootDirectory $BASHPATH/$DIRNAME
ForceCommand    internal-sftp
EOF

#重启SSH服务
    systemctl restart sshd.service
else 
    echo "用户已存在，请再次检查参数！"
    exit
fi 

    

