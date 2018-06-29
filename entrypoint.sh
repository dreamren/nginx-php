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
  netstat -unlp |grep 433
  if [ $? -ne 0 ];then
    nohup kcptun -c /etc/kcptun-nginx.json &
  fi
  netstat -unlp |grep 998
  if [ $? -ne 0 ];then
    nohup kcptun -c /etc/kcptun-ss.json &
  fi
  sleep 30
done

#wc
#tail -f /var/log/nginx/error.log > /dev/null
