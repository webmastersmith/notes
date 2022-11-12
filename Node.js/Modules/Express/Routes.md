# Express Routes

- [Express Routes](https://expressjs.com/en/guide/routing.html)

## CatchAll Route

- `app.all()` // matches all http methods: get, post, delete, put, patch...

```ts
// all unhandled routes -if placed at top of list, all routes would match wildcard.
app.all('*', (req: Request, res: Response) => {
  res.status(404).json({
    status: 'error',
    results: 0,
    data: `Cannot find ${req.originalUrl}`,
  });
});
```

## Simple Routing

- [res.send](https://expressjs.com/en/api.html#res.send)

```ts
import 'dotenv/config';
import fs from 'fs';
import express, { Request, Response, NextFunction } from 'express';

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const getAllTours = (req: Request, res: Response) => {
  // res.status(200).send('<p>some html</p>')
  res.status(200).json({ status: 'success', data: { tours } });
};

app.route('/api/v1/tours').get(getAllTours).post(createTour);

app
  .route('/api/v1/tours/:id')
  .get(getTour)
  .patch(updateTour)
  .delete(deleteTour);

app.listen(process.env.PORT, () => {
  console.log(`App running on port ${process.env.PORT}...`);
});
```

## Advanced Routing

1. create the route middleware
2. use the route

**views/app.ts**

```ts
import 'dotenv/config';
import express, { Request, Response, NextFunction } from 'express';
import morgan from 'morgan';
import tourRouter from './tourRoutes';
import userRouter from './userRoutes';
import reviewRouter from './reviewRoutes';
import ExpressError from '../utils/Error_Handling';
import MainErrorHandler from '../controllers/errorController';
import { rateLimit } from 'express-rate-limit';
import helmet from 'helmet';
import mongoSanitize from 'express-mongo-sanitize';
import xss from 'xss-clean';
import hpp from 'hpp';
import cookieParser from 'cookie-parser';

const app = express();

// Middleware
app.use(helmet());
// Apply the rate limiting middleware to all requests
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
  standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
  legacyHeaders: false, // Disable the `X-RateLimit-*` headers
});
app.use('/api', limiter);
// Body Parser
app.use(express.json({ limit: '10kb' }));
app.use(express.urlencoded({ extended: true }));

// Data Sanitize nosQL query injection
app.use(
  mongoSanitize({
    replaceWith: '_',
  })
);
// Data Sanitize XSS
app.use(xss());
// Parameter Pollution
app.use(hpp());

// static content
app.use(express.static(`${process.cwd()}/public`));

// cookies
app.use(cookieParser());

if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

// custom middleware
app.use((req: Request, res: Response, next: NextFunction) => {
  req.requestTime = new Date().toISOString();
  console.log(req.headers);
  return next();
});

// ROUTES
// Tours
app.use('/api/v1/tours', tourRouter);
// Users
app.use('/api/v1/users', userRouter);
// reviews
app.use('/api/v1/reviews', reviewRouter);

// all unhandled routes -if placed at top of list, would always match route.
app.all('*', (req: Request, res: Response, next: NextFunction) => {
  // if something passed into next(), express automatically knows it's an error.
  next(new ExpressError(404, `Cannot find ${req.originalUrl}`));
});

// error handling middleware
app.use(MainErrorHandler);

export default app;
```

**views/userRoutes**

```ts
import express from 'express';
import {
  getAllUsers,
  getUser,
  updateUser,
  deleteUser,
} from '../controllers/userController';
import {
  signup,
  login,
  forgotPassword,
  resetPassword,
  updatePassword,
  protect,
  approvedRoles,
} from '../controllers/authController';

// Users
const router = express.Router();
// signup
router.route('/signup').post(signup);
// login
router.route('/login').post(login);
// forgotPassword
router.route('/forgotPassword').post(forgotPassword);
// resetPassword
router.route('/resetPassword/:token').patch(resetPassword);
// updatePassword logged in user.
router.route('/updatePassword').patch(protect, updatePassword);
// update user info
router
  .route('/updateMe')
  .patch(protect, updateUser)
  .delete(protect, deleteUser);

// get all Users -admin only
router.route('/').get(protect, approvedRoles('admin'), getAllUsers);

// updateUser Info
router
  .route('/:id')
  .get(protect, approvedRoles('admin'), getUser)
  .patch(protect, approvedRoles('admin'), updateUser)
  .delete(protect, approvedRoles('admin'), deleteUser);

export default router;
```

## Query String

- `req.query` // http://someWebSite.com/api/v1/tours?duration=5&difficulty=easy
  - `{ duration: '5', difficulty: 'easy' }`

## Params

- run before request is given to handlers.

```ts
// tourController.ts
export const checkId = (
  req: Request,
  res: Response,
  next: NextFunction,
  value: string // same as req.params.slugName
) => {
  const id = +value;
  if (tours.findIndex((el: Data) => el.id === id) < 0) {
    return res.status(404).json({
      status: 'error',
      data: 'ID not found',
    });
  }
  return next();
};

// tours.ts
const router = express.Router();
router.route('/').get(getAllTours).post(createTour);
// all :id routes will be checked for valid id before continuing.
router.param('id', checkId);
router.route('/:id').get(getTour).patch(updateTour).delete(deleteTour);
export default router;
```

## Static Files

- anything inside the `public` that is asked for will be served.

```ts
app.use(express.static(process.cwd() + '/public')); // http://127.0.0.1:8080/img/pin.png
```
