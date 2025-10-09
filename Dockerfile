FROM php:8.1-fpm-alpine

RUN apk add --no-cache bash curl

# Node.js 20.19.0 telepítése hivatalos tarballból
RUN curl -fsSL https://nodejs.org/dist/v20.19.0/node-v20.19.0-linux-x64.tar.xz | tar -xJ -C /usr/local --strip-components=1

WORKDIR /var/www/html

COPY . .

# Composer telepítése
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --no-dev --optimize-autoloader

RUN npm install

RUN npm run build

RUN php artisan key:generate \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan migrate --force \
    && php artisan migrate --seed

RUN chown -R www-data:www-data storage bootstrap/cache

CMD ["php-fpm"]
