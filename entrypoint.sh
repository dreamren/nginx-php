#!/bin/bash

#wget https://dream.ren/down/other/nginx_docker.conf -O /etc/nginx/nginx.conf --no-check-certificate

/etc/init.d/ssh restart

nginx -t

nginx

/etc/init.d/shadowsocks-libev start

nohup kcptun -c /etc/kcptun-nginx.json &

nohup kcptun -c /etc/kcptun-ss.json &

while :
do
  wget https://dream.ren/tool/arukas/?hostname=`hostname` -q --tries=2 -O /dev/null --no-check-certificate
  netstat -unlp |grep 433 > /dev/null
  if [ $? -ne 0 ];then
    nohup kcptun -c /etc/kcptun-nginx.json &
  fi
  netstat -unlp |grep 999 > /dev/null
  if [ $? -ne 0 ];then
    nohup kcptun -c /etc/kcptun-ss.json &
  fi
  sleep 20
done

#wc
#tail -f /var/log/nginx/error.log > /dev/null
