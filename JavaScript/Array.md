# Array

## Coercions

**Array to Object\*\***

```js
// reduce
["a", "b", "c"].reduce((a, v) => ({ ...a, [v]: v }), {}); // { a: "a", b: "b", c: "c" }

// spread
{...["a", "b", "c"]} // { '0': 'a', '1':'b', '2':'c'}

// Object.assign
Object.assign({}, ["a", "b", "c"]) // {'0':'a', '1':'b', '2':'c'}
```

- spread

```js
{...arr} // same as Object.assign
```

**String to Array**

- split
- spread

```js
// spread operator
[..."abc"]; // ['a','b','c']

// split
const a = "abc".split(""); // ['a','b','c']
```

**[Array to String](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/join)**

```js
const str = [1, 2, 3].join(""); // '123' // default is ','
```

## Methods and Properties

- **[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)**

## Typed Arrays

**[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Indexed_collections#typed_arrays)**
