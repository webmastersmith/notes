# Streams & Buffers

## Streams

- Streams are essentially EventEmitters that can represent a readable and/or writable source of data.
- By default streams only support dealing with Strings and Buffers
- When in objectMode, streams can push Strings and Buffers as well as any other JavaScript object.
  - [Object Mode](https://nodesource.com/blog/understanding-object-streams/)
  - the internal buffering algorithm counts objects rather than bytes. This means if we have a Transform stream with the highWaterMark option set to 5, the stream will only buffer a maximum of 5 objects internally.
  - process.stdout is a regular stream that can only deal with Strings and Buffers.
  - Events: 'close', 'drain', 'error', 'finish', 'pipe', 'unpipe'

## Buffer

- [buffer and character encodings](https://nodejs.org/api/buffer.html#buffer_buffers_and_character_encodings)
  - 'utf8'
  - 'utf16le'
  - 'ascii'
  - 'latin1'
  - 'base64'
  - 'base64url',
  - 'hex' (each byte as two hexadecimal characters)
  - 'ucs-2' (same as utf16le)

**Back pressure**
[Nodejs Backpressure](https://enlear.academy/nodejs-backpressuring-in-streams-52638f505e1b)

- The highWaterMark option is a threshold, not a limit: it dictates the amount of data that a stream buffers before it stops asking for more data.
- handle data chunk by chunk using Stream API.
  - Readable stream extracts records significantly quicker than the Writable stream may process it.
  - leads to the size of the internal buffer exceeding the available memory, and the application is crashed.

```js
class CustomStream extends Readable {
  _read() {
    this.push({ time: new Date() });
  }
}
const customReadStream = new CustomStream({
  highWaterMark: 5, // when 5 'bytes' are read, returns false.
  objectMode: true, // objectMode will mean 5 objects in memory, not 5 bytes.
});
```

- `pipe` handles backpressure automatically.

```js
import fs from 'fs';
const readableStream = fs.createReadStream('path1');
const writableStream = fs.createWriteStream('path2');
readableStream.pipe(writableStream);
```
