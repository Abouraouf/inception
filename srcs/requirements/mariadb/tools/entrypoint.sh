#!/bin/bash
mysqld --user=mysql --skip-networking &
until mariadb-admin ping --silent 2>/dev/null; do sleep 1; done
mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
mariadb-admin -u root shutdown
exec mariadbd --user=mysql --bind-address=0.0.0.0 --port=3306