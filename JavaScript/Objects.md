# Objects

- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Working_with_Objects)

## Iteration

**for k in obj**

- will iterate over prototype (inherited properties). Use Object.hasOwn(key)
  - You don't need to check hasOwnProperty when iterating on keys if you're using a simple object (for example one you made yourself with {}).

```js
for (const key in obj) {
  console.log(key);
}
// to avoid iteration over inherited properties.
for (let key in obj) {
  if (obj.hasOwnProperty(key)) {
    console.log(key, obj[key]);
  }
}
```

**Object.entries(obj)** // ES6 (ES2015)

```js
for (const [key, value] of Object.entries(obj) {
  console.log(`${key}: ${value}`)
})
```

**Object.keys**

- const arr = Object.keys(obj) // returns array of keys as strings.

```js
const k = Object.keys(obj);
const k = Object.keys(obj).length;
```

**Object.values(obj)**

```js
const arr = Object.values(obj);
```

**[Object.getOwnPropertyNames()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyNames)**

- returns an array of all properties (including non-enumerable properties except for those which use Symbol)

```js
const a = Object.getOwnPropertyNames(object1); // returns array of keys
```

**Find key**

- [Object.hasOwn(obj)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/hasOwn) // true || false
- [Object.hasOwnProperty(key)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/hasOwnProperty) // true || false
