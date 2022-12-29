# Deb

```sh
sudo dpkg -i ./file.deb
# or to install in a specific directory
dpkg-deb -x $DEBFILE $TARGET_DIRECTORY

# Example
dpkg-deb -x ./file.deb /home/yung/test
```

Install binary .deb files

- `curl -Lo tempFileName https://url` // L=redirect, o=output
- `sudo apt install ./file.deb`
