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

```sh
sudo docker compose -f /home/webmaster/mongo.yaml up -d

# cmd line
mongosh "mongodb://localhost:27017" -u 'root' -p 'password'
# through node
mongodb://root:password@127.0.0.1:27017 # no spaces in name
# docker
docker exec -it mongo1 bash
```

```yaml
# version not needed
services:
  mongo:
    image: mongo
    container_name: mongo1
    restart: always
    ports: # maps to -p
      - 27017:27017
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: password
    volumes:
      - /home/webmaster/mongodb/db:/data/db
# networks:
#   default:
#     name: mongo-network
#     external: true
```
