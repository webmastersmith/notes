# ENV

- No need to wrap your variable value in single or double quotes, unless it has special characters.
- Do not put semicolon ; or comma , at the end of each line.

**.env**

```txt
KEY=some-key
INDEX=someThing
```

**index.js**

```js
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "../.env") });

`${process.env.KEY}`;
```

**.env comment**

- `# this is a comment`

**dotenv**

- https://www.npmjs.com/package/dotenv
- `npm i dotenv` //is already type scripted.
  - restart server after changes to .env
- https://stackoverflow.com/questions/31552125/defining-an-array-as-an-environment-variable-in-node-js
  .env variables are strings.
  if something special about variable, need to single qoute it. // $ is special.
  server.js
  require('dotenv').config()
  or
  if (process.env.NODE_ENV !== 'production') require('dotenv').config()
  .env
  DB_HOST=localhost
  App.js
  process.env.DB_HOST

//array
DB_HOST="localhost, 0.0.0.0, 127.0.0.1"
process.env.DB_HOST.split(',') //turns into an array.

## ES6

```ts
import "dotenv/config"; //like this one.
or;
import dotenv from "dotenv";
dotenv.config();
```

**Create react app**

- Three things to note here
  1. the variable should be prefixed with REACT*APP*
     1. eg: `REACT_APP_NAME=hello`
  2. You need to restart the server to reflect the changes.
  3. Make sure you have the .env file in your root folder(same place where you have your package.json) and NOT in your src folder.

After that you can access the variable like this: `process.env.REACT_APP_SOME_VARIABLE`

**Environment Variables internal to create-react-app**

- `development`
- `production`

```js
if (process.env.NODE_ENV === 'development') {
 do something...
}
```

**CORS**

- https://www.npmjs.com/package/cors
