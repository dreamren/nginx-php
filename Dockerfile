FROM debian:stretch-slim

LABEL maintainer="OpenSSH & Nginx & Shadowsocks-libev & Kcptun-server <admin@dream.ren>"

#安装预编译Shadowsocks-libev、OpenSSH
RUN sh -c 'printf "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list' 
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openssh-server openssl nload wget iputils-ping dnsutils net-tools gnupg1 apt-transport-https ca-certificates && \
	apt-get -t stretch-backports install shadowsocks-libev -y && \
	echo "alias wget='wget --no-check-certificate'" >>/root/.bashrc

#配置远程登录
RUN echo "root:password"|chpasswd && \
	sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/^#ClientAliveInterval\s+.*/ClientAliveInterval 30/' /etc/ssh/sshd_config && \
	sed -ri 's/^#ClientAliveCountMax\s+.*/ClientAliveCountMax 5/' /etc/ssh/sshd_config

#获取Kcptun可执行文件
RUN wget -q -O- https://api.github.com/repos/xtaci/kcptun/releases/latest --no-check-certificate |grep download_url.*linux-amd64 |awk '{print $2}'|xargs -n1 wget -q --no-check-certificate && \
	tar -xzf *.gz && rm *.gz && \
	mv server_linux_amd64 /usr/local/bin/kcptun && \
	rm -f client_linux_amd64


#安装官方预编译Nginx
RUN wget -q https://nginx.org/keys/nginx_signing.key --no-check-certificate && \
	apt-key add nginx_signing.key && rm -f nginx_signing.key && \
	echo "deb https://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list &&\
	echo "deb-src https://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list &&\
	apt-get update && apt-get install nginx -y && \
	apt-get remove --purge --auto-remove -y apt-transport-https ca-certificates gnupg1 && rm -rf /etc/apt/sources.list.d/nginx.list
	
#生成密钥对
RUN openssl req -new -x509 -days 3650 -nodes -subj "/C=CA/ST=CA/L=CA/O=CA/OU=CA/CN=CA"  -out /etc/nginx/cert.pem -keyout /etc/nginx/key.pem

#复制配置文件
COPY nginx.conf /etc/nginx/nginx.conf
COPY shadowsocks.json /etc/shadowsocks-libev/config.json
COPY kcptun-ss.json /etc/kcptun-ss.json
COPY kcptun-nginx.json /etc/kcptun-nginx.json
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 22 433 443 998 999

CMD ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
