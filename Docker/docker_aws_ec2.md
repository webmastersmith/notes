# aws ec2

- https://gist.github.com/npearce/6f3c7826c7499587f00957fee62f8ee9

**install aws ec2**

- <https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-container-image.html>

```sh
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
```

**verify**

- `docker info`

**make docker service run on startup**

```sh
sudo chkconfig docker on
sudo yum install -y git
# Reboot to verify it all loads fine on its own.
sudo reboot
```

# docker-compose

- <https://gist.github.com/npearce/6f3c7826c7499587f00957fee62f8ee9#docker-compose-install>

```sh
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

# Fix permissions after download:
sudo chmod +x /usr/local/bin/docker-compose

# Verify success:
docker-compose version
```
