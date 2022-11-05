# Mongoose

- [NPM](https://www.npmjs.com/package/mongoose)
- [Docs](https://mongoosejs.com/docs/guide.html)-
- Mongoose is ORM (Object Data Modeling). Sits on top of MongoDB.

# Schema Types

- [Mongoose Schema Types](https://mongoosejs.com/docs/schematypes.html)
- String, Buffer, Boolean, Mixed, ObjectId, Array, Map
- Number // { type: Number, min: 18, max: 65 }, // Number can be a float so must use logic to make it an integer. [`Math.round(v)`]()
- Date, // { type: Date, default: Date.now },
- Decimal128, // same as MongoDB NumberDecimal. Used for floats and currency.

```ts
const tourSchema = new mongoose.Schema({
  name: String, // shorthand for { type: String }
  price: {
    type: Number,
    require: true,
  },
});
```

# Start

**index.ts**

```ts
import 'dotenv/config';
import mongoose from 'mongoose';

(async function () {
  const db = await mongoose.connect(`${process.env.MONGO_LOGIN}`);
  try {
  } catch (e) {
    if (e instanceof Error) {
      console.log(e.message);
    } else {
      console.log(String(e));
    }
  } finally {
    // db.disconnect(); // for http servers stays running to validate api request.
    // console.log('Closed Client');
  }
})();
```

# Validators

- [Mongoose](https://mongoosejs.com/docs/validation.html)

# Methods

**Count**

- `await .count()`

**Get All**

- `await SchemaName.find()`
- returns array of objects.

**Find**

- `findById(id).exec()` // `.exec()` turns query into real Promise.
  - returns one.
  - same as mongo findOne()
- [`find({}).exec()`](https://mongoosejs.com/docs/api.html#model_Model-find) // the `.exec()` turns query into a real `Promise`. Use it when querying.
  - [without `.exec()`](https://mongoosejs.com/docs/queries.html#queries-are-not-promises)

# Query Casting

- <https://mongoosejs.com/docs/api/query.html>
- <https://mongoosejs.com/docs/tutorials/query_casting.html>

**Sort**

# Virtuals

- cannot use virtuals in a query, because not in mongo database.

```ts
import { Schema, model } from 'mongoose';
const tourSchema = new Schema(
  {
    name: {
      type: String,
      required: [true, 'Name is required.'],
      unique: true,
      trim: true,
    },
    duration: {
      type: Number,
      required: [true, 'Duration is required.'],
    },
  },
  {
    toJSON: { virtuals: true }, // will exist on output only, not in database.
    toObject: { virtuals: true }, // if output is object or json.
  }
);

tourSchema.virtual('durationWeeks').get(function () {
  return this.duration / 7;
});

export const Tour = model('Tour', tourSchema);
```
