# docker-pterodactyl-panel

Easily set up pterodactyl on Docker, adhering to the *one service per container* mantra.

(Well, mostly. Cron and php-fpm run on the same container, but cron doesn't count, right?)

## Getting started

1. Copy `.env.example` to `.env`.
2. Edit `.env` to specify DB_USERNAME, DB_PASSWORD, and any mail settings. (You can specify anything for the database credentials, the user will automatically be created within the MariaDB container)
3. Run `docker-compose -d`.
4. Find the name of the php container using `docker ps`. It should be something like `docker-pterodactyl-panel_php_1`.
5. Run `docker exec -it docker-pterodactyl-panel_php_1 php artisan p:user:make` and follow the prompts to set up your first user.

## Using your own MySQL/MariaDB server

By default this stack includes its own MariaDB server, but with a few modifications you can have it use an existing database server instead.

1. Edit docker-compose.yml to remove the database server block.
2. Edit docker-compose.yml to remove database from the depends_on section of the php server block.
3. Edit .env to point to your database.

## Volumes

This stack creates two named volumes and one host volume.

The `.env` file in this directory will be mounted in the php container. Despite the volume being mounted with `default` consistency, I've noticed if I make changes on the host I need to restart the container before they take effect.

A `db` volume will be created to store the MariaDB database. A `storage` container will be created to store Pterodactyl data.

## Roadmap

 - Add compatiblility with `docker stack` by using prebuilt images