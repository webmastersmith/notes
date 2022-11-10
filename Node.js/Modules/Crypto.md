# Crypto Node Module

- <https://gist.github.com/jo/8619441>
- <https://blog.logrocket.com/node-js-crypto-module-a-tutorial/>

- <https://simonplend.com/generate-v4-uuids-without-needing-the-uuid-library/>

# UUID

- https://developer.mozilla.org/en-US/docs/Web/API/Crypto/randomUUID

**Nodejs**

```js
// use this one
import { randomUUID, randomBytes } from 'crypto';
const uuid = randomUUID(); //cecfd80f-9add-401a-ab45-e195a01f02c7
// or
const id = crypto.randomBytes(16).toString('hex'); //f9b327e70bbcf42494ccb28b2d98e00e

// or
const { randomUUID } = require('crypto'); //5 times faster than other uuid librarys.
const itemId = randomUUID();
console.log(itemId);
// 'c11903dc-181d-4cce-996f-5f5ebb4034f3'

//es6
import crypto from 'crypto';
crypto.randomUUID(); //"93cda304-711a-431f-984e-7689af43596d"

// or

async function cryptoUID() {
  try {
    let crypto = await import('crypto');
    return crypto.randomUUID();
  } catch (err) {
    console.log('crypto support is disabled!');
  }
} //cryptoUID()  //'c0f946a2-0bec-4fd1-851e-dd43ac8c7b8d'
```

**Javascript**

- node and browser now have 'crypto.randomUUID()'

```js
id: crypto.randomUUID?.() || `${Date.now()}`; // 'd88c372b-973a-404c-b202-93a544621f2b'  //built into node and browser now, but not nextjs. // //0.112ms

// use this one
// @ts-ignore
// prettier-ignore  //needs crypto library. Just use crypto.randomUUID()
function uuidv4() {
  return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, (c) =>
    (
      c ^
      (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (c / 4)))
    ).toString(16)
  );
}
// "7e915b42-75f6-414a-8281-6f99c6312909"   //superfast 0.275ms

or;
// @ts-ignore
// prettier-ignore
export const uuid = (a) => (a?(a^Math.random()*16>>a/4).toString(16):([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g,uuid)) //"fbde1c8e-31da-4df0-9248-70200ba1fb1b"  -uuid('') -satify typescript compiler
or;
export const uid = () =>
  new Date().getTime() + Math.random().toString(16).slice(2); //uid()
//string: "163380665338445d6299b29e4d8"  //use this one for simple random react components.
or;
function rid() {
  return window.crypto.getRandomValues(new Uint32Array(4)).join('');
} //"419212951391108662738037954822683400208"
```

**Window.crypto** // stronger random number generator

```js
const lut = Array(256)
  .fill()
  .map((_, i) => (i < 16 ? '0' : '') + i.toString(16));
const formatUuid = ({ d0, d1, d2, d3 }) =>
  lut[d0 & 0xff] +
  lut[(d0 >> 8) & 0xff] +
  lut[(d0 >> 16) & 0xff] +
  lut[(d0 >> 24) & 0xff] +
  '-' +
  lut[d1 & 0xff] +
  lut[(d1 >> 8) & 0xff] +
  '-' +
  lut[((d1 >> 16) & 0x0f) | 0x40] +
  lut[(d1 >> 24) & 0xff] +
  '-' +
  lut[(d2 & 0x3f) | 0x80] +
  lut[(d2 >> 8) & 0xff] +
  '-' +
  lut[(d2 >> 16) & 0xff] +
  lut[(d2 >> 24) & 0xff] +
  lut[d3 & 0xff] +
  lut[(d3 >> 8) & 0xff] +
  lut[(d3 >> 16) & 0xff] +
  lut[(d3 >> 24) & 0xff];
const getRandomValuesFunc =
  window.crypto && window.crypto.getRandomValues
    ? () => {
        const dvals = new Uint32Array(4);
        window.crypto.getRandomValues(dvals);
        return {
          d0: dvals[0],
          d1: dvals[1],
          d2: dvals[2],
          d3: dvals[3],
        };
      }
    : () => ({
        d0: (Math.random() * 0x100000000) >>> 0,
        d1: (Math.random() * 0x100000000) >>> 0,
        d2: (Math.random() * 0x100000000) >>> 0,
        d3: (Math.random() * 0x100000000) >>> 0,
      });
const uuid = () => formatUuid(getRandomValuesFunc());
console.log(uuid());
```

