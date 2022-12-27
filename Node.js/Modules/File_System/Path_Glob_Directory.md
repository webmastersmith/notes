# Path

- https://nodejs.org/api/path.html
- https://shapeshed.com/writing-cross-platform-node/
- `__dirname` is directory where file code is located. If imported, it's still from where directory file code is located.

```js
const path = require('path')
require('dotenv').config({ path: path.join(__dirname, '../.env') });
const fs = require('fs')

path.join(**dirname, 'file')
// to use as a placeholder
path.join(**dirname, '', 'somefile.txt') //closed single qoutes.
```

**ES6**

- https://stackoverflow.com/questions/8817423/why-is-dirname-not-defined-in-node-repl
- https://nodejs.org/docs/latest-v15.x/api/esm.html#esm_no_require_exports_or_module_exports
- https://nodejs.org/docs/latest-v15.x/api/esm.html#esm_import_meta_url
- https://dmitripavlutin.com/javascript-import-meta/
- If you are using Node.js modules, **dirname and **filename don't exist.

```js
// if path module **dirname and **filename do not exist
import { readFile } from 'fs/promises';
import { readFileSync } from 'fs';
// or
import * as fs from 'fs'
import path from 'path'

// C:\Users\webmaster\Documents\MEGAsync\javascript\nodejs //notice backslashes are windows. -do not use.
path.join(process.cwd(), 'fileName.txt') //prints current working directory + fileName.txt

// Do not use these. Use the two below.
const json = JSON.parse(await readFile(new URL('./dat.json', import.meta.url)));
const buffer = readFileSync(new URL('./data.proto', import.meta.url));
console.log(path.basename(import.meta.url)) // returns current file name and ext.
console.log(path.basename(import.meta.url, '.mjs')) // returns current file name.

// use these for ES6
// file
fsp.readFile(process.cwd() + '/data.json', 'utf-8') // data.json file -don't forget the forward slash!.
path.join(process.cwd(), 'data', 'data.json') //data folder/data.json file.
path.join(**dirname, 'fileName.ts') //current working directory, fileName.ts
// directory
process.cwd() //current directory of root folder.
path.dirname(require.main.filename) //outputs main directory -same as process.cwd()
// or
// to use **dirname or **filename
import { fileURLToPath } from 'url'; // url module is included with node
import path from 'path';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
// or
import * as url from 'url';
const __filename = url.fileURLToPath(import.meta.url);
const __dirname = url.fileURLToPath(new URL('.', import.meta.url));
```

**FileName**

```js
path.basename('./some/direcotry/file.txt'') // file.txt <string>
path.basename('./some/direcotry/file.txt', '.txt') // file <string>
```

**Extension Name**

```js
path.extname; //file.tsx = tsx
```

# Glob

- https://www.npmjs.com/package/glob

```js
import glob from 'glob'
const glob.sync('\*_/_.mdx')
```

**Globby**

- https://www.npmjs.com/package/globby

**Fast-Glob**

- https://codesandbox.io/s/m4kzq?file=/src/utils/get-mdx-content.js:637-683
- https://www.npmjs.com/package/fast-glob
- src/\*\*/\*.js — matches all files in the src directory (any level of nesting) that have the .js extension.
- src/\*\*/\*.{css,scss} — matches all files in the src directory (any level of nesting) that have the .css or .scss extension.
- file-[[:digit:]].js — matches files: file-0.js, file-1.js, …, file-9.js.
- file-{1..3}.js — matches files: file-1.js, file-2.js, file-3.js.
- file-(1|2) — matches files: file-1.js, file-2.js.

```js
npm i fast-glob
//const fg = require('fast-glob');
import glob from 'fast-glob'; //esm

const files = glob.sync("**/\*.mdx", {options: optional}); // ** at start means cwd. -is the root
```

# Directory

**fs.readdir() callback**

```js
const fs = require('fs'):
fs.readdir(directoryPath, function (err, files) {
    //handling error
    if (err) {
        return console.log('Unable to scan directory: ' + err);
    }
}

// Promises
import { readdir } from 'node:fs/promises';

try {
  const files = await readdir(path);
  for (const file of files)
    console.log(file);
} catch (err) {
  console.error(err);
}

// Remove directories
  const files = fs
    .readdirSync(src)
    .filter((file) => !fs.statSync(`${src}/${file}`).isDirectory());

```

### Check if Directory Exist

```js
// const fs = require("fs")
import fs from 'fs';

try {
  if (fs.existsSync('./directory-name')) {
    console.log('Directory exists.');
  } else {
    console.log('Directory does not exist.');
  }
} catch (e) {
  console.log('An error occurred.');
}
```

### Create Directory

- [director tutorial](https://blog.logrocket.com/file-processing-node-js-comprehensive-guide/)

```js
const fs = require('fs');
const dir = './tmp/but/then/nested';

// callback
fs.mkdir(dir, { recursive: true }, (err) => {
  if (err) console.error(err);
  // if (err) throw err;
});
// sync
if (!fs.existsSync(dir)) {
  fs.mkdirSync(dir, { recursive: true });
}

// example 1: create a directory
await fsPromises.mkdir('sampleDir');

// example 2: create multiple nested directories
await fsPromises.mkdir('nested1/nested2/nested3', { recursive: true });

// example 3: rename a directory
await fsPromises.rename('sampleDir', 'sampleDirRenamed');

// example 4: remove a directory
await fsPromises.rmdir('sampleDirRenamed');

// example 5: remove a directory tree
await fsPromises.rm('nested1', { recursive: true });

// example 6: remove a directory tree, ignore errors if it doesn't exist
await fsPromises.rm('nested1', { recursive: true, force: true });

// example 1: get names of files and directories
const files = await fsPromises.readdir('anotherDir');
for (const file in files) {
  console.log(file);
}

// example 2: get files and directories as 'Dirent' directory entry objects
const dirents = await fsPromises.readdir('anotherDir', { withFileTypes: true });
for (const entry in dirents) {
  if (entry.isFile()) {
    console.log(`file name: ${entry.name}`);
  } else if (entry.isDirectory()) {
    console.log(`directory name: ${entry.name}`);
  } else if (entry.isSymbolicLink()) {
    console.log(`symbolic link name: ${entry.name}`);
  }
}
```
