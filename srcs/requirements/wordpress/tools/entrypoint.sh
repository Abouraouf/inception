#!/bin/bash

# Wait for MariaDB (keep this)

# Check if WordPress is already installed
if ! wp core is-installed --allow-root --path=/var/www/html 2>/dev/null; then
    echo "Installing WordPress..."
    wp core install \
        --url=${DOMAIN} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN} \
        --admin_password=${WP_ADMIN_PASS} \
        --admin_email=${WP_EMAIL} \
        --skip-email \
        --allow-root \
        --path=/var/www/html
else
    echo "WordPress already installed. Skipping..."
fi

# Check if second user exists
if ! wp user get ${WP_SECOND} --allow-root --path=/var/www/html 2>/dev/null; then
    wp user create ${WP_SECOND} \
        ${WP_SECOND_EMAIL} \
        --role=author \
        --user_pass=${WP_SECOND_PASS} \
        --allow-root \
        --path=/var/www/html
else
    echo "User ${WP_SECOND} already exists. Skipping..."
fi