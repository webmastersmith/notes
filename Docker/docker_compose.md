# Docker Compose

### About

- <https://docs.docker.com/compose/>
- Docker Compose is a tool that was developed to help define and share multi-container applications. With Compose, we can create a YAML file to define the services and with a single command, can spin everything up or tear it all down.
- orchestrate multiple instances of docker containers. Tool for running multi-container applications
- written in yaml.
- [https://docs.docker.com/compose/compose-file/](https://docs.docker.com/compose/compose-file/)
- [geek stuff](https://www.thegeekstuff.com/2016/04/docker-compose-up-stop-rm/)

**cmd**

- [https://docs.docker.com/compose/reference/](https://docs.docker.com/compose/reference/)
- <https://www.thegeekstuff.com/2016/04/docker-compose-up-stop-rm/>
- <https://docs.docker.com/engine/reference/commandline/compose_down/#related-commands>

### Compose V2

- `docker compose` // leave out the dash to use version 2 of compose.

**start**

- `docker compose up -d` // -d must be on end. -d options runs the docker application in the background as a daemon.
- `sudo docker compose -f ./mongo.yaml up -d`
  - `up | stop`
  - `docker compose -f /path/to/file`

**flags**

- `-f` someComposeFile // path to compose file
- `-p` assign name to container.

**Attach**

- `docker exec -it <container id> bash`

**Command**

- command:

```sh
# command:
bash -c "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"
```

**logs**

- `docker-compose logs imageName`

**docker-compose.yaml** // in it's own folder.

```yaml
services:
  lmm-website:
    build: .  //or
#    build:
#      context: .
#      dockerfile: Dockerfile
    container_name: ${CONTAINER_NAME:-lmm-website}
    environment:
      HOME: /home/user
    command: supervisord -n
      volumes:
        - ..:/builds/lmm/website
        - db_website:/var/lib/mysql
    ports:
      - "8765:80"  //should be string
      - "12121:443"
      - "3309:3306"
    networks:
      - ntw

volumes:
  db_website:

networks:
  static-network:
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

**mongo example**

- `sudo docker compose -f ./mongo.yaml up -d`
  - `-f` is file. // removes container when down.

**mongo-docker-compose.yaml**

- `sudo docker compose -f ./mongo.yaml up -d`

```yaml
version: '3' #tag always here
services: #the containers you want to create. Tag always here
  mongodb: #maps to --name in cmd line
    image: mongo #what docker image will build from
    ports: #map to -p.
      - 27017:27017 #host:docker container
    environment: #maps to -e
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSORD=password
  mongo-express:
    image: mongo-express
    ports:
      - 8080:8080
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
      - ME_CONFIG_MONGODB_ADMINPASSWORD=password
      - ME_CONFIG_MONGODB_SERVER=mongodb
```
