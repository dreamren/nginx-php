#!/bin/bash

cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#wget https://dream.ren/down/other/nginx_docker.conf -O /etc/nginx/nginx.conf --no-check-certificate

/etc/init.d/ssh restart

nginx -t

nginx


nohup kcptun -c /etc/kcptun.json &


while :
do
  #wget https://dream.ren/tool/arukas/?hostname=`hostname` -q --tries=2 -O /dev/null --no-check-certificate
  netstat -unlp |grep 433 > /dev/null
  if [ $? -ne 0 ];then
    nohup kcptun -c /etc/kcptun.json &
  fi
  sleep 20
done

#wc
#tail -f /var/log/nginx/error.log > /dev/null
