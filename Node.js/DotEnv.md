# ENV

- No need to wrap your variable value in single or double quotes, unless it has special characters.
  - .env variables are strings.
  - if something special about variable, need to single quote it. // **$ is special.**
  - https://stackoverflow.com/questions/31552125/defining-an-array-as-an-environment-variable-in-node-js
- Do not put semicolon `;` or comma `,` at the end of each line.
- Env file has to be in root directory.
- [NPM](https://www.npmjs.com/package/dotenv)
- `npm i -D dotenv` // typescript built in.
- restart server after changes to .env

**.env comment**

- `# this is a comment`

**.env**

```txt
KEY=some-key
INDEX=someThing
```

**app.js**

```js
const path = require("path");
// commonjs
require("dotenv").config();
// or
require("dotenv").config({ path: path.join(__dirname, "../.env") });
// or
if (process.env.NODE_ENV !== "production") require("dotenv").config();

// ES6
import "dotenv/config"; // I like this one.
// or;
import dotenv from "dotenv";
dotenv.config();

// use the hidden variable
process.env.KEY; // 'some-key'

// Array
// .env
DB_HOST = "localhost,0.0.0.0,127.0.0.1";
// app.js
process.env.DB_HOST.split(","); //turns into an array.
```

## Create react app

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
