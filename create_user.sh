#!/bin/sh

#设置变量name接收第一个参数（要创建的用户名），$n表示第n个参数，且=两边不能有空格
name=$1

#设置变量pass接收第二个参数（要为其设置的密码）
#pass=$2

#echo语句会输出到控制台，${变量}或者 $变量 表示变量代表的字符串
echo "you are setting username : ${name}"
#echo "you are setting password : $pass for ${name}"

#添加用户$name，此处sudo需要设置为无密码，后面将会作出说明
sudo useradd $name

#如果上一个命令正常运行，则输出成功，否则提示失败并以非正常状态退出程序
# $?表示上一个命令的执行状态，-eq表示等于，[ 也是一个命令
# if fi 是成对使用的，后面是前面的倒置，很多这样的用法。
if [ $? -eq 0 ];then
   echo "user ${name} is created successfully!!!"
else
   echo "user ${name} is created failly!!!"
   exit 1
fi

#sudo passwd $name会要求填入密码
sudo passwd $name 
if [ $? -eq 0 ];then
   echo "${name}'s password is set successfully"
else
   echo "${name}'s password is set failly!!!"
fi

#添加Nopasswd sudo权限
echo "$name    ALL=(ALL)       NOPASSWD:ALL" >> /etc/sudoers

