# 1. stage: Node.js build hivatalos node:20.17-alpine image használatával
FROM node:20.19-alpine as node-builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# 2. stage: PHP-FPM és Nginx richarvey image
FROM richarvey/nginx-php-fpm:latest

USER root

WORKDIR /var/www/html

# Projekt fájlok másolása
COPY . .

# A kész assetek átmásolása a node build stage-ből
COPY --from=node-builder /app/public/build ./public/build

# Laravel futtatáshoz szükséges parancsok
RUN composer install --no-dev --optimize-autoloader && \
    php artisan key:generate && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan migrate --force && \
    php artisan migrate --seed

# Jogok beállítása
RUN chown -R nginx:nginx /var/www/html/storage /var/www/html/bootstrap/cache

CMD ["/start.sh"]
