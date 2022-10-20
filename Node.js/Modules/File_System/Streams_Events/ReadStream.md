# ReadStream

- `fs.createReadStream('fileName')`

  **Simple HTTP Server**

```ts
import fs from "fs";
import http from "http";

const server = http.createServer().listen(8080, "127.0.0.1", () => {
  console.log("server running");
});

server.on("request", (req, res) => {
  if (req.url === "/big-file") {
    const readable = fs.createReadStream("./big-file.txt");
    res.writeHead(200, { "Content-Type": "text/plain" });
    // solution 1
    // this solution does not handle back pressure
    // readable.on("data", (chunk) => {
    //   res.write(chunk);
    // });

    // solution 2
    // handle back pressure automatically
    readable.pipe(res);

    // close stream
    readable.on("end", () => {
      console.log("file sent to http client");
      res.end();
      return;
    });

    // handle errors for the first solution
    readable.on("error", (err) => {
      console.log(err);
      console.log("file missing");
      res.statusCode = 500;
      res.end("file not found");
      return;
    });
  } else {
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end("home page");
  }
});
```

**Handling Back pressure**

- [Node Article](https://nodejs.org/en/docs/guides/backpressuring-in-streams/)
- `pipeline` allows for error handling with the `pipe()` method.

```js
const { pipeline } = require("stream");
const fs = require("fs");
const zlib = require("zlib");

// Use the pipeline API to easily pipe a series of streams
// together and get notified when the pipeline is fully done.
// A pipeline to gzip a potentially huge video file efficiently:

pipeline(
  fs.createReadStream("The.Matrix.1080p.mkv"),
  zlib.createGzip(),
  fs.createWriteStream("The.Matrix.1080p.mkv.gz"),
  (err) => {
    if (err) {
      console.error("Pipeline failed", err);
    } else {
      console.log("Pipeline succeeded");
    }
  }
);

// async
const stream = require("stream");
const fs = require("fs");
const zlib = require("zlib");
const util = require("util");

const pipeline = util.promisify(stream.pipeline);

async function run() {
  try {
    await pipeline(
      fs.createReadStream("The.Matrix.1080p.mkv"),
      zlib.createGzip(),
      fs.createWriteStream("The.Matrix.1080p.mkv.gz")
    );
    console.log("Pipeline succeeded");
  } catch (err) {
    console.error("Pipeline failed", err);
  }
}
```
