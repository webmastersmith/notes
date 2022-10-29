# ReadStream

- streams are provided by two different modules.

# FS Module

- readFile reads entire file into memory.
- [callback](https://nodejs.org/api/fs.html#fsreadfilepath-options-callback)
- [promises](https://nodejs.org/api/fs.html#fspromisesreadfilepath-options)

### fs.readFile

```js
// callback
import { readFile } from 'node:fs';

readFile('/etc/passwd', (err, data) => {
  if (err) throw err;
  console.log(data);
});

// promise based.
import { readFile } from 'node:fs/promises';
try {
  const filePath = `${process.cwd()}/fileName.txt`;
  const contents = await readFile(filePath, { encoding: 'utf8' });
  console.log(contents);
} catch (err) {
  console.error(err.message);
}
```

### fs.createReadStream

- [Nodejs createReadStream](https://nodejs.org/api/fs.html#fscreatereadstreampath-options)
- returns [stream.readable](https://nodejs.org/api/stream.html#class-streamreadable) class.
  - can use all the Events and Methods of stream.readable.
  - `fs.createReadStream(path, string | object)`
  - `fs.createReadStream('./fileName.txt', 'utf-8')`
  - `fs.createReadStream('./fileName.txt', { encoding: 'utf-8' })`
  - `highWaterMark default is 64 * 1024 = 65,536B`
    - `stream.readable default is 16 * 1024 = 16,384B`

**Events**

- [Node FS createReadStream Events](https://nodejs.org/api/stream.html#class-streamreadable)
- Event: 'close', 'data', 'end', 'error', 'pause', 'readable', 'resume'.

```js
const fs = require('fs');
const readable = fs.createReadStream('./myfile', { highWaterMark: 20 }); // 20 Bytes

let bytesRead = 0;

readable.on('data', (chunk) => {
  console.log(`Read ${chunk.length} bytes`);
  bytesRead += chunk.length;

  // Pause the readable stream after reading 60 bytes from it.
  if (bytesRead === 60) {
    readable.pause();
    console.log(`after pause() call. is flowing: ${readable.readableFlowing}`);

    // resume the stream after waiting for 1s.
    setTimeout(() => {
      readable.resume();
      console.log(
        `after resume() call. is flowing: ${readable.readableFlowing}`
      );
    }, 1000);
  }
});
```

### Readline

- [Node Readline Module](https://nodejs.org/api/readline.html)
- read line by line with events.
- [Events](https://nodejs.org/api/readline.html#class-interfaceconstructor)
- Events: close, line, history, pause, resume, SIGCONT, SIGINT, SIGSTP

**Synchronous Iteration**

```js
(async function () {
  const lr = require('readline/promises').createInterface({
    input: require('fs').createReadStream('data.json'),
    crlfDelay: Infinity,
  });
  // iterate lines synchronously
  for await (const line of lr) {
    await syncP(line);
  }
})();

function syncP(line) {
  return new Promise((res, rej) => {
    setTimeout(function () {
      console.log('Line from file:', line);
      res(true);
    }, rand(100, 3000));
  });

  // another one
  import fs from 'fs';
  import readline from 'readline/promises';

  export default async function addData(con: any) {
    const files = ['price', 'type', 'region'];

    for await (const file of files) {
      const rl = readline.createInterface({
        input: fs.createReadStream(`./${file}.csv`),
        crlfDelay: Infinity,
      });
      for await (const line of rl) {
        if (line.includes('id')) {
          // skip 1st line
        } else {
          await new Promise((res) => {
            // is file price?
            if (file === 'price') {
              const sql = `INSERT INTO ${file} VALUES (${line.split(',')})`;
              res(console.log(sql));
            } else {
              const sql = `INSERT INTO ${file} VALUES ('${
                line.split(',')[1]
              }')`;
              res(console.log(file, sql));
            }
          });
        }
      }
      rl.on('error', (err) => {
        console.log(err);
      });
    }
  }
  addData('temp');
}

