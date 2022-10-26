# Process

**process.argv**

- `node arguments.js hello world` // from the cmd line.

arguments.js

```js
console.log(process.argv.slice(2)); // output will be ['hello', 'world']
```

stdout

```js
['/usr/bin/node', '/home/sammy/first-program/arguments.js', 'hello', 'world'];
```

# Enviroment Variables

**process.env**

- returns object with all system environment variables inside.
- `process.env[key]` // returns undefined if not found

environment.js

```js
console.log(process.env); // outputs all environment variables.
console.log(process.env['PWD']); // returns value as a string
```

**Add env**

```js
process.env.UV_THREADPOOL_SIZE = 4; // default
```

### Express

- default Express starts in `development` mode.
- change to `production` when in production

**package.json**

```json
{
  "dev": "NODE_ENV=development nodemon ./server.ts",
  "prod": "NODE_ENV=production nodemon ./server.ts"
}
```

# exec

-[exec](https://www.freecodecamp.org/news/node-js-child-processes-everything-you-need-to-know-e69498fe970a/)

- [Nodejs](https://nodejs.org/api/child_process.html)
