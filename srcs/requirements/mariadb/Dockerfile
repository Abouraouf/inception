FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server

# RUN mkdir -p /run/mysqld
#p stands for parent, it creates the parent if it does not exist

#R stands for recursive

COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
