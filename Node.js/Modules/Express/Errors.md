# Errors

### Global Handling Middleware

- express see's four parameters in route and knows it's error handling function.
- <https://expressjs.com/en/guide/error-handling.html>

### Express Async Errors

- by default **async functions** will have to have the `next(err)` called.
- to use the synchronous error handling `throw new CustomError('some message')`, use **express-async-errors**.
  - <https://www.npmjs.com/package/express-async-errors>

**Wrapper fn**

```ts
import express from 'express';
import 'express-async-errors'; // that's it. call from top level. now you can use 'throw new error()' inside async functions.

// all errors will automatically bubble up to next(err)
const use =
  (fn: any) =>
  (req: Request, res: Response, next: NextFunction): Promise<Router> =>
    Promise.resolve(fn(req, res, next)).catch(next);
// all routes use this
app.use('/api/v1/users', use(usersRouter));
```

**index.ts**

```ts
app.use((err, req, res, next) => {
  err.statusCode = err.statusCode || 500;
  err.message = err.message || 'error';

  res.status(err.statusCode).json({
    status: 'error',
    results: 0,
    data: err.message,
  });
});
```

```ts
class CustomError extends Error {
  constructor(msg: string) {
    super(msg);

    // Set the prototype explicitly.
    Object.setPrototypeOf(this, FooError.prototype);
  }

  sayHello() {
    return 'hello ' + this.message;
  }
}

// Then you can use:
let error = new CustomError('Something really bad went wrong');
if (error instanceof CustomError) {
  console.log(error.sayHello());
}

// Another Example with Express
interface ErrorType extends Error {
  status: string;
  statusCode: number;
  message: string;
}
export default class ExpressError extends Error implements ErrorType {
  status: string;
  statusCode: number;
  isOperational: boolean;
  constructor(statusCode: number, msg: string) {
    super(msg);
    this.statusCode = statusCode;
    this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
    // to determine if Error came from this special class or another error in the system.
    this.isOperational = true;

    // Stack Trace -to use console.log(err.stack)
    Error.captureStackTrace(this, this.constructor);
  }
}
// all unhandled routes -if placed at top of list, would always match route.
app.all('*', (req: Request, res: Response, next: NextFunction) => {
  // if something passed into next(), express automatically knows it's an error.
  next(new ExpressError(404, `Cannot find ${req.originalUrl}`));
});

// automatic express error handling middleware.
// 4 parameters means error handling middleware.
app.use(
  (err: ExpressError, req: Request, res: Response, next: NextFunction) => {
    err.statusCode = err.statusCode || 500;
    err.status = err.status || 'error';
    err.message = err.message || 'unknown error';

    res.status(err.statusCode).json({
      status: err.status,
      message: err.message,
    });
  }
);
```

### Stephen Grinder

**error.ts**

```ts
import { Request, Response, NextFunction } from 'express';
import { ValidationError } from 'express-validator';

export const httpStatusCodes = {
  OK: 200,
  BAD_REQUEST: 400,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  INTERNAL_SERVER: 500,
  SERVICE_UNAVAILABLE: 503,
};

// this will keep enforcing error schema after TS is translated.
abstract class CustomError extends Error {
  abstract statusCode: number;
  constructor(message: string) {
    super(message);
    // https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-2.html#example
    // this allows 'instanceof' to correctly identify between Error and YourErrorName.
    // all extended classes will correctly identify with this code.
    Object.setPrototypeOf(this, new.target.prototype);
  }
  abstract serializeErrors(): { msg: string; field: string }[];
}

export class RequestValidationError extends CustomError {
  constructor(
    public statusCode: number = httpStatusCodes.BAD_REQUEST,
    public errors: ValidationError[]
  ) {
    super('Express-Validator Error.');
  }

  serializeErrors() {
    return this.errors.map((e) => ({
      msg: e.msg,
      field: e.param,
    }));
  }
}

export class DatabaseError extends CustomError {
  constructor(public statusCode: number = httpStatusCodes.INTERNAL_SERVER) {
    super('Database Connection Error');
  }
  serializeErrors() {
    return [
      {
        msg: this.message,
        field: 'Database Error',
      },
    ];
  }
}

export const errorHandler = (
  err: RequestValidationError | DatabaseError | Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (err instanceof CustomError)
    return res.status(err.statusCode).json({ errors: err.serializeErrors() });

  // generic error
  res.status(httpStatusCodes.BAD_REQUEST).json({
    errors: [
      {
        msg: err.message,
        field: 'error',
      },
    ],
  });
};

// to use
return next(new RequestValidationError(400, errors.array()));
return next(new DatabaseError(500));
return next(new Error('Something went wrong :-('));
```

**index.ts**

- errorHandler is added last in the routes. This is because no other route should be used when called.
- It is automatically called when you use `next(err)`.

```ts
// other code
app.use(errorHandler);

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at https://localhost:${port}`);
});
```

# Try Catch

- Higher Order function to cut down try catch blocks.

```ts
const catchErrors = (
  errorCode: number,
  fn: (req: Request, res: Response, next: NextFunction) => Promise<void>
) => {
  return function (req: Request, res: Response, next: NextFunction) {
    fn(req, res, next).catch((e) => {
      if (e instanceof Error) {
        next(new ExpressError(errorCode, e.message));
        // console.log(e.message);
      } else {
        console.log(String(e));
      }
    });
  };
};

// then use it
export const createTour = catchErrors(
  400,
  async (req: Request, res: Response, next: NextFunction) => {
    await Tour.create(req.body);
    res.status(201).json({
      status: 'success',
      results: await Tour.count(),
      data: `${req.body?.name ?? 'Tour'} successfully added.`,
    });
  }
);
```
