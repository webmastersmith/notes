# New Install

## Backkup

- ubuntu docs, firefox, thunderbird, downloads, documents

## Install

- [decrapifier](https://community.spiceworks.com/scripts/show/4378-windows-10-decrapifier-18xx-19xx-2xxx)
- [how to](https://community.spiceworks.com/how_to/148624-how-to-clean-up-a-single-windows-10-machine-image-using-decrapifier)
- `shift + ctrl + F3`
  - `amin powershell`
  - `set-executionpolicy unrestricted`
- `.\decrap.ps1 -OneDrive`
  - `set-executionpolicy restricted`

## Install Programs

- get all windows updates
- **Bitlocker**
  - Edit group Policy / Computer Configuration > Administrative Templates > Windows Components > BitLocker Drive Encryption
  - Operating System Drives in the Group Policy window.
    - "Require additional authentication at startup"
    - Check Enable
    - **password pin**: change it to Allow startup pin with tpm.
    - All others change to do not allow.
  - control panel / system and security / bitlocker drive encryption // setup auto unlock.
- **rename drives**
  - create and format hard disk / drive: F (main), G
- **power & sleep**
  - settings / system / Power & sleep / `screen: 15 minutes, sleep 3 hours`
- **git**
  - installed git on windows as well.
  - wsl
    - if user is root. to use another user by default: `ubuntu config --default-user USERNAME` // in a cmd.exe terminal.
    - when you git push, it will auto sign in.
  - `git config --global user.email "MY_NAME@example.com"`
  - `git config --global user.name "FIRST_NAME LAST_NAME"`
    **.gitconfig**
- **file explorer**
  - remove today yesterday // `file explorer / view / group by / none`

```sh
[user]
        email = EMAIL@gmail.com
        name = BOB JONES
```

**Programs**
7zip
docker-desktop
audacity
bluebeam
keepass
autohotkey
chromium
chrome
firefox
ffmpeg
thunderbird
gimp
gnucash
inkscape
mega
node

- <https://github.com/nodesource/distributions/blob/master/README.md>
  obs
  openoffice
  veracrypt
  vlc
  vscode
  zoom
