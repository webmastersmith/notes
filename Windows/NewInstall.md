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
    - Set ALLOW to all settings.
    - if you only want password pin, change it to Require startup pin with tpm.
    - All others change to do not allow.
  - control panel / system and security / bitlocker drive encryption
- **rename drives**
  - create and format hard disk / drive: F (main), G
- **power & sleep**
  - settings / system / Power & sleep / screen: 15 minutes, sleep 3 hours

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
