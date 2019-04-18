# TikiWiki Docker Image

TikiWiki is full featured content management system written in PHP. You can
find more useful information at http://tiki.org

## Pulling

```
docker pull montefuscolo/tikiwiki:19x
```

## Running

### Variables

Some env variables are provided to setup the database, but you can also mount
your configurations files inside container. The env vars and the default values
are listed below and the names are self explanatory.

```
TIKI_DB_VERSION=19
TIKI_DB_HOST='db'
TIKI_DB_USER
TIKI_DB_PASS
TIKI_DB_NAME=tikiwiki
```

### Single container

Example to get a running container below.

```
docker run --rm --name tiki --link mariadb:db \
    -e TIKI_DB_USER=tiki \
    -e TIKI_DB_PASS=wiki \
    -p 80:80 \
    -d montefuscolo/tikiwiki
```

### docker-compose

The following creates and start two containers:

1. TikiWiki with por 80 published on host
2. MariaDB instance with the schema `tikiwiki`

```yml
version: '2'
services:
  tiki:
    image: montefuscolo/tikiwiki:19x
    ports:
    - "80:80"
    depends_on:
      - db
    environment:
      - TIKI_DB_USER=tiki
      - TIKI_DB_PASS=wiki
      - TIKI_DB_NAME=tikiwiki
  db:
    image: mariadb
    environment:
      - MYSQL_USER=tiki
      - MYSQL_PASSWORD=wiki
      - MYSQL_DATABASE=tikiwiki
      - MYSQL_ROOT_PASSWORD=tkwkiiii
      - TERM=dumb
```

### scalable mode with docker-compose

The following recipe makes possible to grow the amount of TikiWiki
containers, so in this way, it is possible to use more resources from
host to handle incoming traffic.

Concerning about this mode:

1. It it not compatible to web installer, so installing database using
command line is needed.
2. It is needed to have a reverse proxy load balancing traffic to TikiWiki
containers.

#### docker-compose.yml

This setup uses `eeacms/haproxy` container as reverse proxy and load balancer and
declare a set of volumes. When new **tiki** containers are created, they will share
the same set of volumes.

```yml
version: '3.7'

services:
  haproxy:
    image: eeacms/haproxy
    depends_on:
    - tiki
    ports:
    - "80:5000"
    environment:
      BACKENDS: "tiki"
      DNS_ENABLED: "true"
      LOG_LEVEL: "info"
  tiki:
    image: montefuscolo/tikiwiki:19x
    depends_on:
      - db
    deploy:
      replicas: 2
    environment:
      - TIKI_DB_USER=tiki
      - TIKI_DB_PASS=wiki
      - TIKI_DB_NAME=tikiwiki
    volumes:
      - tiki_files:/var/www/html/files/
      - tiki_img_trackers:/var/www/html/img/trackers/
      - tiki_img_wiki_up:/var/www/html/img/wiki_up/
      - tiki_img_wiki:/var/www/html/img/wiki/
      - tiki_modules_cache:/var/www/html/modules/cache/
      - tiki_storage:/var/www/html/storage/
      - tiki_temp:/var/www/html/temp/
      - tiki_sessions:/var/www/sessions/
  db:
    image: mariadb
    environment:
      - MYSQL_USER=tiki
      - MYSQL_PASSWORD=wiki
      - MYSQL_DATABASE=tikiwiki
      - MYSQL_ROOT_PASSWORD=tkwkiiii
      - TERM=dumb
volumes:
  tiki_files:
  tiki_img_trackers:
  tiki_img_wiki_up:
  tiki_img_wiki:
  tiki_modules_cache:
  tiki_storage:
  tiki_temp:
  tiki_sessions:
```

#### Starting containers

First it is needed to copy the YML above in a folder with
a descriptive name, like `example.com`.

Then, inside the folder `example.com`, the following command
starts all container from docker-compose.yml.

```sh
docker-compose up -d
```

After wait all containers to start and the console prompt appears
again, the following command shows the containers running for
docker-compose.yml on folder `example.com`.

```
docker-compose ps
```

The output should be like:

```
        Name                      Command               State          Ports        
------------------------------------------------------------------------------------
examplecom_db_1        docker-entrypoint.sh mysqld      Up      3306/tcp            
examplecom_haproxy_1   /docker-entrypoint.sh hapr ...   Up      0.0.0.0:80->5000/tcp
examplecom_tiki_1      /entrypoint.sh apache2-for ...   Up      443/tcp, 80/tcp     
```

There is 1 container running for each service (**db**, **haproxy**, **tiki**)
in **example.com** folder.


#### Installing database

There is a command line installer available in tiki folder that should be used
to install the database. **WE CAN NOT USE THE WEB INSTALLER!**. The following
command installs Tiki database

```sh
docker-compose exec tiki php console.php database:install
```

#### Scaling containers

If more Tiki container is wanted, the following command launch new containers.

```sh
docker-compose scale tiki=3
```

Now, the following containers will be listed on `docker-compose ps`:

```sh
        Name                      Command               State          Ports        
------------------------------------------------------------------------------------
examplecom_db_1        docker-entrypoint.sh mysqld      Up      3306/tcp            
examplecom_haproxy_1   /docker-entrypoint.sh hapr ...   Up      0.0.0.0:80->5000/tcp
examplecom_tiki_1      /entrypoint.sh apache2-for ...   Up      443/tcp, 80/tcp     
examplecom_tiki_2      /entrypoint.sh apache2-for ...   Up      443/tcp, 80/tcp     
examplecom_tiki_3      /entrypoint.sh apache2-for ...   Up      443/tcp, 80/tcp     
```
