# Node Util Module

```js
import * as stream from 'stream';
const finished = util.promisify(stream.finished);
const pipeline = util.promisify(stream.pipeline);
```

# util.inspect

- [Node](https://nodejs.org/api/util.html#utilinspectobject-options)
- inspect objects.
- `console.log(util.inspect(obj, { showHidden: true, depth: null }));`
- `console.log(util.inspect(obj, { compact: true, depth: 5, breakLength: 80 }));`
