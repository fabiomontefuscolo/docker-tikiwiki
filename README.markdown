TikiWiki
========

TikiWiki is full featured content management system written in php. You can
find more useful information at http://tiki.org


Pulling
-------

Actually, no tags are being used to this container. The tiki version available
inside container is the LTS 12.9. You can pull like below.

```
docker pull montefuscolo/tiki-wiki
```


Running
-------

Some env varibles are provided to setup the database, but you can also mount
your configurations files inside conainer. The env vars and the default values
are listed below and the names are self explanatory.

```
TIKI_DB_DRIVER=mysql
TIKI_DB_VERSION=12.9
TIKI_DB_HOST='db'
TIKI_DB_USER
TIKI_DB_PASS
TIKI_DB_NAME=tikiwiki
```

Example to get a running container below.

```
docker run --rm --name tiki --link mariadb:db \
    -e TIKI_DB_USER=tiki \
    -e TIKI_DB_PASS=wiki \
    -p 80:80 \
    -d montefuscolo/tiki-wiki
```

