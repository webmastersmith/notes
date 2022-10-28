# Docker nginx

- <https://startbootstrap.com/themes/landing-pages>

**AWS**

- <https://www.cyberciti.biz/faq/how-to-install-docker-on-amazon-linux-2/>

```sh
# nginx - <https://www.nginx.com/blog/setting-up-nginx/>
sudo amazon-linux-extras list | grep nginx

# nginx1=latest disabled \[ =stable \]
sudo amazon-linux-extras enable nginx1
# nginx1=latest enabled \[ =stable \]
# Now you can install:
sudo yum clean metadata
sudo yum -y install nginx
nginx -v
nginx version # nginx/1.16.1
# status
sudo systemctl status nginx.service
# start
sudo systemctl start nginx.service
#stop
sudo systemctl stop nginx.service
```
