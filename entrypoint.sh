#!/bin/bash

cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

/etc/init.d/ssh restart

while :
do
  sleep 10000
done

#wc
tail -f /usr/share/zoneinfo/Asia/Shanghai > /dev/null
