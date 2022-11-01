# Node

- [MongoDB Shell Connect](https://www.mongodb.com/docs/mongodb-shell/connect/)
- [MongoDB Nodejs API](https://mongodb.github.io/node-mongodb-native/4.11/)
- [NPM](https://www.npmjs.com/package/mongodb)
  - `npm i mongodb`

# Login -Running Server

- Node

  - `mongodb://root:password@127.0.0.1:27017` // no spaces
    - the database name and collection are added inside code.
    - `mongodb://root:password@127.0.0.1:27017/natours?authSource=admin`
      - this method works.
  - Command Line Args in Node
    - MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true })

# CRUD

- If database or collection do not exist: MongoDB will automatically create them with request.
- to make one-of function's, you have to pass `client` to function.
  - You must `client.close()` in the same function you `client.connect()` or you will get 'MongoError: Topology is closed' if you try to pass in `client` or you will get error when trying to connect again.
  - when `client` is exported, it will be global and hard to `client.close()`.
  - Best practice -create main function you `client.connect()` and `client.close()`. Then call other functions, passing in the client to perform the work.
- <https://www.mongodb.com/developer/quickstart/cheat-sheet/>
- <https://docs.mongodb.com/drivers/node/current/fundamentals/crud/>
- <https://docs.mongodb.com/drivers/node/current/usage-examples/#available-usage-examples>
- `_id` is automatically created for document and does not need to be included.

### Iteration

- [MongoDB Cursor](https://www.mongodb.com/docs/manual/reference/method/#std-label-js-query-cursor-methods)
- [Mongo Cursor TS](https://mongodb.github.io/node-mongodb-native/4.11/classes/FindCursor.html)
  - mongo `find` method return a `cursor`.
    - returns an (JS Object) index that point's to a documents of the collection.
    - It can be filtered, for specific items, then data asked for.
  - `const result = await collection.find({}).toArray();`
  - **Cursor Methods**
    - [`toArray()`](https://www.mongodb.com/docs/manual/reference/method/cursor.toArray/#mongodb-method-cursor.toArray) allows you to convert `cursor` into an array.
    - `result.forEach((db) => console.log(db))`
    - [`.hasNext()`](https://www.mongodb.com/docs/drivers/node/current/fundamentals/promises/)
      - returns true if more documents exist, but will always must be `await`ed.
    - `find().count()` // return document count
    - `find().pretty()` // make readable.

```ts
// turn into an JS array.
const docCursor = await db.find().toArray();

// hasNext / for await of
async function run() {
  const cursor = collection.find(); // dump all documents in collection.

  // both 'await's' must be there or create an infinite loop.
  while (await cursor.hasNext()) {
    console.log(await cursor.next());
  }

  // same as above.
  const docCursor = db.find();
  // find methods returns a cursor that is iterable. Like a generator.
  for await (const doc of docCursor) {
    console.log(`${JSON.stringify(doc, null, 2)}`);
    console.log(`${doc.date}`);
  }
}
```

### Admin

**List Databases**

```ts
async function listDatabases(client) {
  databasesList = await client.db().admin().listDatabases();

  console.log('Databases:');
  databasesList.databases.forEach((db) => console.log(` - ${db}`));
}
```

**Create Database**

- You can only create a database by creating a collection and adding document.

```ts
// declare the database name
const db = client.db(dbName);
// declare the collection name
const myDocs = db.collection('myDocuments');
// add document to collection -Mongo will create the db and collection.
const itemAdd = await myDocs.insertOne({
  email: 'bob@gmail.com',
  password: 'password',
  date: new Date().toISOString(),
}); // now db and collection exist.
```

### Find

- [Mongo Find](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#find-all-documents-in-a-collection)
- `await collection.find({})` // `{}` means return everything.
  - if find by `ObjectId` typescript will error: `Value of type 'typeof ObjectId' is not callable.`
    - fix: add `new` keyword: `await collection.find({_id: new ObjectId("6361359118325efea25f3958")})`
- `await collection.find({}, {name: 1})` // return all documents in collection, but only the name property.
  - this is called [`projection`](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#std-label-method-find-projection).
- [Query Operators](https://www.mongodb.com/docs/manual/reference/operator/query/#std-label-query-selectors)
- [Query Examples](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#query-using-operators)
- **$in, $nin** // list of values to match
  - `{ _id: { $in: [ 5, ObjectId("507c35dd8fada716c89d0013") ] }` // \_id is 5 or ObjectId(507c...)
- **$regex**
  - `{ "name.last": { $regex: /^N/ } }`
- **$gt, $ gte, $lt, $lte $ne**
