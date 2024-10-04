FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    sqlite3 \
    && docker-php-ext-install pdo pdo_sqlite

RUN a2enmod rewrite

COPY . /var/www/html
WORKDIR /var/www/

# Create the database file and set permissions
RUN cd /var/www/ && \
    touch db.sqlite && \
    chown www-data:www-data db.sqlite && \
    chmod 666 db.sqlite

WORKDIR /var/www/html
# Set permissions for the entire /var/www/html directory
RUN chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

# Switch to www-data user
USER www-data

CMD ["apache2-foreground"]