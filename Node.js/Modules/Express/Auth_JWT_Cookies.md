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
const token = JWT.sign({ id: user.id }, JWT_KEY, { expiresIn:'2h',  });

//
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
```

### Cookies

- `res.cookie('cookieName', cookieToken, objOptions)`
- attach cookie to response object. Browser stores cookie, then send it with each request.
- Main purpose is to transport info.
  - cookies can move any kind of data.
- server tracks cookie validity.
- automatically managed by browser.
