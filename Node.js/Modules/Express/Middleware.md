# Express Middleware

- function that's executed after request, before response.
- where it's at in the code (before route or after route), determines when it will be called.
  - if at top level, will be called with each request.
- `next()` must be called at the end of each middleware function.

**Middleware**

- [Express Middleware](https://expressjs.com/en/resources/middleware.html)

**Middleware Stack** (Pipeline)

- all middleware combined.
- order in code is the order executed.

**Custom Middleware**

- you have access to request/response object and next function.
- [Extending Types](https://dev.to/kwabenberko/extend-express-s-request-object-with-typescript-declaration-merging-1nn5)
- [Generics](https://javascript.plainenglish.io/typed-express-request-and-response-with-typescript-7277aea028c)

```ts
// custom middleware
app.use((req: Request, res: Response, next: NextFunction) => {
  console.log("hello from middleware 😎");
  return next();
});

// custom Request type
// @types/Express/index.d.ts -in root directory
declare namespace Express {
  export interface Request {
    requestTime?: string;
  }
}
// tsconfig.json
"typeRoots": [
  "@types",
  "./node_modules/@types"
]
// app.ts
app.use((req: Request, res: Response, next: NextFunction) => {
  req.requestTime = new Date().toISOString();
  return next();
});

```

**BodyParser**

- built into express
- [API](https://expressjs.com/en/api.html)

```js
// json
// curl -i -d '{ "username": "bob", "password":"secret", "website": "stack.com" }' -X POST http://localhost:8080/api/v1/tours -H 'content-type:application/json'
app.use(express.json());

// url
// curl -i -d "username=bob&password=secret&website=stack.com" -X POST http://localhost:8080/ -H 'content-type:text/plain'
app.use(express.urlencoded({ extended: true }));

console.log(req.body); //{key: value}
```
