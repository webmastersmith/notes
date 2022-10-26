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
Documents have the following restrictions on field names:

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
