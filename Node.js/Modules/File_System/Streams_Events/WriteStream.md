# Write

- can take a buffer as a stream.
- `fs.createWriteStream()`
- https://www.freecodecamp.org/news/node-js-streams-everything-you-need-to-know-c9141306be93/
- When creating text streams, it is best to always specify an encoding: 'utf8', 'utf16le', 'base64'
- The most important events on a writable stream are:
  - The drain event, which is a signal that the writable stream can receive more data.
  - drain says: I'm drained, I can take more data in my buffer.
  - The finish event, which is emitted when all data has been flushed to the underlying system.
  - https://www.bennadel.com/blog/3236-using-transform-streams-to-manage-backpressure-for-asynchronous-tasks-in-node-js.htm

## Events

- https://codeburst.io/node-js-fs-module-write-streams-657cdbcc3f47
- The **first argument is the path of the file.** The path can be in the form of a string, a Buffer object, or an URL object.
- WriteStreams extend the Writable object, which emits events of its own.

**Events**

- **close** - emitted after file is written. The 'finish' is emitted when file is written and should be the one monitored.
  - Also emitted when any of its underlying resources like file descriptors have been closed.
  - If the emitClose option is set to true when creating the WriteStream then the close event will be emitted.
- **data** - when data 'chunk' is ready to write.
- **drain** - emitted when buffer is empty and ready for new data.
  - writing to disk is slower than reading, so backpressure will build.
  - when data buffer 'highWaterMark' (default is: 16kb for createWriteStream) is reached, the .write() function will return 'false'.
- **end** - write process is done.
- **error** - error when piping data
  - autoDestroy: true, closes write stream when error emitted.
  - **finish** - after the stream.end function is called all data has been written.
  - **open** - emitted when stream is opened. 'fd' (file descriptor) is passed when with the open event
  - **pipe** - emitted when the stream.pipe function is called with a readable stream piped to it.
    - The file specified when creating the ReadStream must exist before piping from it.
  - **ready** - emitted when WriteStream is ready to be used. Fired after immediately after open event.
  - **unpipe** - emitted when the stream.unpipe function is called on the readable stream.
    - It’s also emitted when the WriteStream emits an error event when a ReadStreanm is piped to it.

**Properties**

- **byteWritten** - number of bytes written by the WriteStream so far. Doesn't include data waiting to be written.
- **path** - where write to
- **pending** - true when underlying file has not been opened, before the 'ready' event is emitted.
- There is a maximum number of bytes that can be stored inside a writable stream’s internal buffer called the “highWaterMark” property.
  - When the highWaterMark is reached, the write method of createWriteStream will start returning false.
  - If it reaches that mark, it stops reading from the source.
  - When buffer is empty, will emit 'drain' event.

**Methods** //const writeable = fs.createWriteStream()

- `writeable.write()`
  - returns boolean value, if true, can write more, if false wait to write.
  - When false is returned, will emit 'drain' event when buffer is empty and it can write more.
  - https://javascript.info/iterable
  - input is an iterable. Array, string,
- `writeable.end()`
  - means no more data to write, close it down. You cannot write after it's called.
  - When end() is called, the 'finish' event is emitted.

**Write with drain**

```js
import _ as fs from 'fs'
import _ as util from 'util'
import _ as stream from 'stream'
import _ as readline from 'readline'
import { once } from 'events'

(async function () {
const dir = './avoid'

const finished = util.promisify(stream.finished)

// async function writeIterableToFile(iterable, filePath) {
// const writeable = fs.createWriteStream(filePath, {encoding: 'utf-8'})
// Write the data to stream with encoding to be utf8
//writerStream.write(data,'UTF8');
// for await (const chunk of iterable) {
// if (!writeable.write(chunk)) { //checks if write() is returning false. false means buffer is full.
// await once(writeable, 'drain') //await till buffer is empty, writeable emits 'drain' event when buffer is empty.
// }
// }
// writeable.end()
// await finished(writeable)
// }

const ws = fs.createWriteStream(`${dir}/info.txt`, {
flags: 'a',
encoding: 'utf-8',
})

for (let i = 1; i <= 10000000; i++) {
const data = `Bob is Wonderful! ${i}\n`
// allow drain when write buffer is full.
if (!ws.write(data)) { //if buffer full will return false. Then emit drain when buffer empty.
await once(ws, 'drain')
}
}
ws.end() //no more writes once end function is called.
ws.on('error', (err) => console.error(err))
await finished(ws)

// ----- measure memory and time ------
console.log('starting to run read')
const startTime = Date.now()
let lineTotal = 0
const rl = readline.createInterface({
input: fs.createReadStream(`${dir}/info.txt`),
})
rl.on('line', (line) => {
lineTotal++
})
await once(rl, 'close')
const endTime = Date.now()

const memory = process.memoryUsage().heapUsed / 1024 / 1024
console.log(
`The script uses approximately ${ Math.round(memory * 100) / 100 } MB. Total lines processed: ${lineTotal.toLocalString()}`
)
console.log(`Total Time: ${(endTime - startTime) / 1000}`)
})()
```

```js
const fs = require("fs");
const sourceFile = "./files/file.txt";
const destFile = "./files/newFile.txt";
const readStream = fs.createReadStream(sourceFile);
const writeStream = fs.createWriteStream(destFile, {
flags: "w",
encoding: "utf8",
mode: 0o666,
autoClose: true,
emitClose: true,
start: 0
});
readStream.pipe(writeStream);
writeStream.on("open", () => {
console.log("Stream opened");
});
writeStream.on("ready", () => {
console.log("Stream ready");
});
writeStream.on("pipe", src => {
console.log(src);
});
writeStream.on("unpipe", src => {
console.log(src);
});
writeStream.on("finish", () => {
console.log("Stream finished");
});

// write example
const fs = require('fs');
const file = fs.createWriteStream('./big.file'); //file will be over 400mb

for(let i=0; i<= 1e6; i++) {
file.write('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n');
}
file.end();

// server example
const fs = require('fs');
const server = require('http').createServer();

server.on('request', (req, res) => {
const src = fs.createReadStream('./big.file'); //big.file is over 400mb.
src.pipe(res);
});

## server.listen(8000);

// writable stream from fs module
import * as fs from 'fs'
import { fileURLToPath } from 'url' // url module is included with node
import path from 'path'
const **filename = fileURLToPath(import.meta.url)
const **dirname = path.dirname(__filename)

const writableStream = fs.createWriteStream(path.join(__dirname, 'out.txt'))
writableStream.write('This is dummy text1!!')
writableStream.write('\n')
writableStream.write('This is dummy text2!!')
writableStream.write('\n')
writableStream.write('This is dummy text3!!')
writableStream.write('\n')

writableStream.end('Done!!')
```
