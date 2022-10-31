# Docker MySQL

- [Docker Image](https://hub.docker.com/_/mysql)
- [MySQL Docker Instructions](https://dev.mysql.com/doc/refman/8.0/en/docker-mysql-getting-started.html)

```sh
# community edition
docker run \
  --name mysql1 \
  --rm \
  -v /home/webmaster/mysql/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD='password' \
  -e MYSQL_DATABASE='Avocados' \
  -dp 3306:3306 \
  mysql
  # latest is default
  # 'MYSQL_DATABASE' only works if volume is empty on startup.

docker ps # will show STATUS healthy, when ready. NOT STATUS health: starting.

# stream logs
docker logs mysql1 -f  # stream logs

# if password was not declared and you declared MYSQL_RANDOM_ROOT_PASSWORD=yes -user root
docker logs mysql1 2>&1 | grep GENERATED

# connect to mysql in container
docker exec -it mysql1 mysql -uroot -p
# connect to shell in container
docker exec -it mysql1 bash

# login
mysql -u root -p'password' -h '127.0.0.1' -P '3306'
# Backup
mysqldump -u root -p'password' -h '127.0.0.1' -P '3306' database_name > ./db_backup.sql
# Restore Database -Create database first
mysql -u root -p'password' -h '127.0.0.1' -P '3306' database_name < ./db_backup.sql
```

### Debian -MySQL Shell

- `sudo apt-get install default-mysql-client` // client allow you to connect to server

### Error

- sql_mode=only_full_group_by // turn off.
- mysql > `SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));`
