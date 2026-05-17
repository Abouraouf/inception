#!/bin/bash

until mariadb-admin ping -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASS}" --silent 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

cd /var/www/html

if [ ! -f wp-settings.php ]; then
    wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname=${DB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_PASS} \
        --dbhost=mariadb:3306 \
        --allow-root
fi

if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    wp core install \
        --url=${DOMAIN} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN} \
        --admin_password=${WP_ADMIN_PASS} \
        --admin_email=${WP_EMAIL} \
        --skip-email \
        --allow-root
else
    echo "WordPress already installed. Skipping..."
fi

if ! wp user get ${WP_SECOND} --allow-root 2>/dev/null; then
    wp user create ${WP_SECOND} \
        ${WP_SECOND_EMAIL} \
        --role=author \
        --user_pass=${WP_SECOND_PASS} \
        --allow-root
else
    echo "User ${WP_SECOND} already exists. Skipping..."
fi

chown -R www-data:www-data /var/www/html
exec php-fpm8.2 -F 