**TimeStamp version.**

- <https://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript>
- Here's a similar RFC4122 version 4 compliant solution that solves that issue by offsetting the first 13 hex numbers by a hex portion of the timestamp, and once depleted offsets by a hex portion of the microseconds since pageload. That way, even if Math.random is on the same seed, both clients would have to generate the UUID the exact same number of microseconds since pageload (if high-perfomance time is supported) AND at the exact same millisecond (or 10,000+ years later) to get the same UUID:

```js
function generateUUID() {
  // Public Domain/MIT
  var d = new Date().getTime(); //Timestamp
  var d2 = (performance && performance.now && performance.now() * 1000) || 0; //Time in microseconds since page-load or 0 if unsupported
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = Math.random() * 16; //random number between 0 and 16
    if (d > 0) {
      //Use timestamp until depleted
      r = (d + r) % 16 | 0;
      d = Math.floor(d / 16);
    } else {
      //Use microseconds since page-load if supported
      r = (d2 + r) % 16 | 0;
      d2 = Math.floor(d2 / 16);
    }
    return (c === 'x' ? r : (r & 0x3) | 0x8).toString(16);
  });
}
console.log(generateUUID());
```

**Udemy Original 'uuidv4.js '**

- call it with: uuidv4()

```js
// prettier-ignore
!function(r){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=r();else if("function"==typeof define&&define.amd)define([],r);else{var e;e="undefined"!=typeof window?window:"undefined"!=typeof global?global:"undefined"!=typeof self?self:this,e.uuidv4=r()}}(function(){return function r(e,n,t){function o(f,u){if(!n[f]){if(!e[f]){var a="function"==typeof require&&require;if(!u&&a)return a(f,!0);if(i)return i(f,!0);var d=new Error("Cannot find module '"+f+"'");throw d.code="MODULE_NOT_FOUND",d}var p=n[f]={exports:{}};e[f][0].call(p.exports,function(r){var n=e[f][1][r];return o(n?n:r)},p,p.exports,r,e,n,t)}return n[f].exports}for(var i="function"==typeof require&&require,f=0;f<t.length;f++)o(t[f]);return o}({1:[function(r,e,n){function t(r,e){var n=e||0,t=o;return t[r[n++]]+t[r[n++]]+t[r[n++]]+t[r[n++]]+"-"+t[r[n++]]+t[r[n++]]+"-"+t[r[n++]]+t[r[n++]]+"-"+t[r[n++]]+t[r[n++]]+"-"+t[r[n++]]+t[r[n++]]+t[r[n++]]+t[r[n++]]+t[r[n++]]+t[r[n++]]}for(var o=[],i=0;i<256;++i)o[i]=(i+256).toString(16).substr(1);e.exports=t},{}],2:[function(r,e,n){var t="undefined"!=typeof crypto&&crypto.getRandomValues.bind(crypto)||"undefined"!=typeof msCrypto&&msCrypto.getRandomValues.bind(msCrypto);if(t){var o=new Uint8Array(16);e.exports=function(){return t(o),o}}else{var i=new Array(16);e.exports=function(){for(var r,e=0;e<16;e++)0===(3&e)&&(r=4294967296*Math.random()),i[e]=r>>>((3&e)<<3)&255;return i}}},{}],3:[function(r,e,n){function t(r,e,n){var t=e&&n||0;"string"==typeof r&&(e="binary"===r?new Array(16):null,r=null),r=r||{};var f=r.random||(r.rng||o)();if(f[6]=15&f[6]|64,f[8]=63&f[8]|128,e)for(var u=0;u<16;++u)e[t+u]=f[u];return e||i(f)}var o=r("./lib/rng"),i=r("./lib/bytesToUuid");e.exports=t},{"./lib/bytesToUuid":1,"./lib/rng":2}]},{},[3])(3)});
```

