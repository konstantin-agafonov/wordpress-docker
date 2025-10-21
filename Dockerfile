FROM php:8.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    libxslt1-dev \
    libmagickwand-dev \
    unzip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo_mysql \
    zip \
    intl \
    mbstring \
    xml \
    xsl \
    opcache

# Install Imagick extension
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Create a script to copy WordPress files on startup
RUN echo '#!/bin/bash\n\
if [ ! -f /var/www/html/wp-config.php ]; then\n\
    echo "Copying WordPress files to volume..."\n\
    cp -r /usr/src/wordpress/* /var/www/html/\n\
    chown -R www-data:www-data /var/www/html\n\
    chmod -R 755 /var/www/html\n\
    echo "WordPress files copied successfully"\n\
fi\n\
# Set permissions for host user (UID 1000)\n\
chown -R 1000:1000 /var/www/html\n\
exec "$@"' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Copy WordPress files to a temporary location
COPY --from=wordpress:latest /usr/src/wordpress /usr/src/wordpress

# Configure PHP
RUN echo "upload_max_filesize = 50G" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 50G" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/uploads.ini

# Expose port
EXPOSE 9000

# Start PHP-FPM with custom entrypoint
CMD ["/usr/local/bin/entrypoint.sh", "php-fpm"]
