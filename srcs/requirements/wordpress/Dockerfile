FROM debian:bookworm

RUN apt update -y && apt upgrade -y &&  apt install -y php php-mysql php-fpm curl php-redis

COPY tools/www.conf /etc/php/8.2/fpm/pool.d

COPY tools/install.sh /usr/bin/install.sh

RUN chmod +x /usr/bin/install.sh 

ENTRYPOINT ["install.sh"]