function rand(min, max) {
  var argc = arguments.length;
  if (argc === 0) {
    min = 0;
    max = 2147483647;
  } else if (argc === 1) {
    throw new Error('Warning: rand() expects exactly 2 parameters, 1 given');
  }
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
// data.json
// {"id":0,"name":"line 0","value":489}
// {"id":1,"name":"line 1","value":148}
// {"id":2,"name":"line 2","value":798}
// {"id":3,"name":"line 3","value":766}
// {"id":4,"name":"line 4","value":70}
// {"id":5,"name":"line 5","value":825}
// {"id":6,"name":"line 6","value":353}
// {"id":7,"name":"line 7","value":175}
// {"id":8,"name":"line 8","value":12}
```

```js
// import * as readline from 'node:readline/promises';
const fs = require('fs');
const readline = require('readline');
const readStream = fs.createReadStream('./avocado.csv'); // encoding not needed.
let count = 1;
const writeStream = fs.createWriteStream('./avocado-fix.csv');
const rl = readline.createInterface({ input: readStream });
rl.on('line', (line) => {
  if (line.includes('date')) {
    writeStream.write(`id,${line}\n`); // line endings are removed.
  } else {
    writeStream.write(`${count++},${line}\n`);
  }
});
rl.on('close', () => {
  writeStream.end();
  writeStream.on('finish', () => {
    console.log('Finished!!!');
  });
});
```

# Examples

**Simple HTTP Server**

```ts
import fs from 'fs';
import http from 'http';

const server = http.createServer().listen(8080, '127.0.0.1', () => {
  console.log('server running');
});

server.on('request', (req, res) => {
  if (req.url === '/big-file') {
    const readable = fs.createReadStream('./big-file.txt');
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    // solution 1
    // this solution does not handle back pressure
    // readable.on("data", (chunk) => {
    //   res.write(chunk);
    // });

    // solution 2
    // handle back pressure automatically
    readable.pipe(res);

    // close stream
    readable.on('end', () => {
      console.log('file sent to http client');
      res.end();
      return;
    });

    // handle errors for the first solution
    readable.on('error', (err) => {
      console.log(err);
      console.log('file missing');
      res.statusCode = 500;
      res.end('file not found');
      return;
    });
  } else {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('home page');
  }
});
```

**Handling Back pressure**

- [Node Article](https://nodejs.org/en/docs/guides/backpressuring-in-streams/)
- `pipeline` allows for error handling with the `pipe()` method.
- default `highWaterMark: 64kB`

Manual

- better to use `pipe` or `pipeline`.

```js
app.get('/movie', (req: Request, res: Response) => {
  const readStream = fs.createReadStream('file.avi');
  readStream
    .on('data', (chunk) => {
      const canReadNext = res.write('chunk') // returns false when HighWater mark reached.
      if (!canReadNext) {
        readStream.pause();
        res.once('drain', () => readStream.resume())
      }
    })
    .on('end', () => {
      res.end();
    })
    .on('error' (err) => {
      console.error(err)
      res.destroy();
    });
});
```

Pipe

- automatically handles backpressure, for error handling use `pipeline`.

```js
const { pipe } = require("stream");
const fs = require("fs");

app.get('/movie', (req: Request, res: Response) => {
  const readStream = fs.createReadStream('file.avi');
  // pipe handles backpressure automatically.
  readStream.pipe(res) // res is a WriteStream.
```

Pipeline

- allows error handling

```js
const { pipeline } = require('stream');
const fs = require('fs');
const zlib = require('zlib');

// Use the pipeline API to easily pipe a series of streams
// together and get notified when the pipeline is fully done.
// A pipeline to gzip a potentially huge video file efficiently:

pipeline(
  fs.createReadStream('The.Matrix.1080p.mkv'),
  zlib.createGzip(),
  fs.createWriteStream('The.Matrix.1080p.mkv.gz'),
  (err) => {
    if (err) {
      console.error('Pipeline failed', err);
    } else {
      console.log('Pipeline succeeded');
    }
  }
);

// async
const stream = require('stream');
const fs = require('fs');
const zlib = require('zlib');
const util = require('util');

const pipeline = util.promisify(stream.pipeline);

async function run() {
  try {
    await pipeline(
      fs.createReadStream('The.Matrix.1080p.mkv'),
      zlib.createGzip(),
      fs.createWriteStream('The.Matrix.1080p.mkv.gz')
    );
    console.log('Pipeline succeeded');
  } catch (err) {
    console.error('Pipeline failed', err);
  }
}
```
