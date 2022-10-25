# Express Routes

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
const tourRouter = express.Router();
app.use("/api/v1/tours", tourRouter);
tourRouter.route("/").get(getAllTours).post(createTour);
tourRouter.route("/:id").get(getTour).patch(updateTour).delete(deleteTour);
```
