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

# Model

- The Schema with methods wrapped up in a 'Document'.

```ts
import { Schema, model, QueryOptions } from 'mongoose';

export interface UserType {
  _id: string;
  name: string;
  role: 'user' | 'guide' | 'lead-guide' | 'admin';
  active: boolean;
  hasPasswordChanged: (jwtTimestamp: number) => Promise<boolean>;
}

const userSchema = new Schema<UserType>(
  {
    // attach type here.
    name: {
      type: String,
      required: [true, 'Name is required.'],
      unique: true,
      trim: true,
      maxLength: [40, 'User name cannot be over 40 characters.'],
      minLength: [3, 'User name cannot be less than 3 characters.'],
      validate: {
        validator: function (val: string) {
          // 'this' is the User object
          return validator.isAlphanumeric(val, 'en-US', { ignore: ' .' });
        },
        message: (props: { value: string }) =>
          `${props.value} can only contain numbers and letters.`,
      },
    },
    role: {
      type: String,
      enum: ['user', 'guide', 'lead-guide', 'admin'], // only valid values.
      default: 'user',
    },
    active: {
      type: Boolean,
      default: true,
      select: false, // don't show this field to client.
    },
    guides: [{ type: mongoose.Types.ObjectId, ref: 'User' }], // reference to 'User' Model.
  },
  {
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  }
);
// perform function only on output results.
tourSchema.virtual('yourMadeUpKeyName').get(function () {
  return this.duration / 7;
});

// attach method to document
userSchema.methods.hasPasswordChanged = async function (
  jwtTimestamp: number
): Promise<boolean> {
  return true;
};
// check for password change
userSchema.pre('save', async function (next) {
  // if password not modified, just return.
  if (!this.isModified('password')) return next();
  return next();
});
// populate any tour find query with 'guides'
tourSchema.pre(/^find/, function (next) {
  // 'this' points to what was passed in.
  this.populate({ path: 'guides', select: '-__v -passwordChangedAt' });
  return next();
});

export const User = model('User', userSchema);
```

# Validators

- [Mongoose](https://mongoosejs.com/docs/validation.html)
- validation is done by 'type' unless custom validator is called.

**Custom Validators**

```ts
const tourSchema = new Schema({
  name: {
    type: String,
    required: [true, 'Name is required.'],
    unique: true,
    trim: true,
    maxLength: [40, 'Tour name cannot be over 40 characters.'],
    minLength: [10, 'Tour name cannot be less than 10 characters.'],
    validate: {
      validator: function (val: string) {
        // console.log(this) // logs 'tourSchema' object
        return validator.isAlphanumeric(val, 'en-US', { ignore: ' ' });
      },
      message: (props: { value: string }) =>
        `${props.value} can only contain numbers and letters.`,
    },
  },
  email: {
    type: String,
    maxLength: [40, 'Email cannot be over 40 characters.'],
    minLength: [3, 'Valid email cannot be less than 3 characters.'],
    validate: {
      validator: validator.isEmail,
      message: (props: { value: string }) =>
        `${props.value} is not a valid email.`,
    },
  },
});
```

# Methods

**Count**

- `await .count()`

**Get All**

- `await SchemaName.find()`
- returns array of objects.

## Create

- <https://mongoosejs.com/docs/api/model.html#model_Model-create>
- `Model.create({})` inserts a document.

## Indexes

- <https://mongoosejs.com/docs/guide.html#indexes>
- <https://mongoosejs.com/docs/api/schema.html#schema_Schema-index>

```ts
const animalSchema = new Schema({
  name: String,
  type: String,
  tags: { type: [String], index: true }, // path level
});

animalSchema.index({ name: 1, type: -1 }); // schema level
```

## Find

- returns `results` or `null`
- `findById(id).exec()` // `.exec()` turns query into real Promise.
  - returns one.
  - same as mongo findOne()
- `Model.findByIdAndUpdate(id, {key: value})`
- [`find({}).exec()`](https://mongoosejs.com/docs/api.html#model_Model-find) // the `.exec()` turns query into a real `Promise`. Use it when querying.
  - [without `.exec()`](https://mongoosejs.com/docs/queries.html#queries-are-not-promises)
- `User.findOne({ email: 'bob50@gmail.com' });` // returns user or null

**Keep fields from showing in results**

```ts
const userSchema = new Schema<UserType>({
  password: {
    type: String,
    select: false, // prevents field from showing in results
  },
});

// to see field.
const user = await user.findOne({ email }).select('+password').exec();
```

# Query Casting

- <https://mongoosejs.com/docs/api/query.html>
- <https://mongoosejs.com/docs/tutorials/query_casting.html>

**Sort**

# Virtuals

- cannot use virtuals in a query, because not in mongo database.
- virtuals attach output to query. 'virtual functions' add a 'key' then value to output.

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

# Populate

- when a query is done, take id from array, then match them to other collections. Return results all together. Same as embedding a subDocument in the db, without having duplicate code.

```ts
// TourSchema
guides: [{ type: mongoose.Types.ObjectId, ref: 'User' }], // reference the ObjectId of 'User' collection.
  // pre
  // attach populate the 'guides' on any tour find query.
  tourSchema.pre(/^find/, function (next) {
    // 'this' points to current document.
    this.populate({ path: 'guides', select: '-__v -passwordChangedAt' });
    return next();
  });

// tourController.ts
export const getTourById = catchAsync(
  404,
  async (req: Request, res: Response, next: NextFunction) => {
    // returns tour or null
    const tour = await Tour.findById(req.params.id).exec();
    if (!tour) {
      throw new ExpressError(`Tour ${req.params.id} not found :-(`);
    }

    res.status(200).json({
      status: 'success',
      results: 1,
      data: tour,
    });
  }
);
```
