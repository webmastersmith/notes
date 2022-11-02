# WSL Windows

### find ip of WSL

- `ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'` // returns ip. `ip a` same as `ip addr`
- `ifconfig -a` //ifconfig eth0
- `hostname -I | awk '{print $1}'` // returns ip
- `ip route get 1.2.` ?
