# Write

- [fs.writeFile](https://nodejs.org/api/fs.html)
- It is unsafe to use fs.write() multiple times on the same file without waiting for the callback. For this scenario, fs.createWriteStream() is recommended.
- overwrites the specified file and content if it exists. If the file does not exist, a new file, containing the specified content, will be created.

## flags

**[fs Flags](https://nodejs.org/api/fs.html#fs_file_system_flags)**

- r+ open the file for reading and writing
- w+ open the file for reading and writing, positioning the stream at the beginning of the file. The file is created if it does not exist
- a open the file for writing, positioning the stream at the end of the file. The file is created if it does not exist
- a+ open the file for reading and writing, positioning the stream at the end of the file. The file is created if it does not exist

## Callback

- https://nodejs.org/api/fs.html#fs_fs_write_fd_buffer_offset_length_position_callback
- It is unsafe to use fs.writeFile() multiple times on the same file without waiting for the callback. For this scenario, fs.createWriteStream() is recommended.

```js
fs.writeFile(file, data, options{flag: 'a'}, callback(err => err))
```

import { writeFile } from 'fs';

const data = new Uint8Array(Buffer.from('Hello Node.js'));
writeFile('message.txt', data, (err) => {
if (err) throw err;
console.log('The file has been saved!');
});

//download file from url
// https://nodejs.org/api/https.html#https_https_get_url_options_callback
var https = require('https');
var fs = require('fs');

var file = fs.createWriteStream("file.wav");
var request = http.get("http://static1.grsites.com/archive/sounds/comic/comic002.wav", function(response) {
response.pipe(file);
});

// puppeteer
https://www.scrapingbee.com/blog/download-file-puppeteer/
const fs = require('fs');
const https = require('https');
...
const imgUrl = await page.$eval('.\_2UpQX', img => img.src);

        https.get(imgUrl, res => {
            const stream = fs.createWriteStream('somepic.png');
            res.pipe(stream);
            stream.on('finish', () => {
                stream.close();
            })
        })
        browser.close()
    }

## Synchronous

```js
fs.writeFileSync()
https://nodejs.org/api/fs.html#fs_fs_writefilesync_file_data_options
fs.writeFileSync(file, data[, options])

const data = new Uint8Array(Buffer.from('Hello Node.js'));

//print nested arr/obj
fs.writeFileSync('./newShopData.js', JSON.stringify(newShopData, null, 2))
```

## Promise

fs.writeFile

```js
const fs = require("fs/promises");

async function example() {
  try {
    const content = "Some content!";
    await fs.writeFile("/Users/joe/test.txt", content);
  } catch (err) {
    console.log(err);
  }
}
example();
```

## Append File

appendFile
https://nodejs.org/api/fs.html#fsappendfilepath-data-options-callback
import { appendFile } from 'node:fs';

appendFile('message.txt', 'data to append', (err) => {
if (err) throw err;
console.log('The "data to append" was appended to file!');
});

appendFile -Promise
https://nodejs.org/api/fs.html#fspromisesappendfilepath-data-options
import fs from 'fs/promises'

async function example() {
try {
const content = 'Some content!';
await fs.appendFile('/Users/joe/test.txt', content);
} catch (err) {
console.log(err);
}
}
example();

appendFileSync
https://nodejs.org/api/fs.html#fsappendfilesyncpath-data-options
try {
appendFileSync('message.txt', 'data to append');
console.log('The "data to append" was appended to file!');
} catch (err) {
/_ Handle the error _/
}
