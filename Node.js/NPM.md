# NPM

- NPM -Node Project Manager
- [NPM Repository](https://www.npmjs.com/)
- Location on Computer: C:\Users\WebMaster\AppData\Roaming\npm

**Tutorial**

- [https://css-tricks.com/a-complete-beginners-guide-to-npm/](https://css-tricks.com/a-complete-beginners-guide-to-npm/)

**To Run NPM**

- `npm run script-name`
- `npm start` // start is special and does not need the 'run' keyword

## Create Package.json file

- `npm init -y` // create package.json, package.lock.json, `node_modules` folder

**Restore from package.json file**

- `npm install | npm i`

## NPM Flags

- -v = version
- -g = global
- -l = full help
- -S = --save-prod
- -D = --save-dev
- -O = --save-optional
- --no-save
- i = install
- r = uninstall

**NPM packages naming rules**

- The name must be less than or equal to 214 characters. This includes the scope for scoped packages.
- The name can’t start with a dot or an underscore.
- New packages must not have uppercase letters in the name.
- The name ends up being part of a URL, an argument on the command line, and a folder name. Therefore, the name can’t contain any non-URL-safe characters.
- [URL safe characters](https://perishablepress.com/stop-using-unsafe-characters-in-urls/)
  - a-z, A-Z, 0-9, $ - \_ . + ! \* ' ( ) ,
- URL reserved characters
  - ; / ? : @ = &
- URL Unsafe characters
  - < > # % { } | | ^ ~ [ ] `

## Version

**Version Meaning**

- 1.18.11
  - 1 is breaking changes
  - 18 is new features, no breaking changes
  - 11 is bug fixes.
  - \*1.18.11 // npm update will do breaking changes
  - ^1.18.11 // npm update new features only
  - ~1.18.11 // npm update bug fixes only

**[Install by Version](https://nodejs.dev/learn/install-an-older-version-of-an-npm-package)**

- `npm i tailwindcss@1.8.10`

**View Package Version**

- `npm view tailwindcss versions`

**Update or Find Outdated Packages:**

- `npm i -g npm-check-updates` // you must install this package
- ncu //will tell you latest updates, but no changes.
- ncu -g //global update check
- ncu -u //will edit package.json file with latest updates
- npm i //install all latest packages.
- add ^ to dependencies //means update to latest non-breaking changes. "react": "^17.0.2" -then: npm update
- [`npm outdated`](https://www.carlrippon.com/upgrading-npm-dependencies/) // -g flag to check global
- The wanted version is the latest safe version that can be taken (according to the semantic version and the ^ or ~ prefix). The latest version is the latest version available in the npm registry.
- `npm update` // -g flag for global
- to perform safe dependency upgrades.
- Update single package: npm update @babel/preset-env
- `npm update -g gatsby-cli`
- `npx npm-check-updates -u`, then run npm install to upgrade all dependencies to their latest major versions

**Dependencies vs Dev-Dependencies**

- dependencies
  - this is default unless -D or -O ar present.
  - `npm i [--save-prod] | -P packageName` // saves to 'dependencies' group
- devDependencies
  - devDependencies have no operation in working of final product and can be left out of final build with the --production flag.
  - to save as dev-dependency
    - `npm i -D packageName`
- optionalDependencies
  -O --save-optional // saves to

**Remove dependencies**

- The npm uninstall command completely removes the package and its dependencies from the current project. It also updates the package.json file.
- [uninstall packages](https://docs.npmjs.com/uninstalling-packages-and-dependencies)
- [npm uninstall](https://www.javascripttutorial.net/nodejs-tutorial/npm-uninstall/)
- `npm uninstall packageName --save || -D` // the --save updates the package.json
- `npm un packageName` // uninstall
- `npm rm --save packageName`
- `npm rm --save-dev packageName` // can use -D

**Clear Cache**

- `npm cache clear -f`
- `npm -g cache clean`
- Windows Powershell
  - `Remove-Item -Recurse -Force $env:LOCALAPPDATA/npm-cache/\_npx`

## Delete node_modules

```sh
# all levels nested folders -I use this one.
# https://stackoverflow.com/questions/28175200/how-to-delete-node-modules-deep-nested-folder-in-windows/62917293#62917293
npx rimraf ./\*\*/node_modules //no need to install, just run cmd.

# package to delete nodeModules
# https://npkill.js.org/
npm i -g npkill
# Simply go from the terminal to the directory from which you want to search and type npkill .
# This will start the search and will show the node_modules directories next to their size.
```

**Windows CMD**

```bat
REM list all node_modules
FOR /d /r . %d in (node_modules) DO @IF EXIST "%d" echo %d

REM delete all node_modules  CMD line not Powershell.  -only good for 1 level nested folders
FOR /d /r . %d in (node_modules) DO @IF EXIST "%d" rm -rf "%d"
```

## Global

**Global install**

- `npm install live-server -g`
- `npm i -g|-D postcss-cli`

**[List All Global Packages](https://medium.com/@alberto.schiabel/npm-tricks-part-1-get-list-of-globally-installed-packages-39a240347ef0)**

- `npm list -g --depth 0`
- `node list -g` // list all global packages

**Remove Global**

- `npm -g rm name` // rm is remove. do not need --save or --save-dev.

## Errors

- something is locking files.
  - open cmd line to root:
  - del package-lock.json && rd /s /q node_modules && npm cache clear --force
- Linux
  - rm package-lock.json && rm -R node_modules && npm cache clean --force
- File Errors -remove special characters
  - close vscode
  - `ctrl + h; \s (find); ' '(replace)` //just space.

## Random

**Publish to NPM**

- <a href="https://til.simonwillison.net/npm/publish-web-component">Publish Web Components</a>

**Bundle Scanner**

- [https://bundlescanner.com/?ck_subscriber_id=1189496731](https://bundlescanner.com/?ck_subscriber_id=1189496731)
