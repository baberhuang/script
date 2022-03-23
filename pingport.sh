nc -z -w 5 $1 $2 > /dev/null 2>&1  
if [ $? -eq 0 ]; then
  echo 1
else
  echo 0
fi