FROM node:20.19-alpine as node-builder

WORKDIR /app

COPY composer.json composer.lock ./
RUN apk add --no-cache php-cli php-phar php-openssl php-mbstring php-xml php-tokenizer php-curl curl unzip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer install --no-dev --no-interaction --prefer-dist

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

FROM richarvey/nginx-php-fpm:latest

USER root

WORKDIR /var/www/html

COPY --from=node-builder /app ./

RUN composer install --no-dev --optimize-autoloader && \
    php artisan key:generate && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan migrate --force && \
    php artisan migrate --seed

RUN chown -R nginx:nginx /var/www/html/storage /var/www/html/bootstrap/cache

CMD ["/start.sh"]
