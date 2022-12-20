# Mongoose

- [NPM](https://www.npmjs.com/package/mongoose)
- [Docs](https://mongoosejs.com/docs/guide.html)-
- Mongoose is ORM (Object Data Modeling). Sits on top of MongoDB.
- Mongoose can also do schema validation, but may be easier to use a dedicated schema validation library like `joi`.

**Architecture**

- Schema is the Model
- Document is one Model filled with info.

**Best Practices**

- <https://climbtheladder.com/10-mongoose-best-practices/>

**Folders**

- model - where schema is stored
- controller - where route functions are stored
- routes - where routes are stored.

# About

- Mongoose is an object-document mapping (ODM) framework for Node.js and MongoDB.
  - Mongoose ensures your objects have the same structure in Node.js as they do when they're stored in MongoDB.
  - Mongoose validates your data, provides a middleware framework, and transforms vanilla JavaScript operations into database operations.
  - Mongoose provides middleware, custom validators, custom types, and other paradigms for code organization.
  - allows for MVC pattern, and sequel style request and schema structure.
- **Collections** - ‘Collections’ in Mongo are equivalent to tables in relational databases. They can hold multiple JSON documents.
- **Documents** - ‘Documents’ are equivalent to records or rows of data in SQL. While a SQL row can have reference to data in other tables, Mongo documents usually combine that in a document.
- **Fields** - ‘Fields’ or attributes are similar to columns in a SQL table.

**Model Class**

- The mongoose.model() function takes the model's name and schema as parameters, and **returns a class**. That class is configured to cast, validate, and track changes on the paths defined in the schema.
- A Mongoose model is a wrapper on the Mongoose schema. A Mongoose schema defines the structure of the document, default values, validators, etc., whereas a Mongoose model provides an interface to the database for creating, querying, updating, deleting records, etc.

**Document**

- instance of a model is called a document.
- There are two ways to create a Mongoose document:
  1.  you can instantiate a model to create a new `hydrated document`: `Model.create({})`
  2.  or you can execute a query to return a `hydrated document` from the MongoDB server.

**hydrated document** // instantiated Model (object) with mongoose methods attached.

# Events

- mongoose will publish events based on connection status.

```ts
mongoose.connection.on('connected', function () {
  console.log('Mongoose connected to ' + dbURI);
});

// We need to listen for changes in the Node process to deal with close events.
// To monitor when the application stops we need to listen to the Node.js
// process for an event called SIGINT.
// nodemon to automatically restart the application, then you’ll also have to listen to a
// second event on the Node process called SIGUSR2

// any index from unique ---------------------------------------------
const schema = new mongoose.Schema({
  name: { type: String, unique: true },
});
const Model = db.model('Test', schema);

Model.on('index', function (err) {
  // <-- Wait for model's indexes to finish
  assert.ifError(err);
  Model.create([{ name: 'Val' }, { name: 'Val' }], function (err) {
    console.log(err);
  });
});

// Promise based alternative. `init()` returns a promise that resolves
// when the indexes have finished building successfully. The `init()`
// function is idempotent, so don't worry about triggering an index rebuild.
Model.init().then(function () {
  Model.create([{ name: 'Val' }, { name: 'Val' }], function (err) {
    console.log(err);
  });
});
// or
await Model.init(); // allow for index to build, before creating first document.
const mod = await Model.create({});
```

# Schema Types

- [Mongoose Schema Types](https://mongoosejs.com/docs/schematypes.html)
- Array // `[String]`
- Boolean //
- Buffer // Buffer: A Node.js binary type (images, PDFs, archives, and so on)
- Date, // `{ type: Date, default:() => new Date() }`,
  - `() => new Date()` // this will get new Date() when create document.
- Decimal128, // same as MongoDB NumberDecimal. Used for floats and currency.
- Map
- Mixed // any type.
- Number // { type: Number, min: 18, max: 65 }, // Number can be a float so must use logic to make it an integer. `Math.round(v)`
- ObjectId // MongoDB 24-character hex string of a 12-byte binary number (e.g., 52dafa354bd71b30fa12c441)
- String //

```ts
const tourSchema = new mongoose.Schema({
  name: String, // shorthand for { type: String }
  price: {
    type: Number,
    require: true,
  },
  comments: [
    {
      text: String,
      postedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
      },
    },
  ],
});
```

# Start

**index.ts**

```ts
import 'dotenv/config';
import mongoose from 'mongoose';

(async function () {
  try {
    // with kubernetes
    const db = await mongoose.connect(
      `mongodb://root:password@mongo-src:27017/AuthDB`,
      { authSource: 'admin', w: 'majority', retryWrites: true }
    );

    // with external
    const db = await mongoose.connect(
      `mongodb://root:password@localhost:27017/AuthDB`,
      { authSource: 'admin', w: 'majority', retryWrites: true }
    );
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

# Schema Middleware

- <https://mongoosejs.com/docs/middleware.html#types-of-middleware>
- <https://javascripttricks.com/mongoose-middleware-the-javascript-7d23a96bfcbf>
- any request made through mongoose, you can intercept it, modify it, send it to database.
  - `pre` middleware has access to `this` -the document before saving to database.
  - `post` middleware has access to `doc` -the returned document.
- `next()` // will not stop code execution below it, in same code block.
  - does not 'return'.
- `pre | post`
  - pre & post must be defined before compiling 'model'.
  - pre // access document before saved to database.
  - post // access document after saved to database.

1. Document middleware

   1. pre & post
      1. `this` is the `HydratedDocument` with all methods & custom methods.
         1. <https://mongoosejs.com/docs/api/document.html>
   2. pre
      1. only parameter is `next()` `schema.pre('save', function(next) { next() })`
   3. `const myModel = this.constructor as Model<ModelType>`
      1. gives you access to Model methods, and your custom static methods.
      2. `const myReview = this.constructor as ModelInterfaceType;`
         1. `console.log(await myReview.staticMethodName());`
      3. ` console.log(await ModelName.staticMethodName());`
   4. post
      1. the first arg is the same as `this`. `schema.post('save', function(doc) { doc === this // true}`
      2. second arg is `next()`
   5. constructor
      1. gives you access to Model methods, and your custom static methods.
      2. `const myModel = this.constructor as Model<ModelType>`
         1. `const myReview = this.constructor as ModelInterfaceType;`
         2. `console.log(await myReview.staticMethodName());`
         3. ` console.log(await ModelName.staticMethodName());`
   6. methods
      1. `validate(), save(), remove(), updateOne(), deleteOne()`

2. Model middleware
   1. `insertMany()` static function on the model class
   2. `insertMany()` is a static function on the model class, whereas `save()` and `validate()` are methods on the model class.

```js
const schema = Schema({ name: String });
schema.post('insertMany', function (res) {
  this === Model; // true
  res[0] instanceof Model; // true
  res[0].name; // 'test'
});
const Model = mongoose.model('Test', schema); // Triggers `post('insertMany')` hooks
await Model.insertMany([{ name: 'test' }]);
```

3. Aggregation middleware
   1. pre & post
      1. `this` is an Aggregate object, and `doc` is the **result** of the aggregation call. `doc` is always an array.
         1. <https://mongoosejs.com/docs/api.html#Aggregate>
         2. <https://mongoosejs.com/docs/middleware.html#aggregate>
   2. `_id: string` will not be cast to an `ObjectId`.
   3. pre
      1. only has one arg `next`
   4. post
      1. first arg `doc` is the returned results.
      2. second arg is `next`

```js
const schema = Schema({ name: String, age: Number });
schema.pre('aggregate', function (next) {
  this instanceof mongoose.Aggregate; // true
  const pipeline = this.pipeline();
  pipeline[0]; // { $match: { age: { $gte: 30 } } }
  next();
});
schema.post('aggregate', function (doc: ModelType, next) {
  this instanceof mongoose.Aggregate; // true
  doc.length; // 1
  doc[0].name; // 'Jean-Luc Picard'
  next();
});
const Model = mongoose.model('Character', schema); // Triggers `pre('aggregate')` and `post('aggregate')`
await Model.aggregate([{ $match: { age: { $gte: 30 } } }]);
```

4. Query middleware
   1. Mongoose doesn't execute a query until you either:
      1. `await` on the query
      2. Call `Query#then()`
      3. Call `Query#exec()`
   2. pre & post
      1. `this` is the `Query`.
      2. <https://mongoosejs.com/docs/api/query.html>
         1. `this.getFilter()`
   3. pre
      1. only parameter is `next()` `schema.pre('save', function(next) { next() })`
   4. post
      1. the first arg `doc` is a `HydratedDocument`
         1. <https://mongoosejs.com/docs/api/document.html>
         2. `schema.post('save', function(doc, next) { doc === this // true; next() }`
      2. second arg is `next`
   5. constructor
      1. gives you access to Model methods, and your custom static methods.
      2. `const myModel = this.constructor as Model<ModelType>`
         1. `const myReview = this.constructor as ModelInterfaceType;`
         2. `console.log(await myReview.staticMethodName());`
      3. ` console.log(await ModelName.staticMethodName());`
   6. methods
      1. `deleteMany, deleteOne, estimatedDocumentCount`
      2. `find, findOne, findOneAndDelete, findOneAndRemove, findOneAndReplace, findOneAndUpdate`
      3. `remove, replaceOne`
      4. `update, updateOne, updateMany`

```js
reviewSchema.post(
  /^findOneAnd/,
  async function (
    doc: HydratedDocument<ReviewType, ReviewModel, ReviewTypeMethods>,
    next
  ) {
    await doc.calcAverageRatings(doc.tour._id, doc.constructor as Model<ReviewType, ReviewTypeMethods>);
    next();
  }
);
```

## HydratedDocument<ModelType>.

- <https://mongoosejs.com/docs/typescript.html>
- <https://mongoosejs.com/docs/api/document.html>
- All `Model` methods return a `HydratedDocument`
- HydratedDocument<ModelType> represents a hydrated Mongoose document, with methods, virtuals, and other Mongoose-specific features.

## Query

- <https://mongoosejs.com/docs/api/query.html>
- Mongoose doesn't execute a query until you either:

1.  `await` on the query
2.  Call `Query#then()`
3.  Call `Query#exec()`

# Model

- The `Model class` is a **subclass** of the `Document class`.
- The Schema with methods wrapped up in a 'Document'.
- Document is an instance of 'Model' filled with data.

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
    // !!!!!!!!!!!!!!!!! ODM Join !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    guides: [{ type: mongoose.Types.ObjectId, ref: 'User' }], // reference to 'User' Model.
    // can now use ".populate('guides')" will join documents data to query.
  },
  {
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  }
);
// perform function only on output results.
// const user = User.findOne({name: 'bob'})
// user.yourMadeUpKeyName
tourSchema.virtual('yourMadeUpKeyName').get(function () {
  return this.duration / 7;
});

