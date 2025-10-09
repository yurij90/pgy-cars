FROM richarvey/nginx-php-fpm:latest

USER root

RUN apk update && apk add --no-cache curl nodejs npm \
    && npm install -g npm@latest

WORKDIR /var/www/html

COPY . .

ENV APP_ENV=production
ENV APP_DEBUG=false
ENV LOG_CHANNEL=stderr
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PHP_ERRORS_STDERR=1
ENV SKIP_COMPOSER=1
ENV WEBROOT=/var/www/html/public

RUN composer install --no-dev --optimize-autoloader && \
    npm install && \
    npm run build && \
    php artisan key:generate \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan migrate --force \
    php artisan migrate --seed

RUN chown -R nginx:nginx /var/www/html/storage /var/www/html/bootstrap/cache

CMD ["/start.sh"]
