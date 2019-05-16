# docker-pterodactyl-panel

Easily set up pterodactyl on Docker, adhering to the *one service per container* mantra.

(Well, mostly. Cron and php-fpm run on the same container, but cron doesn't count, right?)

## Getting started (locally)

1. Edit `docker-compose.yml` to choose a secure username and password for your database. You'll need to use the same credentials for both mariadb's MYSQL_USER/MYSQL_PASSWORD and PHP-FPM's DB_USERNAME/DB_PASSWORD environment variables.
2. Run `docker-compose -d`.
3. Find the name of the php container using `docker ps`. It should be something like `docker-pterodactyl-panel_php-fpm_1`.
4. Run `docker exec -it docker-pterodactyl-panel_php-fpm_1 php artisan p:user:make` and follow the prompts to set up your first user.

## Using your own MySQL/MariaDB server

By default this stack includes its own MariaDB server, but with a few modifications you can have it use an existing database server instead. You will need to make several modifications to docker-compose.yml.

1. Edit docker-compose.yml to remove the database server block.
2. Edit docker-compose.yml to remove database from the depends_on section of the php server block.
3. Edit docker-compose.yml to modify php-fpm's DB_HOST and DB_PORT environment variables.

## Roadmap

 - Add compatiblility with `docker stack` by using prebuilt images