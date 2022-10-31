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
  - Readable.from(str, encoding) can convert async generator into 'readable' stream.

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
- readline by line with events.
- readline removes the `\r\n` same as `''.split('\r\n')`
- [Events](https://nodejs.org/api/readline.html#class-interfaceconstructor)
- Events: close, line, history, pause, resume, SIGCONT, SIGINT, SIGSTP

**Synchronous Iteration**

- read file line by line then write.

```ts
(async function (inFile, outFile) {
  const rl = require('readline/promises').createInterface({
    input: require('fs').createReadStream(inFile),
    crlfDelay: Infinity,
  });
  // open the file handle promise in write mode.
  const fhp = await require('fs').promises.open(outFile, 'w');
  try {
    // iterate lines synchronously -transform line. '\r\n' removed by readline.
    for await (const line of rl) {
      // console.log(line);
      // await the promise after write.
      await fhp.write(line + '\n');
    }
    console.log(`${outFile} successfully created.`);
  } catch (e) {
    if (e instanceof Error) {
      console.log(e.message);
    } else {
      console.log(String(e));
    }
  } finally {
    await fhp.close();
    console.log(`${inFile} closed`);
  }
})();
```

**readLine, random wait times, showing synchronous write.**

```js
(async function () {
  const rl = require('readline/promises').createInterface({
    input: require('fs').createReadStream('data.json'),
    crlfDelay: Infinity,
  });
  // iterate lines synchronously
  for await (const line of rl) {
    // both 'await' are necessary.
    await syncP(line);
  }
})();

function syncP(line) {
  return new Promise((res, rej) => {
    setTimeout(function () {
      res(console.log('Line from file:', line));
    }, rand(100, 3000));
  });
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

// another one
export default async function addData(con: any, file: string) {
  console.log(`${file} started`);
  const rl = require('readline/promises').createInterface({
    input: require('fs').createReadStream(`mysql/${file}.csv`),
    crlfDelay: Infinity,
  });
  let count = 0;
  // used this way instead of rl.on('line', (line)=>{}), because this is the only way to 'stream' a file synchronously with node. Connection will close before all lines can be read with rl.on('line').
  for await (const line of rl) {
    if (count === 0) {
      // skip 1st line
      count++;
    } else {
      // is file price?
      if (file === 'price') {
        const newLine = line.split(',');
        newLine[0] = `'${newLine[0]}'`;
        const sql = `INSERT INTO ${file} VALUES (${count++},${newLine});`;
        await con.execute(sql);
      } else {
        const sql = `INSERT INTO ${file} VALUES (${count++},'${
          line.split(',')[1]
        }');`;
        await con.execute(sql);
      }
    }
  }
  console.log(`${file} ended.`);
  return;
}
```

### Asynchronous

- must use with pipe to work correctly.

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

# HTTP

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
import * as stream from 'stream';
const pipeline = util.promisify(stream.pipeline);
const writable = fs.createWriteStream(filePath);
await pipeline(readable, writable);
```

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

// another one read + transform line + write, through the pipeline.
(async function () {
  const { pipeline, Readable } = require('stream');
  const fs = require('fs');

  const readIterable = fs.createReadStream('./price.csv');
  const writeStream = fs.createWriteStream('./test.csv');

  // do transform function here.
  const transformLine = (line: string, lineEnding: string): string => {
    const words = line.replace(/\r?\n/, '').split(',');
    words[0] = `'${words[0]}'`;
    return `(${words.join(',')})${lineEnding}`;
  };

  // this function splits chunk into lines without lose of broken lines.
  async function* myTransform(chunkIterable: string) {
    let count = 0;
    let previous = '';
    for await (const chunk of chunkIterable) {
      let startSearch = previous.length;
      previous += chunk;
      while (true) {
        const eolIndex = previous.indexOf('\n', startSearch);
        if (eolIndex < 0) break;
        // line includes the EOL
        const line = previous.slice(0, eolIndex + 1);
        // Transform line here ------------------------------------
        if (count == 0) {
          yield `INSERT INTO \`price\` VALUES `;
          count++;
        }
        yield transformLine(line, ',');
        previous = previous.slice(eolIndex + 1);
        startSearch = 0;
      }
    }
    if (previous.length > 0) {
      // last line is processed here if there were any split lines in chunk.
      yield transformLine(previous, '');
    }
  }

  pipeline(
    Readable.from(myTransform(readIterable)),
    writeStream,
    (err: Error) => {
      if (err) {
        console.log('Pipeline failed: ', err);
      } else {
        console.log('Pipeline succeeded.');
      }
    }
  );
})();

// same as above, about 20% slower
const transformLine2 = (lines: string[], lineEnding: string): string => {
  return lines
    .map((line) => {
      const words = line.split(',');
      words[0] = `'${words[0]}'`;
      return `(${words.join(',')})${lineEnding}`;
    })
    .join(lineEnding);
};

async function* chunkToLines(chunkIterable: string) {
  let count = 0;
  let remaining = '';
  for await (const chunk of chunkIterable) {
    const lines = (remaining + chunk).split(/\r?\n/);
    // console.log(lines);
    remaining = lines.pop() || '';
    let x = transformLine2(lines, ',');
    if (count === 0) {
      x = `INSERT INTO \`price\` VALUES ` + x;
    }
    yield* x;
  }
  yield transformLine2([remaining], '\n');
}
```
