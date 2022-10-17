# Array

## Coercions

**Array to Object\*\***

- Object.assign({}, arr) // {0:'a', 1:'b'}

```js
["a", "b", "c"].reduce((a, v) => ({ ...a, [v]: v }), {});
// { a: "a", b: "b", c: "c" }
```

- spread

```js
{...arr} // same as Object.assign
```

**String to Array**

```js
[..."abc"]; // ['a','b','c']
const a = "abc".split(""); // ['a','b','c']
```

## Methods and Properties

- **[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)**
