FROM alpine AS download
ARG pterodactyl_panel_version=v1.11.5
RUN apk add --no-cache \
        curl \
        tar
RUN mkdir -p pterodactyl
RUN curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/download/${pterodactyl_panel_version}/panel.tar.gz
RUN tar -xzvf panel.tar.gz -C /pterodactyl

FROM php:8.2-fpm-alpine AS base_php
RUN apk add --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        unzip \
        libzip-dev \
        git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) zip
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY php-extra.ini $PHP_INI_DIR/conf.d/extra.ini
COPY php-fpm-extra.conf /usr/local/etc/php-fpm.d/extra.conf

FROM base_php AS install_dependencies
WORKDIR /var/www/html/
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=download /pterodactyl/ .
RUN composer install --no-dev --optimize-autoloader
RUN chmod -R 755 storage/* bootstrap/cache/
ADD https://raw.githubusercontent.com/eficode/wait-for/master/wait-for /root/wait-for
RUN chmod +x /root/wait-for

FROM base_php AS app
WORKDIR /var/www/html/
COPY --from=install_dependencies --chown=www-data:www-data /var/www/html/ .
COPY --from=install_dependencies --chown=www-data:www-data /var/www/html/.env.example .env
COPY --from=install_dependencies /root/wait-for /root/wait-for
COPY cronfile /root/cronfile
RUN crontab /root/cronfile
EXPOSE 80
ENTRYPOINT ["/bin/sh", "-c", "/root/wait-for database:3306 -t 30 && yes no | php artisan key:generate && php artisan migrate --force && php artisan db:seed --force && crond && php-fpm"]
