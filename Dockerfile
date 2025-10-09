FROM php:8.2-fpm

EXPOSE 10000

RUN apt-get update && apt-get install -y \
    libzip-dev libonig-dev libxml2-dev unzip curl git zip \
    && docker-php-ext-install mbstring zip pdo_mysql bcmath xml \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Node.js telepítése hivatalos tarballból
RUN curl -fsSL https://nodejs.org/dist/v20.19.0/node-v20.19.0-linux-x64.tar.xz | tar -xJ -C /usr/local --strip-components=1

WORKDIR /var/www/html

COPY . .

RUN cp .env.example .env

# Composer telepítése
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --optimize-autoloader

RUN npm install
RUN npm run build

RUN php artisan key:generate \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan migrate --force \
    && php artisan migrate --seed

RUN chown -R www-data:www-data storage bootstrap/cache

CMD ["php-fpm"]
