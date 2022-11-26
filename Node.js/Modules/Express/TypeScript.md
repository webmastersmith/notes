# Express TypeScript

## Setup

- <https://blog.logrocket.com/how-to-set-up-node-typescript-express/>

```bash
npm init -y && npm i express cors axios dotenv && npm i -D nodemon @types/express @types/node @types/cors && npx tsc --init
```

**package.json**

```json
  "scripts": {
    "dev": "NODE_ENV=development nodemon server.ts",
    "prod": "NODE_ENV=production nodemon server.ts"
  },
```

**server.ts**

```ts
import express, { Express, Request, Response } from 'express';
import 'dotenv/config';

const app: Express = express();
const port = process.env.PORT;

app.get('/', (req: Request, res: Response) => {
  res.send('Express + TypeScript Server');
});

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at https://localhost:${port}`);
});
```

## Extending Request Method

1. (root directory) touch2 -p @types/Express/index.d.ts

```ts
declare namespace Express {
  export interface Request {
    requestTime?: string;
  }
}
```
