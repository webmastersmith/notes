# Docker MongoDB

**Dockerfile**

```sh
docker run \
  --name mongo1 \
  --rm \
  -v /home/webmaster/mongodb/db:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME='root' \
  -e MONGO_INITDB_ROOT_PASSWORD='password' \
  -dp 27017:27017 \
  mongo
```

**mongodb.yaml**

```sh
# mongo shell cmd line
mongosh "mongodb://localhost:27017" -u 'root' -p 'password'
# through node
mongodb://root:password@127.0.0.1:27017 # no spaces in name
# docker container
docker exec -it CONTAINER_NAME bash
```

## docker compose

- `docker compose -f ./mongo.yaml up -d`
- `docker compose -f ./mongo.yaml down`

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
      - /home/web/Documents/docker/mongodb/db:/data/db
# networks:
#   default:
#     name: mongo-network
#     external: true
```
