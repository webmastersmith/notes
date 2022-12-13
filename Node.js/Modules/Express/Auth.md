# Auth

# Express

- Express: you don't store raw passwords, you store their hash and salt. When the user tries to login, you use their salt and password to create a hash that you compare with the stored hash.
- <https://blog.loginradius.com/engineering/password-hashing-with-nodejs/>
- <https://www.geeksforgeeks.org/node-js-password-hashing-crypto-module/>

1. `cryto.randomBytes(“length”)`: generates cryptographically strong data of given “length”.
2. `crypto.pbkdf2Sync(“password”, “salt”, “iterations”, “length”, “digest”)`: hashes “password” with “salt” with number of iterations equal to given “iterations” (More iterations means more secure key) and uses algorithm given in “digest” and generates key of length equal to given “length”.
   1. `length` is a number (64) that tells `crypto` how many bytes (key) it should make for the hashing function. Because you don't ever decrypt a password, you don't need to keep the key.

```ts
// Importing modules
const mongoose = require('mongoose');
var crypto = require('crypto');

// Creating user schema
const UserSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  hash: String,
  salt: String,
});

// Method to set salt and hash the password for a user
UserSchema.methods.setPassword = function (password) {
  // Creating a unique salt for a particular user
  this.salt = crypto.randomBytes(16).toString('hex');

  // Hashing user's salt and password with 1000 iterations,

  this.hash = crypto
    .pbkdf2Sync(password, this.salt, 1000, 64, `sha512`)
    .toString(`hex`);
};

// Method to check the entered password is correct or not
UserSchema.methods.isPasswordValid = function (password) {
  var hash = crypto
    .pbkdf2Sync(password, this.salt, 1000, 64, `sha512`)
    .toString(`hex`);
  return this.hash === hash;
};

// Exporting module to allow it to be imported in other files
const User = (module.exports = mongoose.model('User', UserSchema));

// function to attach to static method.
export const hashPassword = async (password: string, salt: string) =>
  crypto.pbkdf2Sync(password, salt, 1000, 64, `sha512`).toString(`hex`);
```

# JWT

- Json Web Tokens
- <https://dpjanes.medium.com/json-web-signatures-using-node-js-and-jose-s-22a3fe46aa89>
- [NPM Jose](https://www.npmjs.com/package/jose)
- All traffic happens over `https`.
- Client logs in. Server validates, sends back a JWT. Server forgets about client. When client is ready to respond, they send back the key with response. Sever validates JWT.
- JWT has 3 parts
  - header
    - metadata about token
  - payload // object and can have multiple properties. { username: 'john', email: 'john@gmail.com' }
    - your id
  - verify signature
    - your signature
    - signature is created from header, payload and JWT secret on server.
- anyone can read JWT.
- any JWT string can be decoded, even without knowing the secret. The secret only lets you verify that the JWT was correctly signed.
- JWTs are only encoded, not encrypted.

**See Crypto Notes**

### Cookies

- `res.cookie('cookieName', cookieToken, objOptions)`
- attach cookie to response object.
-
