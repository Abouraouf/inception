FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM to listen on all interfaces (not just localhost)
# This allows NGINX in another container to connect
RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|g' /etc/php/*/fpm/pool.d/www.conf

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]