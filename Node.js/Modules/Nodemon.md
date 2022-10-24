# Nodemon

- `npm install -D nodemon`
- [TypeScript](https://blog.logrocket.com/configuring-nodemon-with-typescript/)

```json
"script" {
  "dev": "nodemon",  // automatically picks up .ts, .js files from src/
  "ts-dev1": "npx nodemon ./main.ts",  // for typescript.
  "ts-dev2": "nodemon ./main.ts"  // don't need npx for typescript.
}
```
