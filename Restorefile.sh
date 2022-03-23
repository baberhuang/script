#!/bin/bash
#1.解压压缩包内的文件存放在还原目录
#2.复制还原目录中的内容到站点
#3.删除还原目录中的内容

tarfileurl=$1;  #需要解压还原的文件绝对路径

targeturl=$2;   #需要还原站点的根目录

tar -xzvf $tarfileurl -C /backup/Restore; #把要还原的内容解压到专门存放需要还原文件的目录中，如果没有改目录需要事先创建一个

if [ $? -eq 0 ]; then           #判断解压是否成功
	cp -R /backup/Restore/* $targeturl;  #复制存放还原文件目录中的内容到站点
	rm -rf /backup/Restore/*;            #清理还原目录，避免下次操作时内容混乱
else
	rm -rf /backup/Restore/*;            #解压失败也对存放还原文件的目录做清理
	echo "没有找到解压文件或解压失败";
fi

