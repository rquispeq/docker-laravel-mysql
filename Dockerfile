# Use the official PHP image with Apache
FROM php:8.1-apache

# Set working directory
WORKDIR /var/www/html

# Install necessary extensions and dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libmariadb-dev \
    unzip \
    zip \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd intl pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy Laravel project to the working directory
# COPY ../backend /var/www/html

# Set correct permissions for Laravel
RUN chown -R www-data:www-data /var/www/html 
    # && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Configure Apache
COPY ./default.conf /etc/apache2/sites-available/000-default.conf

# Copy OPCache configuration
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