// User.findByName('bob') -attach fn directly to Model.
userSchema.statics.findByName = function (name: string) {
  // this
  return this.where({ name: new RegExp(name, 'i') });
};
// User.find().byName('bob') -attach method to query object
userSchema.query.byName = function (name: string) {
  return this.where({ name: new RegExp(name, 'i') });
};
// attach method to document. Must use 'function' to have access to 'this'.
userSchema.methods.hasPasswordChanged = async function (
  jwtTimestamp: number
): Promise<boolean> {
  return true;
};
// Middleware
// check for password change -before save to database.
userSchema.pre('save', async function (next) {
  // if password not modified, just return.
  if (!this.isModified('password')) return next();
  return next();
});
// populate all find queries with 'guides'
tourSchema.pre(/^find/, function (next) {
  // 'this' points to what was passed in.
  this.populate({ path: 'guides', select: '-__v -passwordChangedAt' });
  return next();
});
tourSchema.post(/^save/, function (doc, next) {
  // access to doc that was saved.
  console.log(doc.hasPasswordChanged());
  return next();
});

export const User = model('User', userSchema);
```

# Validators

- [Mongoose](https://mongoosejs.com/docs/validation.html)
- validation is done by 'type' unless custom validator is called.
- <https://mongoosejs.com/docs/schematypes.html#string-validators>
- <https://mongoosejs.com/docs/validation.html#built-in-validators>
- **validation only runs with the `create` or `save` method**.
  - `findByIdAndUpdate, update` do not validate info. Only `save()` validates.
  - `findById().save()` will use validation.
  - <https://floqast.com/engineering-blog/post/problem-solving-mongoose-validators-dont-run-on-update-queries/>
    - create your own methods to always `save` for validators to run.
- Custom Error Message
  - There are two equivalent ways to set the validator error message:
    - Array syntax: min: `[6, 'Must be at least 6, got {VALUE}']`
    - Object syntax: enum: `{ values: ['Coffee', 'Tea'], message: '{VALUE} is not supported' }`

**Custom Validators**

- <https://mongoosejs.com/docs/validation.html#custom-validators>
- <https://mongoosejs.com/docs/api/schematype.html#schematype_SchemaType-validate>

```ts
const tourSchema = new Schema({
  name: {
    type: String,
    required: () => (this.onSale ? [true, 'Name is required.'] : false),
    unique: true,
    trim: true,
    maxLength: [40, 'Tour name cannot be over 40 characters.'],
    minLength: [10, 'Tour name cannot be less than 10 characters.'],
    validate: {
      // console.log(this) // complete object with user info
      // name // value from this.name.
      validator: (name: string) =>
        validator.isAlphanumeric(name, 'en-US', { ignore: ' ' }),
      // 'this' is not available, so use props.value.
      message: (props: { value: string }) =>
        `${props.value} can only contain numbers and letters.`,
    },
  },
  email: {
    type: String,
    maxLength: [40, 'Email cannot be over 40 characters.'],
    minLength: [3, 'Valid email cannot be less than 3 characters.'],
    validate: {
      validator: (email: string) => validator.isEmail(email),
      message: (props: { value: string }) =>
        `${props.value} is not a valid email.`,
    },
  },
});

