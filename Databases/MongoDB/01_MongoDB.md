# MongoDB

- NoSQL database
- queries are idempotent
- bson // like json but with types.
- Collection / Document / Fields structure
  - Table / Row / Columns

## Rules

**JSON**

- keys must be double quotes.
- fields separated with comma.
- values:
  - strings // spaces or dashes must have double quotes.
  - null, boolean, array, objects, numbers, floating point numbers. //no quotes needed.

**BSON**

- `BSON` is the binary representation of `JSON`. It also has types.
- Documents have the following restrictions on field names:
  - The field name \_id is reserved for use as a primary key; its value must be unique in the collection, is immutable, and may be of any type other than an array.
  - Field names/key cannot contain the null character.
  - Top-level field names cannot start with the dollar sign ($) character.
  - Otherwise, starting in MongoDB 3.6, the server permits storage of field names that contain dots (i.e. .) and dollar signs (i.e. $).
  - Until support is added in the query language, the use of $ and . in field names is not recommended and is not supported by the official MongoDB drivers.
  - Use Camel Casing or Lower Casing as required.
  - Use alpha-numeric characters [a-z 0-9]
  - Database names are case-sensitive.
  - Due to case sensitivity, I preferred to use lower case to avoid any issue. (Ex. OS – Linux).
  - Database names must have fewer than 64 characters.
  - Database names for Windows operating system,
  - Database names should contain alphanumeric characters.
  - Below special symbols are not allowed on Windows OS.

**Data Type**

- https://docs.mongodb.com/manual/reference/bson-types/#bson-types
- Double, String, Object, Array, Binary Data, ObjectId, Boolean, Date, Null, Regular Expression, JavaScript, JavaScript (with scope), 32-bit Integer, Timestamp, 64-bit Integer, Decimal128, Min Key, and Max Key.

## Install

**Windows**

- [Mongod](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-windows/)

**Linux**

- [Mongod](https://www.mongodb.com/docs/manual/administration/install-on-linux/)
- Mongo Shell
  - mongosh // installed with mongodb package

## Start Mongod Server

- check if running `systemd` or `init`
  - `ps --no-headers -o comm 1`
- By default, MongoDB launches with bindIp set to 127.0.0.1
- Remote clients will not be able to connect to the mongod, and the mongod will not be able to initialize a replica set unless this value is set to a valid network interface.

1. **init** (start | status | stop | restart)
   1. `sudo service mongod start`
2. **start mongosh shell**
   1. `mongosh`
   2. default port 27017
3.

## Security Checklist

- [Security for remote access](https://www.mongodb.com/docs/manual/administration/security-checklist/)

# Login

- cmd line
  - `mongosh "mongodb://localhost:27017" -u root -p password`
- Node
  - `mongodb://root:password@127.0.0.1:27017` // no spaces
  - Command Line Args in Node
    - MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true })

# WSL2

```sh
# find ip address wsl2 is binding to. In this instance, 172.35.134.226 is ip to connect.
ip addr | grep eth0
# eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
#   inet 172.35.134.226/20 brd 172.35.134.255 scope global eth0
```

# About

**Collection**

- MongoDB stores groups of documents in collections.
- It is like a Array, similar to sql table.

**Document**

- is like JS object, similar to sql row in table.
- All documents must have unique `_id` // Mongo add's `_id` if you don't.
  - The value of \_id must be unique for each document in a collection, is immutable, and can be of any type other than an array.
-

# Aggregation Pipeline

- <https://www.mongodb.com/docs/manual/meta/aggregation-quick-reference/>
- array with objects for each stage of pipeline.
- `$match` is one step in the pipeline. `$group` is next step.

```js
const stats = await Tour.aggregate([
  {
    $match: { ratingsAverage: { $gte: 4.5 } },
  },
  {
    $group: {
      _id: { $toUpper: '$difficulty' }, // field to group by.
      numTours: { $count: {} }, // counts the number in each group. {$sum: 1} // same thing.
      numRatings: { $sum: '$ratingQuantity' },
      avgRating: { $avg: '$ratingsAverage' },
      avgPrice: { $avg: '$price' },
      minPrice: { $min: '$price' },
      maxPrice: { $max: '$price' },
    },
  },
  {
    $sort: { minPrice: 1 },
  },
  {
    $match: { _id: { $ne: 'EASY' } }, // search through again and filter.
  },
]);
```
