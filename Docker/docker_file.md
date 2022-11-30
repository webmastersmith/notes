# Dockerfile

## Build

- Dockerfile build runs as root // can specify: USER root
- <https://docs.docker.com/engine/reference/builder/>
- **Build/Rebuild Image**

  - name/digest
    - mongo**@sha256**:5255f45e7f87b4404388205351ef69e5f6c018976b355729afa01014faf7792a

```sh
# if Dockerfile is in same folder
docker build . # Dockerfile should be in current directory.
docker build -t userName/repoName:tag . # if you leave tag off will default to 'latest'
docker build -t userName/repoName:tag -f ./docker/Dockerfile.build . # don't forget the '.'
docker build -t userName/repoName:tag . < Dockerfile
docker build --target builder -t alex/ho:v1 .
# curl
curl example.com/remote/Dockerfile | docker build -f - .
```

1. build it: `docker build ./debian_bookworm` // -t NAME for custom image name.
2. run it detached: `docker run -dp 22:22 --name ansible -it bookworm`
   1. runs in background
3. attach to it.
   1. <https://docs.docker.com/engine/reference/builder/#format>
   2. The instruction 'FROM' is not case-sensitive. convention is for them to be UPPERCASE
   3. Docker runs instructions in a Dockerfile in order. A Dockerfile must begin with a FROM instruction.

**external image as a stage**

```dockerfile
COPY --from=nginx:latest /etc/nginx/nginx.conf /nginx.conf
```

**ssh to Dockerfile** // do not use '~/path'

```dockerfile
FROM ubuntu:latest

RUN apt-get update; \
    apt-get install openssh-server passwd net-tools -y; \
    mkdir -p /root/.ssh
WORKDIR /root/.ssh
COPY ./.ssh/id_rsa.pub ./authorized_keys
RUN chmod 600 ./authorized_keys

ENTRYPOINT service ssh restart && bash
```

# Commit

- create an image from a running container.
- not used that often.
  - `docker commit -c 'CMD ["redis-server"]' RUNNING_CONTAINER_ID`

# INSTRUCTIONS

- **ADD**
  - be it a folder or just a file actually part of your image. Anyone who uses the image you've built afterwards will have access to whatever you ADD. you only ADD something at build time and cannot ever ADD at run-time.
- **ARG**
  - ARG my-value=3 //\$my-value
- **CMD** `["node", "/home/app/server.js"]` //
  - same as `ENTRYPOINT`. Dockerfile can only have one Entrypoint. Entrypoint cannot be overridden.
  - can have multiple `CMD` statements. Can be overridden.
  - must be "double quotes"
- comment: `#`
  - only at the beginning of the line.
  - A `#` marker anywhere else in a line is treated as an argument.
  - Comment lines are removed before the Dockerfile instructions are executed

```dockerfile
# do some stuff
RUN apt-get update \
    # install some packages
    && apt-get install -y cron
```

- **COPY** . /home/app // copy executes on host (your computer) at build time.
  - copy local file to host.
  - `.dockerignore` // create .dockerignore in root directory with Dockerfile.
    - docker will not `COPY` files/folders listed in the .dockerignore file.

```dockerfile
# All files that don't start with 'n'
COPY [^n]*
# All files that start with 'n', but not 'no'
COPY n[^o]*
# All files that start with 'no', but not 'nod'
COPY no[^d]*
```

- **ENV** // add env variables. These will be added to .bashrc of image.

  - `ENV MONGO_DB_USERNAME=admin`
  - `ENV MONGO_DB_PWD=password`

- **ENTRYPOINT**

  - <https://docs.docker.com/engine/reference/builder/#entrypoint>
  - Default parameters that cannot be overridden when Docker Containers run with CLI parameters.

- **EXPOSE**

  - `EXPOSE 80/tcp 80/udp`
  - <https://docs.docker.com/engine/reference/builder/#expose>
  - this command does not open ports, but notifies developer what port docker container listens on.
  - `-p` flag overrides `EXPOSE`

- **FROM** node AS customName // image to pull from docker hub.

  - <https://docs.docker.com/engine/reference/builder/#from>
  -

- **Ignore**
  - `.dockerfile`
  - <https://docs.docker.com/engine/reference/builder/#dockerignore-file>
  - ignore files when `COPY` directory.

```dockerfile
# comment
# ignore any folder/file starts with temp.* one level below root.
*/temp*
# ignore any folder/file two levels below root.
*/*/temp*
# exclude folder/file named tempa, temb...
temp?
```

- **Label**
  - `LABEL org.opencontainers.image.source`
  - <https://github.com/darinpope/jenkins-example-ghcr>
  - show containers that are pushed to docker hub.
- **RUN** `mkdir -p /home/app` // run any linux command on image.
  - these command run at build time.
  - <https://docs.docker.com/engine/reference/builder/#run>

```dockerfile
# Called 'execform'. prevents shell munging. Must use double quotes.
RUN ["executable", "param1", "param2"]

# change shell, multiple lines
RUN /bin/bash -c 'source $HOME/.bashrc; \
                  echo $HOME'
# same as
RUN /bin/bash -c 'source $HOME/.bashrc; echo $HOME'
# same as
RUN ["/bin/bash", "-c", "echo $HOME"]

# multiline
RUN apt-get update && apt-get install curl sudo git -y
RUN curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null; \
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null; \
    apt-get update; \
    apt-get install jenkins -y

RUN wget -O myfile.tar.gz http://example.com/myfile.tar.gz \
    && tar -xvf myfile.tar.gz -C /usr/src/myapp \
    && rm myfile.tar.gz
```

- **USER** patrick // will switch to user 'patrick', so use after 'root' RUN cmd.
- **VARIABLES**
  - `ARG myvalue=3`
    - `$myvalue`
- **VOLUME**
  - <https://docs.docker.com/engine/reference/builder/#volume>
  - You cannot use files from your VOLUME directory in your Dockerfile. Anything in your volume directory will not be accessible at build-time but will be accessible at run-time.
  - remove
    - `docker volume remove jenkins_data`
- **WORKDIR**
  - move to where you show: `WORKDIR /home/jenkins`
  - all 'RUN' commands after this will take place in this `WORKDIR`
  - creates folder if not exist.
  - `CMD ["someCmd"]` will run in the last `WORKDIR` destination.

### Dockerfile Examples

```dockerfile
FROM node:alpine
COPY . /app
WORKDIR /app
# on docker image boot, run app.js with node
CMD node app.js
```

**Multi-stage builds**

- <https://docs.docker.com/develop/develop-images/multistage-build/>

```dockerfile
# syntax=docker/dockerfile:1
FROM golang:1.16 AS builder
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html
COPY app.go    ./
LABEL builder=true
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/alexellis/href-counter/app ./  #can also --from=0
CMD ["./app"]

# where previous stage left off
# syntax=docker/dockerfile:1
FROM alpine:latest AS builder
RUN apk --no-cache add build-base

FROM builder AS build1
COPY source1.cpp source.cpp
RUN g++ -o /binary source.cpp

FROM builder AS build2
COPY source2.cpp source.cpp
RUN g++ -o /binary source.cpp
```
