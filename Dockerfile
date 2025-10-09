FROM node:20.19-alpine as node-builder

WORKDIR /app

RUN apk add --no-cache php81 php81-phar php81-openssl php81-mbstring php81-xml php81-tokenizer php81-curl php81-fileinfo php81-iconv php81-session php81-dom php81-zip curl unzip

COPY composer.json composer.lock ./

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --no-dev --no-interaction --prefer-dist

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build
