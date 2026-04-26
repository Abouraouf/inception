FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server mariadb-client


RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld

COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
