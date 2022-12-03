# Package.json

## Tutorial

- [Package.json Basics](https://nodesource.com/blog/the-basics-of-package-json)
- [find like packages](https://pickbetterpack.com/)

```json
{
  "alias": {
    "#components": "./src/components"
  }
}
```

**index.js**

- `import Button from '#components/shared/Button'`

**Create React App**
https://stackoverflow.com/questions/63067555/how-to-make-an-import-shortcut-alias-in-create-react-app

```sh
npm install @craco/craco --save
```

**craco.config.js**

```js
const path = require(`path`);

module.exports = {
  webpack: {
    alias: {
      '@': path.resolve(__dirname, 'src/'),
      '@Components': path.resolve(__dirname, 'src/components'),
      '@So_on': path.resolve(__dirname, 'src/so_on'),
    },
  },
};
```

[**jsconfig.json**](https://dev.to/mr_frontend/absolute-imports-in-create-react-app-3ge8)

```json
{
  "compilerOptions": {
    "baseUrl": "src"
  },
  "include": ["src"]
}
```

## Typescript

**tsconfig.json**

```json
"compilerOptions": {
    "baseUrl": "src",
}
"include": ["src"],
```

**package.json**

- `npm start`
- `npm run build`

```json
"scripts": {
    "start": "ts-node ./src/index.ts",
    "build": "tsc-watch --onsuccess \"node dist/index.js\"",
    "dev": "NODE_ENV=development nodemon ./server.ts",
    // nodemon run only production code.
    "compile": "tsc -p . && node build/server.js",
    "dev": "nodemon -e ts --exec \"npm run compile\"",
    // easier. tsconfig.json 'outDir: ./build'. Must install tsc-watch -g.
    "start": "tsc-watch --onSuccess \"node ./build/server.js\"",
},
```

Typescript way of exporting is no default exports. To reference anything you can do: import { Todo } from 'action'
action //folder structure
|- index.ts
|- todos.ts
|- types.ts
action/index.ts
export _ from './todos'
export _ from './types'
action/todos.ts
import axios from 'axios'
import { Dispatch } from 'redux'
import { ActionTypes } from './types'

export interface Todo { ... }
export interface FetchTodosAction { ... }
export interface DeleteTodoAction { ... }
export const fetchTodos = () => { ... }
export const deleteTodo = (id: number): DeleteTodoAction => { ... }
action/types.ts
export enum ActionTypes { ... }

## Scripts

- Quick little NPM protip: you can create pre-run scripts by using the pre prefix. When I run npm run build or yarn build, it will automatically run the prebuild script first, if defined. You can also run scripts afterwards with the post prefix.

```json
"scripts": {
  "prebuild": "echo I run before the build script",
  "build": "cross-env NODE_ENV=production webpack",
  "postbuild": "echo I run after the build script"
}
```

**Run two scripts same time.**

- `npm i -D concurrently`

```json
"scripts": {
  "start:build": "tsc -w",
  "start:run": "nodemon build/index.js",
  "start": "concurrently npm:start:\*"
},
```
