FROM debian:bookworm

RUN apt-get update && apt-get install -y php-fpm php-mysql curl

COPY conf/www.conf /etc/php/8.2/fpm/pool.d

COPY tools/entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]