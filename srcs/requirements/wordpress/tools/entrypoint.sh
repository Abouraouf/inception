#!/bin/bash

# 1. Wait for MariaDB
until mariadb -h mariadb -u${DB_USER} -p${DB_PASS} -e "SELECT 1" 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

cd /var/www/html

# 2. Download WordPress core if not present
if [ ! -f wp-settings.php ]; then
    wp core download --allow-root
fi

# 3. Create wp-config.php if not present
if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname=${DB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_PASS} \
        --dbhost=mariadb:3306 \
        --allow-root
fi

# 4. YOUR CODE (install WordPress, create second user)
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

# 5. Set permissions and start PHP-FPM
chown -R www-data:www-data /var/www/html
exec php-fpm8.2 -F