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
