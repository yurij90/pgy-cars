FROM php:8.2-fpm-alpine

# Szükséges eszközök és PHP extensionök telepítése
RUN apk add --no-cache bash curl libzip-dev oniguruma-dev autoconf gcc g++ make \
    && docker-php-ext-install mbstring zip pdo_mysql bcmath xml tokenizer fileinfo curl openssl

# Node.js 20.19.0 telepítése hivatalos tarballból
RUN curl -fsSL https://nodejs.org/dist/v20.19.0/node-v20.19.0-linux-x64.tar.xz | tar -xJ -C /usr/local --strip-components=1

WORKDIR /var/www/html

# Projekt fájlok másolása
COPY . .

# Composer telepítése
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Composer függőségek telepítése
RUN composer install --no-dev --optimize-autoloader

# npm csomagok telepítése és build futtatása
RUN npm install
RUN npm run build

# Laravel parancsok futtatása
RUN php artisan key:generate \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan migrate --force \
    && php artisan migrate --seed

# Jogosultságok beállítása
RUN chown -R www-data:www-data storage bootstrap/cache

# Konténer indítása PHP-FPM szerverrel
CMD ["php-fpm"]