# Encrypt / Decrypt

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
  fs.writeFileSync(`${path}.pem`, privateKey);
  fs.writeFileSync(`${path}.pem.pub`, publicKey);
  console.log('publicKey', publicKey);
  console.log('privateKey', privateKey);
}
```

**Encrypt & Decrypt messages**

- you need a secret key.
- [openssl algorithms](https://www.openssl.org/docs/man1.0.2/man1/ciphers.html)
- [With public/private keys](https://plainenglish.io/blog/rsa-encryption-in-nodejs-with-code-samples-86bb829718e0)

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
  data: string,
  salt: Buffer | string,
  key: Buffer | string
): Promise<string> {
  const crypto = await import('node:crypto');
  // non async
  // const crypto = require('crypto');
  const algorithm = 'aes-256-cbc';
  // key must be 32 bytes.(aes-256 = key is 256 bits. 256/8 = 32 bytes)  crypto.randomBytes(32)
  if (typeof salt === 'string') {
    salt = Buffer.from(salt, 'hex');
  }
  if (typeof key === 'string') {
    key = Buffer.from(key, 'hex');
  }
  // returns buffer
  const cipher = crypto.createCipheriv(algorithm, key, salt);
  // (data, inputEncoding, outputEncoding)
  // If no encoding is provided, then a buffer is expected.
  // If data is a Buffer then input_encoding is ignored.
  let encrypted = cipher.update(data, 'utf-8', 'hex');
  // close the cipher, so it cannot be reused.
  encrypted += cipher.final('hex');
  return encrypted;
}
export async function decrypt(
  encryptedData: string,
  salt: Buffer | string,
  key: Buffer | string
): Promise<string> {
  const crypto = await import('node:crypto');
  // const crypto = require('crypto');
  // key is utf-8 string
  const algorithm = 'aes-256-cbc';
  if (typeof salt === 'string') {
    salt = Buffer.from(salt, 'hex'); // the original string was encoded to hex.
  }
  if (typeof key === 'string') {
    key = Buffer.from(key, 'hex');
  }

  const decipher = crypto.createDecipheriv(algorithm, key, salt);
  let decryptedData = decipher.update(encryptedData, 'hex', 'utf-8');
  decryptedData += decipher.final('utf8');
  return decryptedData;
}

(async function () {
  const crypto = await import('node:crypto');
  const path = `${process.cwd()}/../../`;

  require('dotenv').config({ path: `${path}/.env` });
  const salt = '8574bb84182f47bc154ba223384a0349';
  // because algorithm is (256/8 = 32). key can only be 32 bytes.
  // const key = crypto.randomBytes(32);

  const token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzNjlhMTNlMTEyM2Y1ZmM3MTFhYmY0ZiIsImlhdCI6MTY2Nzg2Njk0MiwiZXhwIjoxNjY3ODc0MTQyfQ.rmjvh-B1J4c51jWqhXoI6si6N5ob3-syWIVuxo5GqB0';

  const key = process.env.JWT_SECRET;

  if (key) {
    console.log('Token', key);
    console.time('encryption/decryption time:');
    const encryptedToken = await encrypt(token, salt, key);
    console.log('encryptedToken', encryptedToken);
    const decryptedToken = await decrypt(encryptedToken, salt, key);
    console.log('decryptedToken', decryptedToken);
    console.log(
      'Does Token and DecryptedToken match:',
      token === decryptedToken
    );
    console.timeEnd('encryption/decryption time:');
  }
})();
```

**stream**

```ts
var fs = require('fs');
var crypto = require('crypto');

var key = '14189dc35ae35e75ff31d7502e245cd9bc7803838fbfd5c773cdcd79b8a28bbd';
const salt = crypto.randomBytes(16);
var cipher = crypto.createCipheriv('aes-256-cbc', key, salt);
var input = fs.createReadStream('test.txt');
var output = fs.createWriteStream('test.txt.enc');

input.pipe(cipher).pipe(output);

output.on('finish', function () {
  console.log('Encrypted file written to disk!');
});
```

# Hash

- hash is one way. In most cases you cannot reverse a hash.

```ts
import crypto from 'crypto';
const token = crypto.randomBytes(12);
// this will produce the same results with the same input.
const hash = crypto.createHash('sha256').update(token).digest('hex'); // output hex values.

// salt hash
export async function hashPassword(
  password: string,
  salt: string
): Promise<string> {
  // Hashing user's salt and password with 1000 iterations. This will produce same results given the same salt and password.
  const hash = crypto
    .pbkdf2Sync(password, salt, 1000, 64, `sha512`)
    .toString(`hex`);
  return hash;
}
```
