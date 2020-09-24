FROM debian:stretch-slim

LABEL maintainer="OpenSSH & Nginx & Shadowsocks-libev & Kcptun-server <admin@dream.ren>"

#安装预编译Shadowsocks-libev、OpenSSH
RUN sh -c 'printf "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list' 
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openssh-server openssl nload wget iputils-ping dnsutils net-tools gnupg1 apt-transport-https ca-certificates && \
	apt-get -t stretch-backports install php-fpm -y && \
	echo "alias wget='wget --no-check-certificate'" >>/root/.bashrc

#配置远程登录
RUN echo "root:password"|chpasswd && \
	sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/^#ClientAliveInterval\s+.*/ClientAliveInterval 30/' /etc/ssh/sshd_config && \
	sed -ri 's/^#ClientAliveCountMax\s+.*/ClientAliveCountMax 5/' /etc/ssh/sshd_config
RUN sed -ri 's/^group = www-data/group = www/' /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -ri 's/^listen.group = www-data/listen.group = www/' /etc/php/7.0/fpm/pool.d/www.conf
RUN groupmod -n www www-data


#安装官方预编译Nginx
RUN wget -q https://nginx.org/keys/nginx_signing.key --no-check-certificate && \
	apt-key add nginx_signing.key && rm -f nginx_signing.key && \
	echo "deb https://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list &&\
	echo "deb-src https://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list &&\
	apt-get update && apt-get install nginx -y && \
	apt-get remove --purge --auto-remove -y apt-transport-https ca-certificates gnupg1 && rm -rf /etc/apt/sources.list.d/nginx.list

#修改时区
RUN echo "export TZ=’Asia/Shanghai’" >> /etc/profile

#复制配置文件
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 22 433 443 998 999

CMD ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
