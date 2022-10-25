# Express Routes

- [Express Routes](https://expressjs.com/en/guide/routing.html)

## Simple Routing

```ts
import "dotenv/config";
import fs from "fs";
import express, { Request, Response, NextFunction } from "express";

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const getAllTours = (req: Request, res: Response) => {
  res.status(200).json({ status: "success", data: { tours } });
};

app.route("/api/v1/tours").get(getAllTours).post(createTour);

app
  .route("/api/v1/tours/:id")
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

```ts
// Users
import express, { Request, Response, NextFunction } from "express";

const router = express.Router();
router.route("/").get(getAllUsers).post(createUser);
router.route("/:id").get(getUser).patch(updateUser).delete(deleteUser);

export default router;
```

## Params

- run before request is given to handlers.

```ts
// tourController.ts
export const checkId = (
  req: Request,
  res: Response,
  next: NextFunction,
  value: string
) => {
  const id = +value;
  if (tours.findIndex((el: Data) => el.id === id) < 0) {
    return res.status(404).json({
      status: "error",
      data: "ID not found",
    });
  }
  return next();
};

// tours.ts
const router = express.Router();
router.route("/").get(getAllTours).post(createTour);
// all :id routes will be checked for valid id before continuing.
router.param("id", checkId);
router.route("/:id").get(getTour).patch(updateTour).delete(deleteTour);
export default router;
```

## Static Files

- anything inside the `public` that is asked for will be served.

```ts
app.use(express.static(process.cwd() + "/public")); // http://127.0.0.1:8080/img/pin.png
```
