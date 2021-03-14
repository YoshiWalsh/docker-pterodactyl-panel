#!/bin/sh

main(){
/root/wait-for database:3306 -t 30 &&
    yes no | php artisan key:generate &&
    php artisan migrate --force &&
    php artisan db:seed --force &&
    crond &&
    php-fpm
}

main