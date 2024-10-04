FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    sqlite3 \
    && docker-php-ext-install pdo pdo_sqlite

RUN a2enmod rewrite

COPY .env.db /var/www/.env.db
COPY ./php /var/www/html
COPY ./database /var/www/database

WORKDIR /var/www/html

# Set permissions for the entire /var/www/html directory
RUN chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /var/www/database && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

# Run the init script
RUN chmod -R 755 ../database && \
    ../database/init.sh "../db.sqlite"
    #&& \
    #mv database/db.sqlite ./db.sqlite && \
    #chown www-data:www-data ./db.sqlite && \
    #chmod 666 ./db.sqlite

# Switch to www-data user
USER www-data

CMD ["apache2-foreground"]