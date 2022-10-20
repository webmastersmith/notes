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
import \* as fs from 'fs'
import path from 'path'

// C:\Users\webmaster\Documents\MEGAsync\javascript\nodejs //notice backslashes are windows. -do not use.
path.join(process.cwd(), 'fileName.txt') //prints current working directory + fileName.txt

// Do not use these. Use the two below.
const json = JSON.parse(await readFile(new URL('./dat.json', import.meta.url)));
const buffer = readFileSync(new URL('./data.proto', import.meta.url));
console.log(path.basename(import.meta.url)) // returns current file name and ext.
console.log(path.basename(import.meta.url, '.mjs')) // returns current file name.

// use these for ES6
process.cwd() + '/data.json' // data.json file -don't forget the forward slash!.
path.join(process.cwd(), 'data', 'data.json') //data folder/data.json file.
process.cwd() //current directory of root folder.
path.dirname(require.main.filename) //outputs main directory -same as process.cwd()
path.join(**dirname, 'fileName.ts') //current working directory, fileName.ts
// or
// to use **dirname or **filename
import { fileURLToPath } from 'url'; // url module is included with node
import path from 'path';
const **filename = fileURLToPath(import.meta.url);
const **dirname = path.dirname(**filename);
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
