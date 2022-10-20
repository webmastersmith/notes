# Modules Import Export

# Module

- In JavaScript, every file is a module.

```js
module.exports = () => {};
```

- https://magnusbenoni.com/javascript-export-import/
- https://developer.mozilla.org/en-US/docs/web/javascript/reference/statements/export
- https://www.sitepoint.com/understanding-module-exports-exports-node-js/

## CommonJS // node default

- https://www.sitepoint.com/understanding-module-exports-exports-node-js/
- solves the problem of global variables.
- created for the server. Allowed for NPM. Sharing your modules.
- code is run syncronous. Runs line by line, blocking other code until parsed.

**module.exports**

- you can only have one module.exports, to use many exports turn into object:
- do not mix with plain exports.

```js
module.exports = { name, names, add, dateOfBirth as dob }   //const user = require('./users')    //user.name
// destructure
const { name, names, add, dob } = require('./someFile')

module.exports = (arg1, arg2) => { console.log('this is an anonymous function') }; // const myFunc = require('./filePath/myFunc') //.js not needed.

module.exports = fn1
const fn1 = require('./someFile')

module.exports.fA = favoriteAuthor;
module.exports.fB = favoriteBook;
module.exports.getBook = getBookRecommendations;
const {fA, fB, getBook as gB} = require('someFile')

// reference item in module exports object
module.exports = {
  list: {
    a: 1,
    b: 2
  }
  addFunc: () => {module.exports.list.a + module.exports.list.b}
}
const myList = require('./someFile')
myList.list.a  //1
myList.addFunc()  //3
```

**exports**

```js
exports.getName = getName;
exports.dob = dateOfBirth;
const { getName, dob } = require('./someFile');

// Class export
class Color {
constructor(name, code) {
this.name = name;
this.code = code;
}
}
const allColors = [
new Color('brightred', '#E74C3C'),
new Color('soothingpurple', '#9B59B6'),
new Color('skyblue', '#5DADE2'),
new Color('leafygreen', '#48C9B0'),
new Color('sunkissedyellow', '#F4D03F'),
new Color('groovygray', '#D7DBDD'),
];
exports.getRandomColor = () => {
return allColors[Math.floor(Math.random() * allColors.length)
}
exports.allColors = allColors;
```

**UMD (Universal Module Definition)**

- https://github.com/umdjs/umd

**AMD (asyncronous module definition)**

- created for browser. Loads modules asynchronously

```js
define([module1, module2], function (module1Import, module2Import) {
  var module1 = module1Import;
  var module2 = module2Import;
  function fn1() {}
  return { fn1: fn1 };
});
```

## ES6 modules -JavaScripts first native module system

- ES6 modules must be served from a server -live-server, http-server, ...
- to use es6 in node
  - `package.json: "type":"module",`
  - `name file.mjs`

**TypeScript**

- Typescript way of exporting is no default exports.
  - To reference anything you can do: `import { Todo } from 'action'`

tsconfig.json

```ts
"compilerOptions": {
    "baseUrl": "src",
}
"include": ["src"],
```

action //folder structure
|- index.ts
|- todos.ts
|- types.ts

action/index.ts

```js
export * from "./todos";
export * from "./types"; //this will export all in folder.
```

action/todos.ts

```js
import axios from 'axios'
import { Dispatch } from 'redux'
import { ActionTypes } from './types'

export interface Todo { ... }
export interface FetchTodosAction { ... }
export interface DeleteTodoAction {  ... }
export const fetchTodos = () => { ... }
export const deleteTodo = (id: number): DeleteTodoAction => { ... }
```

action/types.ts

```js
export enum ActionTypes { ... }
```

Path: Post/index.js
index.js
export {default } from './Post.js'
or
export \* from './Post.js'
add index.js file at every stage and you can import {app} from 'components'.
jsconfig.json
{
"compilerOptions": {
"baseUrl": "src"
},
"include": ["src"]
}

## Import ES6

- All import names must be inside curly braces excpet default names.
- index.html must have the type='module', can be declared as src='./someFileName' or inside the script tag.
- must have the absoute path declared: './someFileName'

```js
// import everything
import * as fs from "fs";

// import named exports
import { readFileSync } from 'fs'
import defaultExport, { function1, function2 } from './module1'
import { someFuncName, someClassName } from './someFileName'  //do not need extension of file.
import anyName, {fn1 as fn} from 'defaultFileLocation'
import * as f from './someFileName'  // wildcard that imports everything.  f.fn1()

// index.html file:
<script type='module'> import { fn1, fn2 as fn } from './someFileName' </script>
or
<script type='module' src='./someFileName'> </script>
```

## Export ES6

- You can export any top-level function, class, var, let, or const.
- Since the code is a module, not a script, all the declarations will be scoped to that module, not globally visible across all scripts and modules.
- An export list doesn’t have to be the first thing in the file; it can appear anywhere in a module file’s top-level scope.
- can only be one export default.

**Default export**

```js
export default someFuncName //import someFuncName from './ file'
export default [ {obj1}, {obj2}, ... ]
export default car = 'Volvo'
export default obj

// named exports
export function someFuncName() //import {someFuncName} from './file'
export class someClassName {}

export {someFuncName, someClassName};

// rename them as export
export { someFuncName as fn, someClassName as cl }
```
