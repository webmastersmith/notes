# Docker Node Mongodb

# Build Your Own Container

```Dockerfile
FROM alpine
RUN apk add --update nodejs npm
# RUN node -v
# RUN npm -v
# if this folder does not exist, will be created automatically.
WORKDIR /app
ENV NODE_ENV=production
COPY . .
RUN npm i
# CMD ["node", "index.js"]
CMD ["npm", "run", "dev"]RUN node -v
```

# Cache Busting & Rebuilding

- add your frequently changed files after your package installed files.
- because everything down stream will have to be re-run of change.

```dockerfile
COPY ./package.json .
RUN npm i
# now when you change something, npm will not have to be run again.
COPY . .
# CMD ["node", "index.js"]
CMD ["npm", "run", "dev"]RUN node -v

```

# Docker Hub Containers

**cmd**

```sh
# create network
docker network create mongo-network

# build
docker build -t node-server . < Dockerfile
```

**Dockerfile**

```dockerfile
FROM node:13-alpine

ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PWD=password

RUN mkdir -p /home/app

COPY ./app /home/app

# set default dir so that next commands executes in /home/app dir
WORKDIR /home/app

# will execute npm install in /home/app because of WORKDIR
RUN npm install

# no need for /home/app/server.js because of WORKDIR
CMD ["node", "server.js"]

```

**Node, MongoDB, MongoDB Gui Setup**

```sh
# mongo
docker run -d --rm --network mongo-network --name mongodb \
-p 27017:27017 \
-e MONGO_INITDB_ROOT_USERNAME=admin \
-e MONGO_INITDB_ROOT_PASSWORD=password \
-v db:/etc/mongo \
mongo

# mongo-express
docker run -it -d --rm \
--network mongo-network \
--name mongo-express \
-p 8080:8081 \
-e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
-e ME_CONFIG_MONGODB_ADMINPASSWORD=password \
-e ME_CONFIG_MONGODB_SERVER=mongodb \
mongo-express

# node -do this last
docker run -d -p 3000:3000 --rm \
--network mongo-network \
--name node \
node-server
```

### docker-compose.yaml

```yaml
version: '3.8'
services:
  node:
    image: node-server
    ports:
      - 3000:3000
  mongodb: # maps to --name
    image: mongo # maps to --image
    ports: # maps to -p
      - 27017:27017
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password
    volumes:
      - mongo-data:/data/db
  mongo-express:
    image: mongo-express
    restart: always # fixes MongoNetworkError when mongodb is not ready when mongo-express starts
    ports:
      - 8080:8081
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
      - ME_CONFIG_MONGODB_ADMINPASSWORD=password
      - ME_CONFIG_MONGODB_SERVER=mongodb
volumes:
  mongo-data:
    driver: local
# networks:
#   default:
#     name: mongo-network
#     external: true
```

### node

```dockerfile
# build environment
FROM node:18-alpine3.15 as builder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
RUN npm install --silent
COPY . /usr/src/app/
RUN npm run build

# production environment
FROM nginx:1.23.1-alpine
COPY --from=builder /usr/src/app/build /usr/share/nginx/html/
EXPOSE 80
```
