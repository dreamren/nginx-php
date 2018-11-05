#!/bin/bash

cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#wget https://dream.ren/down/other/nginx_docker.conf -O /etc/nginx/nginx.conf --no-check-certificate

/etc/init.d/ssh restart


/etc/init.d/shadowsocks-libev start


nohup kcptun -c /etc/kcptun-ss.json &

while :
do
  kcptun -c /etc/kcptun-ss.json
done

#wc
