# 1. stage: Node.js 20.19-alpine hivatalos image a buildhez
FROM node:20.19-alpine as node-builder

WORKDIR /app

# A dependency fájlok másolása és telepítése
COPY package*.json ./
RUN npm install

# Kód másolása
COPY . .

# Build futtatása
RUN npm run build

# 2. stage: PHP-FPM richarvey image
FROM richarvey/nginx-php-fpm:latest

USER root

WORKDIR /var/www/html

# Projekt fájlok másolása, kivéve a node_modules-t és a build fájlokat, amiket a node-builder stage-ből hozunk be
COPY . .

# Kész build assetek átmásolása a node-builder stage-ből
COPY --from=node-builder /app/public/build ./public/build

# Laravel composer, cache és migrációk
RUN composer install --no-dev --optimize-autoloader && \
    php artisan key:generate && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan migrate --force && \
    php artisan migrate --seed

# Jogosultságok beállítása
RUN chown -R nginx:nginx /var/www/html/storage /var/www/html/bootstrap/cache

CMD ["/start.sh"]
