# Docker wsl 2

**Follow walk through**

- <https://docs.docker.com/engine/install/ubuntu/>
- Then change nf-iptables to legacy ip-tables update-alternatives --set iptables /usr/sbin/iptables-legacy
- and
- update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

```sh
# docker start on login  https://docs.docker.com/engine/install/linux-postinstall/
sudo groupadd docker
sudo usermod -aG docker $USER
sudo touch /etc/fstab
sudo docker run --rm hello-world
nano ~/.profile
sudo service docker status | sudo service docker start

# don't think you need to do this.
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```
