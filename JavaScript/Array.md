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

## Sort

**[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)**

- mutates array.
- sorts numbers 9 > 80, then alphabetically, Capital first then lowercase.
- all non-undefined array elements are sorted by converting them to strings and comparing strings in UTF-16 Unicode code point value.
- converts elements into `charCodeAt(0)` (0 is index of element to compare) then compare.
- numbers are treated like letters: 9 > 80 // true. -because 9 is bigger than 8.
  'a' > 'A' // true

```js
arr.sort((a, b) => a - b); //number sort
arr.sort((a, b) => (a < b ? -1 : b < a ? 1 : 0)); // numbers and letters

// ip address
const ipSort = (ipAddressArray) => {
  return ipAddressArray.sort(function (a, b) {
    a = a.split(".").map((i) => parseInt(i));
    b = b.split(".").map((i) => parseInt(i));
    for (let i = 0; i < a.length; i++) {
      return a[i] < b[i] ? -1 : a[i] > b[i] ? 1 : 0;
    }
  });
};

// array of objects
//small to big
arrOfObj
  .sort((a, b) => (a.name < b.name ? -1 : a.name > b.name ? 1 : 0))
  .reverse(); //big to small

// Double Sort
function doubleSortObj(objArr, prop1, prop2) {
  //prop 1 & 2 are 'strings'. 2 is ip.
  return objArr.sort((objA, objB) => {
    let a = objA[prop1];
    let b = objB[prop1];
    if (a > b) return -1;
    if (a < b) return 1;
    if (a == b) {
      a = a.split(".").map((i) => parseInt(i));
      b = b.split(".").map((i) => parseInt(i));
      for (let i = 0; i < a.length; i++) {
        return a[i] < b[i] ? -1 : a[i] > b[i] ? 1 : 0;
      }
    }
  });
}
```
