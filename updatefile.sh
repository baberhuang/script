#!/bin/bash

sourceurl=$1;  #第一个参数输入上传更新的根目录

targeturl=$2;   #第二个参数输入站点的根目录

datetime=$(date +%Y%m%d%H%M);

cd $sourceurl; #进入上传更新的目录

find . -type f > /backup/backuplist.txt #查找上传更新的目录中有哪些文件

cd $targeturl #进入站点的根目录

tar -czvf /backup/backup${datetime}.tar.gz -T /backup/backuplist.txt #备份之前要更新的文件

if [ $? -eq 0 ]; then  #判断备份是否成功
  cp -R $sourceurl/* $targeturl
else
  echo "备份没有执行成功，拒绝更新"
fi
