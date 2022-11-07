# Errors

### Global Handling Middleware

- express see's four parameters in route and knows it's error handling function.
- <https://expressjs.com/en/guide/error-handling.html>

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
