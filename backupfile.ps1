param($PUBLISH_PATH,$UPLOAD_PATH,$BACKUP_PATH)
if ($PUBLISH_PATH -and $UPLOAD_PATH -and $BACKUP_PATH) {
$fileList = Get-ChildItem -Recurse -Path $UPLOAD_PATH -File -Name
$PathList = Get-ChildItem  -Recurse -Path $UPLOAD_PATH -Name -Dir

#按照文件目录创建路径
foreach ($textPath in $PathList){
      $creatPath = $BACKUP_PATH+$textPath
      New-Item -Path $creatPath -Type Directory -force
   }

#根据路径拷贝文件
foreach ($textfile in $fileList) {
       echo $textfile
       $filePath=$PUBLISH_PATH+$textfile
       $copypath=$BACKUP_PATH+$textfile
   if ( Test-Path $filePath ){
      copy-item $filePath -Destination $copypath
    }
   else {
           echo "文件不存在"
    }
 }
}
else{
    echo "path is empty"
}