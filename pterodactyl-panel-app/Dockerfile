FROM alpine AS git
ARG pterodactyl_panel_git_branch=master
RUN apk add --no-cache git
RUN git clone -b $pterodactyl_panel_git_branch --depth 1 https://github.com/pterodactyl/panel.git /git

FROM php:7.2-fpm AS base_php
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        unzip \
        git \
        cron \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
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
COPY --from=git /git/ .
RUN composer install --ignore-platform-reqs --no-scripts --no-dev --optimize-autoloader
RUN chmod -R 755 storage/* bootstrap/cache/
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /root/wait-for-it.sh
RUN chmod +x /root/wait-for-it.sh

FROM base_php AS app
WORKDIR /var/www/html/
COPY --from=install_dependencies --chown=www-data:www-data /var/www/html/ .
COPY --from=install_dependencies /root/wait-for-it.sh /root/wait-for-it.sh
COPY --from=install_dependencies --chown=www-data:www-data /var/www/html/storage /root/initial_storage
COPY cronfile /root/cronfile
RUN crontab /root/cronfile
EXPOSE 80
ENTRYPOINT cp -r /root/initial_storage/* ./storage/ && /root/wait-for-it.sh database:3306 -t 30 && yes no | php artisan key:generate && php artisan migrate --force && php artisan db:seed --force && php-fpm

FROM nginx:mainline AS nginx
