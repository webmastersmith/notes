# FS.Read

- https://nodejs.org/api/fs.html

## READ

**CJS**

```js
const fs = require("fs");
const fs = require("fs").promises; //allows you to use await with writeFile, readFile.
const fs = require("fs/promises"); // does the same thing as above
```

**Callback**

```js
fs.readFile;
//nodejs.org/api/fs.html#fs_fs_readfile_path_options_callback
https: callback;
import { readFile } from "fs";

readFile("/etc/passwd", { encoding: "utf-8" }, (err, data) => {
  if (err) throw err;
  console.log(data);
});

fs.readFile(cartPath, "utf-8", (err, data) => {
  //allows for fallback if file does not exist.
  let cart = { products: [], total: 0 }; //fallback.
  if (!err) {
    cart = JSON.parse(data);
  }
  // cart will be available, even if file does not exist.
});
```

**[Synchronous](https://nodejs.org/api/fs.html#fsreadfilesyncpath-options)**

```js
import { readFileSync } from "node:fs";
// const fs = require('fs')

const data = readFileSync("<directory>", "utf8"); // encoding default: null (buffer).
```

**[Promise](https://nodejs.org/api/fs.html#fspromisesreadfilepath-options**

```js
import { readFile } from "node:fs/promises";
// import { promises as fsp } from "node:fs";
try {
  const filePath = new URL("./package.json", import.meta.url);
  const contents = await readFile(filePath, { encoding: "utf8" });
  // const contents = await fsp.readFile(filePath, { encoding: "utf8" });
  console.log(contents);
} catch (err) {
  console.error(err.message);
}
```

## Images

```js
// convert image to base64. // works with file.
// Read Image from file
const buffBase64 = fs.readFileSync(path.join(\_\_dirname, 'streetview.jpg'), 'base64') //convert to base64 from binary.

// Write Image from base64
fs.writeFileSync('src/streetview2', 'data:image/jpeg;base64,'+buffBase64) //base64. html= image src=''

// convert base64 Image to binary and write on disk so it's a jpeg again.
const image = owner.thumbnail.replace(/data.+base64,/, '')
fs.writeFileSync('src/streetview2.jpeg', Buffer.from(image, 'base64'), 'binary') //write binary data in buffer. images, video, audio.

// Image Binary data to base64
AXIOS will break the binary data, need to use {responseType: 'arraybuffer'}
The reason this won't work is that axios puts everything in a json object. Since you cannot put binary in a json object it converts it to a string which breaks the binary.
const pic = await axios(staticUrl, { responseType: 'arraybuffer' })
const buff = Buffer.from(pic.data, 'binary').toString('base64')
const picURL = `data:${pic.headers['content-type']};base64,${buff}`
//to get file type: headers['content-type'].replace(/\w+\//i, '') //jpeg

// axios image to file.
const images = await Promise.all(
imgUrls.map(async (url) => axios(url, { responseType: 'arraybuffer' }))
)

      for (const [i, image] of images.entries()) {
        fs.writeFileSync(`src/images/file${i + 1}.${image.headers['content-type'].replace(/\w+\//i, '')}`, image.data)
      }
```

## Base64

- https://nodejs.org/api/buffer.html#buffer_buffers_and_character_encodings
- 'utf8' //default if nothing specified
- 'base64'
- 'binary'

```js
// Write to file from binary -makes a complete image.
fs.writeFileSync("src/streetview2.jpeg", pic.data);

// Write to file from base64URL -convert base64URL (dataURL) to jpeg image.
const jpeg = picURL.replace(/data:.\*;base64,/, "");
fs.writeFileSync("src/streetview3.jpeg", jpeg, "base64");

// convert utf8 string to base64
const b64 = Buffer.from("Hello World!").toString("base64");
// convert base64 to utf8 string
const str = Buffer.from(b64Encoded, "base64").toString();
```

File System

fs.stat()
https://nodejs.org/api/fs.html#fs_fs_stat_path_options_callback
https://nodejs.org/api/fs.html#fs_fs_statsync_path_options
https://nodejs.org/api/fs.html#fs_class_fs_stats

Methods
fs.stat(path, function(error, stats) {
console.log(stats.isFile());
console.log(stats.isDirectory());
console.log(stats.isBlockDevice());
console.log(stats.isCharacterDevice());
console.log(stats.isFIFO());
console.log(stats.isSocket());
});

const fs = require('fs')
import \* as fs from 'fs'

// callback
fs.stat('path', (err, stat) => {if (err) console.log(err); console.log(stat.size / 1024\*\*2 ) }) // get MB size.

// syncronous
try {
const allStats = fs.statSync('path', {options})
const {size} = fs.statSync('path')
} catch(e) {}

// size is in bytes
KB 1024
MB 1024 ** 2
GB 1024 ** 3

Stats {
dev: 16777220,
mode: 16877,
nlink: 3,
uid: 501,
gid: 20,
rdev: 0,
blksize: 4096,
ino: 14214262,
size: 96,
blocks: 0,
atimeMs: 1561174653071.963,
mtimeMs: 1561174614583.3518,
ctimeMs: 1561174626623.5366,
birthtimeMs: 1561174126937.2893,
atime: 2019-06-22T03:37:33.072Z,
mtime: 2019-06-22T03:36:54.583Z,
ctime: 2019-06-22T03:37:06.624Z,
birthtime: 2019-06-22T03:28:46.937Z
}

Property
Description
dev
ID of the device containing the file.
mode
File protection.
nlink
Number of hard links to the file.
uid
User ID of the file’s owner.
gid
Group ID of the file’s owner.
rdev
Device ID if the file is a special file.
blksize
Block size for file system I/O.
ino
File inode number. An inode is a file system data structure that stores information about a file.
size
File total size in bytes.
blocks
Number of blocks allocated for the file.
atime
Date object representing the file’s last access time.
mtime
Date object representing the file’s last modification time.
ctime
Date object representing the last time the file’s inode was changed.

File Size
https://nodejs.org/api/fs.html#fs_fspromises_stat_path_options
https://coderrocketfuel.com/article/get-the-total-size-of-all-files-in-a-directory-using-node-js
The size of the file in bytes.
import fs from 'fs'
// import { stat } from 'fs/promises'; //can use await or .then()
import \* as fs from 'fs'

function getFileSize(path) {
const fixed1 = (num) => +(Math.round(num + 'e+1') + 'e-1')

const { size: bytes } = fs.statSync(path)
const base = 1024
const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
const i = parseInt(Math.floor(Math.log(bytes) / Math.log(base)))
if (bytes === 0) return 'bytes are empty'
if (i === 0) return bytes + ' ' + sizes[i]
return { size: fixed1(bytes / Math.pow(base, i)) + ' ' + sizes[i], bytes }
}

console.log(getFileSize('./src/A.CINDERELLA.STORY.mp4.gz')) //{ size: '2.4 GB', bytes: 2533085932 }

Directory

fs.readdirSync()
f
https://nodejs.org/api/fs.html#fs_fs_readdirsync_path_options
returns an array of strings.
const allFilesInDirectory = fs.readdirSync('path', {options}) // default 'utf8'
// returns [ 'file-1.txt', 'file-2.txt' ]

// filter to only find 'mpeg' files
const files = fs.readdirSync(`${dir}`).filter((file) => file.endsWith('.mpeg'))

FileName
path.basename('./some/direcotry/file.txt'') // file.txt <string>  
path.basename('./some/direcotry/file.txt', '.txt') // file <string>

Create
https://nodejs.org/api/fs.html#fsmkdirsyncpath-options
fs.mkdirSync(path, {options})
fs.mkdirSync('./one/two', { recursive: true }) //It creates folder 'one' in the current directory and inner folder 'two' inside 'one'.

Delete
https://stackoverflow.com/questions/18052762/remove-directory-which-is-not-empty

fs.unlinkSync() //delete files
https://nodejs.org/api/fs.html#fs_fs_unlink_path_callback
https://nodejs.org/api/fs.html#fs_fs_unlinksync_path

fs.unlink('path', (err) => {if (err) console.log(err)})

try {
fs.unlinkSync('path', ) // returns undefined
} catch(e) {console.log(e.message)}

Directory
node >12.10.0
fs.rmdirSync(dir, { recursive: true }); //uses rimraf underhood.
In short: fs.readdir(dirPath) for an array of paths in a folder, iterate through fs.unlink(filename) to delete each file, and then finally fs.rmdir(dirPath) to delete the now-empty folder. If you need to recurse, check fs.lstat(filename).isDirectory()
const fs = require('fs');
const Path = require('path');

    const deleteFolderRecursive = function (directoryPath) {
    if (fs.existsSync(directoryPath)) {
        fs.readdirSync(directoryPath).forEach((file, index) => {
          const curPath = path.join(directoryPath, file);
          if (fs.lstatSync(curPath).isDirectory()) {
           // recurse
            deleteFolderRecursive(curPath);
          } else {
            // delete file
            fs.unlinkSync(curPath);
          }
        });
        fs.rmdirSync(directoryPath);
      }
    };

RimRaf
There is a module for this called rimraf (https://npmjs.org/package/rimraf). It provides the same functionality as rm -Rf
Async usage:
var rimraf = require("rimraf");
rimraf("/some/directory", function () { console.log("done"); });
Sync usage:
rimraf.sync("/some/directory");

Move
npm i mv
mv('source', 'dest', err => { if (err) log(err); else log(moved successfully!) })
must have filename on end or will error.
f
mv( `./audio/test.txt`, 'F:Raid_Backup/AudioBooks/SidaBook.com/filename.txt', (err) => {
if (err) console.log(err)
else console.log('Moved file successfully!')
}
)

Check if file exist //fs.exist(callback) is depreciated -use fs.existSync()
https://flaviocopes.com/how-to-check-if-file-exists-node/
fs.existSync('path') //true/false
https://nodejs.org/api/fs.html#fsexistssyncpath
returns boolean
import { existsSync } from 'node:fs';
if (existsSync('/etc/passwd')) console.log('The path exists.');

Check if user has permissions to access file.
fs.access('path', cb() )
simple fast api. only checks if file exist.
https://nodejs.org/dist/latest-v10.x/docs/api/fs.html#fs_fs_access_path_mode_callback
fs.accessSync()
https://nodejs.org/dist/latest-v10.x/docs/api/fs.html#fs_fs_accesssync_path_mode
returns err if file not exist.
try {
fs.accessSync('etc/passwd', fs.constants.R_OK | fs.constants.W_OK);
console.log('can read/write');
} catch (err) {
console.error('no access!');
}