// validate on update
// https://mongoosejs.com/docs/api/model.html#model_Model-validate
// throws mongoose.Error.ValidationError.
// object to validate, path to validate
await Model.validate({ name: null, email: 'bob@b.com' }, ['name', 'email']);
await Model.validate({ ...req.body }, ['name', 'email']);

// https://stackoverflow.com/questions/15627967/why-mongoose-doesnt-validate-on-update
// Pre hook for `findOneAndUpdate`
ClientSchema.pre(/update/i, function (next) {
  this.options.runValidators = true;
  next();
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

```ts
const { name } = req.body;
const author = await Author.create({ name }); // combines schema and save and findOne(id). Returns author.
// or
const author = Author({
  _id: new mongoose.Types.ObjectId(),
  name,
});
return author
  .save()
  .then((author) => res.status(201).json({ author }))
  .catch((e) => res.status(500).json({ error }));
```

## Date

- run only when you add date.

```ts
date: () => Date.now(),
```

## Delete

-

```ts
const { acknowledged, deleteCount } = await Author.deleteOne({ name: 'bob' }); // deletes first document finds with name: bob. returns object: {acknowledged: true, deleteCount: 1}
const { acknowledged, deleteCount } = await Author.deleteMany({ name: 'bob' }); // deletes all documents finds with name: bob. returns object: {acknowledged: true, deleteCount: 1}
```

## Find / Where

- returns `results` or `null`
- `findById(id, "title slug content").exec()`
  - `.exec()` turns query into real Promise.
  - returns one.
  - same as mongo `findOne({id: Object.id()})`
  - second option is will only return fields `title, slug, content`.
    - can be an object, string, string[].
- `Model.findByIdAndUpdate(id, {key: value})` // will not run the validation.
  - finds document, then inserts key:value, overwriting value if key exist.
- [`find({}).exec()`](https://mongoosejs.com/docs/api.html#model_Model-find)
  - the `.exec()` turns query into a real `Promise`. Use it when querying.
  - returns array.
  - [without `.exec()`](https://mongoosejs.com/docs/queries.html#queries-are-not-promises)
- `User.findOne({ email: 'bob50@gmail.com' });`
  - returns user document or null

```ts
// same as findOne
const author = await Author.where('name').equals('bob');
```

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

## Select

- add or remove data from results

```ts
Model.findById(id)
  .populate('author') // search author field and match to author name.
  .select('-__v'); // everything but __v
```

---

# Query Casting

- <https://mongoosejs.com/docs/api/query.html>
- <https://mongoosejs.com/docs/tutorials/query_casting.html>

**Sort**

# Virtuals

- cannot use virtuals in a query, because not in mongo database.
- virtuals attach output to query. 'virtual functions' add a 'key' then value to output.
- virtuals work with `populate` to link `Models` in output.

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

// this data will show up as 'null' unless you use 'populate()' fn on the tourController.
tourSchema.virtual('reviews', {
  ref: 'Review', // Model name
  foreignField: 'tour', //look at the 'Review' model 'tour' field.
  localField: '_id', // if foreignField value match this _id field value, include in output.
});
// const tour = await Tour.findOne({ slug: slugName })
//  .populate({ path: 'reviews', select: 'name, age, rating' })

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
