# Auth

-`crypto.randomBytes(64).toString('hex')` // 64 characters long

**Create Public/Private Keys**

- <https://nodejs.org/api/crypto.html#cryptogeneratekeypairsynctype-options>

```ts
async function createPemKeys(path: string, secret: string) {
  const { generateKeyPairSync } = await import('node:crypto');
  const { publicKey, privateKey } = generateKeyPairSync('rsa', {
    modulusLength: 4096,
    publicKeyEncoding: {
      type: 'spki',
      format: 'pem',
    },
    privateKeyEncoding: {
      type: 'pkcs8',
      format: 'pem',
      cipher: 'aes-256-cbc',
      passphrase: secret,
    },
  });
  fs.writeFileSync(`${path}`, privateKey);
  fs.writeFileSync(`${path}.pub`, publicKey);
  console.log('publicKey', publicKey);
  console.log('privateKey', privateKey);
}
```

**Encrypt & Decrypt messages**

- you need a secret key.

```ts
// https://www.section.io/engineering-education/data-encryption-and-decryption-in-node-js-using-crypto/
// crypto module
import crypto from 'crypto';
const algorithm = 'aes-256-cbc';
// generate 16 bytes of random data
const salt = crypto.randomBytes(16);
// protected data
const message = 'This is a secret message';
// secret key generate 32 bytes of random data
const Key = crypto.randomBytes(32);
// the cipher function
const cipher = crypto.createCipheriv(algorithm, Key, salt);
// encrypt the message
// input encoding
// output encoding
let encryptedData = cipher.update(message, 'utf-8', 'hex');
// final method 'seals' the cipher so it can't be used again.
encryptedData += cipher.final('hex');
console.log('Encrypted message: ' + encryptedData);

// the decipher function
const decipher = crypto.createDecipheriv(algorithm, Key, salt);
let decryptedData = decipher.update(encryptedData, 'hex', 'utf-8');
decryptedData += decipher.final('utf8');
console.log('Decrypted message: ' + decryptedData);

// quick functions
export async function encrypt(
  token: string,
  salt: Buffer | string,
  key: Buffer | string
): Promise<string> {
  const crypto = require('crypto');
  const algorithm = 'aes-256-cbc';
  // key must be 32 bytes. crypto.randomBytes(32) // buffer.
  const cipher = crypto.createCipheriv(algorithm, key, salt);
  let encrypted = cipher.update(token, 'utf-8', 'hex');
  encrypted += cipher.final('hex');
  return encrypted;
}
export async function decrypt(
  encryptedData: string,
  salt: Buffer | string,
  key: Buffer | string
): Promise<string> {
  const crypto = await import('node:crypto');
  const algorithm = 'aes-256-cbc';
  const decipher = crypto.createDecipheriv(algorithm, key, salt);
  let decryptedData = decipher.update(encryptedData, 'hex', 'utf-8');
  decryptedData += decipher.final('utf8');
  return decryptedData;
}

// call it
(async function () {
  const crypto = await import('node:crypto');
  const salt = Buffer.from('8574bb84182f47bc154ba223384a0349', 'hex');
  // because algorithm is (256/8 = 32). key can only be 32 bytes.
  // const key = crypto.randomBytes(32);
  // console.log('key', key.toString('hex'));

  const token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzNjlhMTNlMTEyM2Y1ZmM3MTFhYmY0ZiIsImlhdCI6MTY2Nzg2Njk0MiwiZXhwIjoxNjY3ODc0MTQyfQ.rmjvh-B1J4c51jWqhXoI6si6N5ob3-syWIVuxo5GqB0';
  // const token = 'asdkjdlfajidfidfidifjidjfi';

  const encryptedToken = await encrypt(token, salt, key);
  console.log(encryptedToken);
  console.log(await decrypt(encryptedToken, salt, key));
})();
```

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
  - payload
    - your id
  - verify signature
    - your signature
    - signature is created from header, payload and JWT secret on server.
- anyone can read JWT.
- any JWT string can be decoded, even without knowing the secret. The secret only lets you verify that the JWT was correctly signed.
- JWTs are only encoded, not encrypted.
