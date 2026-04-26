#!/bin/bash

# Print for debugging
echo "DB_NAME = ${DB_NAME}"
echo "DB_USER = ${DB_USER}"

# Start database in background
service mariadb start

# Wait for socket file to appear (up to 30 seconds)
for i in {1..30}; do
    if [ -S /run/mysqld/mysqld.sock ] && mariadb-admin ping --silent 2>/dev/null; then
        break
    fi
    sleep 1
done

# Run SQL to create database and user
mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Stop temporary instance
mariadb-admin -u root shutdown

# Start main database process (PID 1)
exec mariadbd --user=mysql --bind-address=0.0.0.0