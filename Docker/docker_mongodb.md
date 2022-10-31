# Docker MongoDB

```sh
docker run \
  --name mongo1 \
  --rm \
  -v /home/webmaster/mongodb/db:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME='root' \
  -e MONGO_INITDB_ROOT_PASSWORD='password' \
  -dp 27017:27017 \
  mongo


# access the docker container
docker exec -it CONTAINER_NAME bash

```

**mongodb.yaml**

- docker-compose up -f /home/webmaster/mongodb/mongodb.yaml

```yaml
version: '3.1'

services:
  mongo:
    image: mongo
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: password
```
