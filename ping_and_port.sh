#!/bin/bash
if [ $2 ]; then
	nc -z -w 5 $1 $2 > /dev/null 2>&1
else
	ping -c2 $1 > /dev/null 2>&1
fi

if [ $? == 0 ]; then
  echo 1
else
  echo 0
fi
