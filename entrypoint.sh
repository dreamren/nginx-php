#!/bin/bash

#wget https://dream.ren/down/other/nginx_docker.conf -O /etc/nginx/nginx.conf --no-check-certificate

/etc/init.d/ssh restart

#nginx -t

#nginx

/etc/init.d/shadowsocks-libev start

#nohup kcptun -c /etc/kcptun.json &
kcptun -c /etc/kcptun.json
#wc
#tail -f /var/log/nginx/error.log > /dev/null
