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

# Scrypt

```ts
import { scrypt, randomBytes } from 'crypto';
import { promisify } from 'util';
import Log from './Logging';
const scryptAsync = promisify(scrypt);
import { Request, Response, NextFunction } from 'express';
import { Auth } from '../model/AuthSchema';

export class Password {
  static async hash(pw: string, salt = randomBytes(16).toString('hex')) {
    try {
      const buf = (await scryptAsync(pw, salt, 64)) as Buffer;
      return `${buf.toString('hex')}.${salt}`;
    } catch (e) {
      Log.error(e);
      throw new Error('password could not be hashed.');
    }
  }

  static async check(hashPlusSalt: string, providedPassword: string) {
    try {
      const providedHashPlusSalt = await Password.hash(
        providedPassword,
        hashPlusSalt.split('.')[1]
      );
      return hashPlusSalt === providedHashPlusSalt;
    } catch (e) {
      Log.error(e);
      throw new Error('password check errored.');
    }
  }
}

export async function protect(req: Request, res: Response, next: NextFunction) {
  // data is validated through mongoose.
  const { email, password } = req.body;
  // find user id
  const user = await Auth.findOne({ email }, ['email', 'password']).exec();
  const msg = 'something went wrong with email or password.';
  if (!user) return next(new Error(`${msg} (A)`));
  // check password
  const isValid = await Auth.checkPassword(user?.password, password);
  if (!isValid) return next(new Error(`${msg} (B)`));
  Log.warn(user);
  user.password = '';
  req.body.user = user;
  next();
}
```

# JWT

- Json Web Tokens
- <https://dpjanes.medium.com/json-web-signatures-using-node-js-and-jose-s-22a3fe46aa89>
- [NPM Jose](https://www.npmjs.com/package/jose)
- All traffic happens over `https`.
- Client logs in. Server validates, sends back a JWT. Server forgets about client. When client is ready to respond, they send back the key with response. Sever validates JWT.
- have to be managed manually.
- always used for authentication/authorization.
- The token is transported by:
  - 'Authorization' header
  - attached to body.
  - stored in a cookie.
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

- npm i jsonwebtoken

```ts
import JWT from 'jsonwebtoken';
// See Crypto Notes
// crypto.randomBytes(32).toString('hex')
const JWT_KEY = 49326389eae6287603867f47b9e2532e42da9f71d8a9f76709b70276c040bc22
// 2 hours = hours, minutes, seconds, milliseconds
const expiresIn = new Date(Date.now() + 2 * 60 * 60 * 1000), // 36e5 same as 3,600,000 same as 60*60*1000.

// SIGN TOKEN
// exp // This means that the exp field should contain the number of seconds since the epoch.
// exp: Math.floor(Date.now() / 1000) + (60 * 60), // 1 hour.
// iat: Math.floor(Date.now() / 1000)
// iat: Math.floor(Date.now() / 1000) - 30 // backdate 30 seconds
const token = JWT.sign({ id: user.id }, JWT_KEY, { expiresIn:'1h' }); // best to use string
const token = JWT.sign({ id: user.id }, JWT_KEY, { expiresIn: 60*60 }); // expiresIn is 60m * 60s = 1h

type jwt_type = {
  id: string;
  iat: number;
  exp: number;
};
// verify key matches user id.
// If expired, will throw Error('jwt expired') //error.name: "TokenExpiredError"
// iat = issue at time: when token created.
// exp = when token expires.
const { id, iat, exp } = JWT.verify(decryptedToken, JWT_KEY) as jwt_type;


// RS256
// https://siddharthac6.medium.com/json-web-token-jwt-the-right-way-of-implementing-with-node-js-65b8915d550e
const fs   = require('fs');
const jwt   = require('jsonwebtoken');
// use 'utf8' to get string instead of byte array  (512 bit key)
var privateKEY  = fs.readFileSync('./private.key', 'utf8');
var publicKEY  = fs.readFileSync('./public.key', 'utf8');
// PAYLOAD
var payload = {
 data1: "Data 1",
 data2: "Data 2",
 data3: "Data 3",
 data4: "Data 4",
};
// PRIVATE and PUBLIC key
// Use utf8 character encoding while reading the private.key and private.key to get a string as content instead of byte array.
var privateKEY  = fs.readFileSync('./private.key', 'utf8');
var publicKEY  = fs.readFileSync('./public.key', 'utf8');
var i  = 'Mysoft corp';          // Issuer // issuer — Software organization that issues the token.
var s  = 'some@user.com';        // Subject // subject — Intended user of the token.
var a  = 'http://mysoftcorp.in'; // Audience // Basically identity of the intended recipient of the token.

// SIGNING OPTIONS
var signOptions = {
 issuer:  i,
 subject:  s,
 audience:  a,
 expiresIn:  "12h", // Expiration time after which the token will be invalid.
 algorithm:  "RS256" // Encryption algorithm to be used to protect the token.
};

// sign
var token = jwt.sign(payload, privateKEY, signOptions); // private key sign

// verify
var verifyOptions = {
 issuer:  i,
 subject:  s,
 audience:  a,
 expiresIn:  "12h",
 algorithm:  ["RS256"] // this is an array, unlike the signOptions
};
var legit = jwt.verify(token, publicKEY, verifyOptions); // public key verify
```

### Cookies

- two types of cookies:
  1. session cookies: (data stays on server and id (jwt inside cookie) sent to client),
     1. data persist only for short period of time. (More secure, but stateful).
  2. regular cookie: all data sent to client. (jwt inside cookie) server is stateless.

**session cookie**

```ts
// express-session -more secure because only stores id in cookie.


//  not as secure cookie-session stores all info in cookie
stores all information in the cookie, not on the server.
import cookieSession from 'cookie-session';
  app.use(
    cookieSession({
      signed: false,
      secure: config.dev.env === 'production' ? true : false
    })
  );
```

- `res.cookie('cookieName', cookieToken, objOptions)`
- attach cookie to response object. Browser stores cookie, then send it with each request.
- Main purpose is to transport info.
  - cookies can move any kind of data.
- server tracks cookie validity.
- automatically managed by browser.
