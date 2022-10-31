# Transform

- when 'chunk' is processed, Transform stream waits for `callback()` to run, then get's next chunk.

```js
const fs = require('fs');
const Transform = require('stream').Transform;

const chunkSize = 65536; // default is 65536 (64 * 1024)
const fileName = './avocado.csv';
const outName = fileName.replace('.csv', '-fix.csv');
const fileSize = fs.statSync(fileName).size; // 978203
const fileSizeGoal = fileSize - chunkSize;
const readStream = fs.createReadStream(fileName, {
  // encoding: 'utf-8',
  // highWaterMark: chunkSize,
});
const writeStream = fs.createWriteStream(outName);

function xStream() {
  let fileSizeTracker = 0;
  let brokenLine = '';
  let count = 1;

  return (xStream = new Transform({
    // objectMode: true,
    transform(chunk, encoding, cb) {
      // last line of file may not have \r\n, so last line get orphaned. Track chunks used to fileSize to determine if stream is on last chunk.
      // track file usage. If fileSizeTracker gets close to fileSize, add brokenLine to last chunk.
      fileSizeTracker += chunkSize;
      // regex keeps the '\r\n' from being removed, so I can identify broken lines.
      const lines = chunk.toString().split(/(?<=\r?\n)/);
      // if brokenLine has string, add to beginning of lines.
      if (brokenLine) {
        lines[0] = brokenLine + lines[0];
        brokenLine = '';
      }
      // check if last item in array has \r\n?
      const endLine = lines[lines.length - 1];
      if (!/\r?\n/.test(endLine)) {
        brokenLine = lines.pop();
      }
      // if fileSize is close to actual, make sure last line makes it in.
      if (fileSizeTracker >= fileSizeGoal) {
        lines.push(brokenLine);
      }

      // modify lines here ------------------------
      chunk = lines
        .map((line) => {
          if (line.includes('region')) {
            return `id,${line}`;
          }
          return `${count++},${line}`;
        })
        .join('');

      cb(null, chunk);
    },
  }));
}

readStream.pipe(xStream()).pipe(writeStream);
```

## Clock

- [blog](https://nodesource.com/blog/understanding-streams-in-nodejs/)

```js
const Readable = require('stream').Readable;
const Transform = require('stream').Transform;
const Writable = require('stream').Writable;

// clock
function clock() {
  const readStream = new Readable({
    objectMode: true,
    read() {},
  });

  setInterval(() => {
    readStream.push({ time: new Date() });
  }, 1000);

  return readStream;
}

function xFormer() {
  let count = 0;
  return (xStream = new Transform({
    objectMode: true,
    transform: (chunk, encoding, cb) => {
      cb(null, { ...chunk, index: count++ });
    },
  }));
}

function writer() {
  return new Writable({
    objectMode: true,
    write: (chunk, encoding, cb) => {
      console.log(chunk);
      cb();
    },
  });
}

clock().pipe(xFormer()).pipe(writer());
```

# Class

```js
(async function () {
  const { pipeline, Transform } = require('stream');
  const split2 = require('split2');
  const fs = require('fs');

  const readStream = fs.createReadStream('./price.csv');
  const writeStream = fs.createWriteStream('./test.csv');

  class FilterBlastOutput extends Transform {
    _transform(chunk: any, encoding: string, callback: any) {
      // console.log(chunk.toString());
      // each chunk is actually a line from split2.
      this.push(chunk + '\r\n'); // concatenate converts chunk to string in background.
      callback();
    }
  }

  pipeline(
    readStream,
    split2(),
    new FilterBlastOutput(),
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

// or Transform Constructor.
(async function () {
  const { pipeline, Transform } = require('stream');
  const split2 = require('split2');
  const fs = require('fs');

  const readStream = fs.createReadStream('./price.csv');
  const writeStream = fs.createWriteStream('./test.csv');

  function xform() {
    return new Transform({
      transform: (chunk: any, encoding: string, cb: any) => {
        chunk += 'hello\r\n';
        cb(null, chunk);
      },
    });
  }

  pipeline(readStream, split2(), xform(), writeStream, (err: Error) => {
    if (err) {
      console.log('Pipeline failed: ', err);
    } else {
      console.log('Pipeline succeeded.');
    }
  });
})();
```
