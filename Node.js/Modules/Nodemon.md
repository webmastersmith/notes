# Nodemon

- `npm install -D nodemon`
- [TypeScript](https://blog.logrocket.com/configuring-nodemon-with-typescript/)

```json
"script" {
  "dev": "nodemon",  // automatically picks up .ts, .js files from src/
  "ts-dev1": "npx nodemon ./main.ts",  // for typescript.
  "ts-dev2": "nodemon ./main.ts",  // don't need npx for typescript.
  "dev": "nodemon --watch "*.ts" --exec "ts-node" ./src/index.ts",
  "dev2": "nodemon --watch "*.ts"  --watch "*.json" --exec "ts-node" ./src/index.ts"
}
```
