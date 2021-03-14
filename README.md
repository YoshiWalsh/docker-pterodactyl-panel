# docker-pterodactyl-panel

Easily set up pterodactyl on Docker, adhering to the *one service per container* mantra.

(Well, mostly. Cron and php-fpm run on the same container, but cron doesn't count, right?)

I think it should be compatible with Docker Swarm, but I'm not able to test this myself yet.

## Getting started

1. Copy `docker-compose.yml` and `.env` to somewhere on your computer. 
Make sure both files are in the same directory
2. Edit `.env` to choose a secure username and password for your database.
3. Run `docker-compose -d`.
4. Find the name of the php container using `docker ps`. It should be something like `pterodactyl_php-fpm_1`.
5. Run `docker exec -it pterodactyl_php-fpm_1 php artisan p:user:make` and follow the prompts to set up your first user.
6. Open the Pterodactyl panel by accessing the URL http://app.pterodactyl.srv in your browser and login in with the username and password created in the previous step
7. Optional: to access the database use `db.pterodactyl.srv` for the host, `3306` for the port and `panel` for the database/schema name. 

## Using your own MySQL/MariaDB server

By default this stack includes its own MariaDB server, but with a few modifications you can have it use an existing database server instead. You will need to make several modifications to docker-compose.yml.

1. Edit docker-compose.yml to remove the database server block.
2. Edit docker-compose.yml to remove database from the depends_on section of the php server block.
3. Edit docker-compose.yml to modify php-fpm's DB_HOST and DB_PORT environment variables.
