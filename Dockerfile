FROM laravelsail/php82-composer

WORKDIR /var/www/html

COPY . .

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
