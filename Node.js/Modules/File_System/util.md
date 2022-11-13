# Node Util Module

```js
import * as stream from 'stream';
const finished = util.promisify(stream.finished);
const pipeline = util.promisify(stream.pipeline);
```

# util.inspect

- [Node](https://nodejs.org/api/util.html#utilinspectobject-options)
- inspect objects.

```js
import { inspect } from 'node:util';
console.log(inspect(obj, { showHidden: true, depth: null }));
console.log(inspect(obj, { compact: true, depth: 5, breakLength: 80 }));
```
