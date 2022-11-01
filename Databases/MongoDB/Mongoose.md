# Mongoose

- [NPM](https://www.npmjs.com/package/mongoose)
- [Docs](https://mongoosejs.com/docs/guide.html)-
- Mongoose is ORM (Object Data Modeling). Sits on top of MongoDB.

# Schema Types

- [Mongoose Schema Types](https://mongoosejs.com/docs/schematypes.html)
- String, Buffer, Boolean, Mixed, ObjectId, Array, Map
- Number // { type: Number, min: 18, max: 65 },
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
    db.disconnect();
    console.log('Closed Client');
  }
})();
```
