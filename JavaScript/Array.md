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
[...'abc']; // ['a','b','c']

// split
const a = 'abc'.split(''); // ['a','b','c']
```

**[Array to String](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/join)**

```js
const str = [1, 2, 3].join(''); // '123' // default is ','
```

## Typed Arrays

**[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Indexed_collections#typed_arrays)**

# Methods and Properties

- **[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)**

### Find

- find is good for modifying array of objects
-

```js
let a = [
  { a: 1, b: 2 },
  { a: 2, b: 3 },
  { a: 4, b: 5 },
];
let b = a.find((obj) => obj.a === 2);
b.b = 9; // modifies the object inside array.
console.log(a); //  [{ a: 1, b: 2 }, { a: 2, b: 9 }, { a: 4, b: 5 }]
```

### Map

- modify array of objects in place

```js
const fixedPosts = posts.map((post) => (post.id === id ? newPost : post));
```

### Sort

**[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)**

- mutates array.
- converts elements into strings, then get their UTF-16 Unicode code point value with `charCodeAt(0)` (0 is index of character from string).
  - sorts numbers, then alphabetically, Capital first then lowercase.
- numbers are treated like letters: 9 > 80 // true. -because 9 is bigger than 8.
- 'a' > 'A' // true

```js
arr.sort((a, b) => a - b); //number sort
arr.sort((a, b) => (a < b ? -1 : b < a ? 1 : 0)); // numbers and letters

// ip address
const ipSort = (ipAddressArray) => {
  return ipAddressArray.sort(function (a, b) {
    a = a.split('.').map((i) => parseInt(i));
    b = b.split('.').map((i) => parseInt(i));
    for (let i = 0; i < a.length; i++) {
      return a[i] < b[i] ? -1 : a[i] > b[i] ? 1 : 0;
    }
  });
};

// array of objects
arrOfObj
  .sort((a, b) => (a.name < b.name ? -1 : a.name > b.name ? 1 : 0)) //small to big
  .reverse(); //big to small

// Double Sort IP addresses
function doubleSortObj(objArr, prop1, prop2) {
  //prop 1 & 2 are 'strings'. 2 is ip.
  return objArr.sort((objA, objB) => {
    let a = objA[prop1];
    let b = objB[prop1];
    if (a > b) return -1;
    if (a < b) return 1;
    if (a == b) {
      a = a.split('.').map((i) => parseInt(i));
      b = b.split('.').map((i) => parseInt(i));
      for (let i = 0; i < a.length; i++) {
        return a[i] < b[i] ? -1 : a[i] > b[i] ? 1 : 0;
      }
    }
  });
}

// https://codeburst.io/array-vs-set-vs-map-vs-object-real-time-use-cases-in-javascript-es6-47ee3295329b
// array of strings in a uniform case without special characters
const arr = ['sex', 'age', 'job'];
arr.sort(); //returns ["age", "job", "sex"]// array of numbers
const arr = [30, 4, 29, 19];
arr.sort((a, b) => a - b); // returns [4, 19, 29, 30]// array of number strings
const arr = ['30', '4', '29', '19'];
arr.sort((a, b) => a - b); // returns ["4", "19", "29", "30"]// array of mixed numerics
const arr = [30, '4', 29, '19'];
arr.sort((a, b) => a - b); // returns ["4", "19", 29, 30]// array of non-ASCII strings and also strings
const arr = ['réservé', 'cliché', 'adieu'];
arr.sort((a, b) => a.localeCompare(b)); // returns is ['adieu', 'cliché','réservé']// array of objects
const arr = [
  { name: 'Sharpe', value: 37 },
  { name: 'And', value: 45 },
  { name: 'The', value: -12 },
];
// sort by name string
arr.sort((a, b) => a['name'].localeCompare(b['name'])); // sort by value number
arr.sort((a, b) => a['value'] - b['value']);
```

### Splice

- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice)
- mutates
- returns what is removed in an array in an array.
- arr.splice(count, deleteCount, element-to-add)
  - count // exclusive. If negative, starts from end (-1 is last element).
    - insert
      - item is inserted after count
      - arr.splice(1,0, 'element') // after first element, insert 'element'.
    - remove // 0 is insert only. >= 1 will remove elements.
      - if only count provided, number of elements to be returned/removed. Negative starts from end.
      - arr.splice(2) // returns first two elements.
      - arr.splice() // returns empty array.
      - arr.splice(0) // returns all elements in array.

```js
// Insert
const months = ['Jan', 'March', 'April', 'June'];
months.splice(1, 0, 'Feb'); // ["Jan", "Feb", "March", "April", "June"]
// Replace
months.splice(4, 1, 'May'); // ["Jan", "Feb", "March", "April", "May"]
// Delete
months.splice(-1); // ["Jan", "Feb", "March", "April"] returns ["May"]
months.splice(1, 1); // ["Jan", "March", "April"] returns ["Feb"]
months.splice(1); // ["March", "April"] returns ["Jan"] // cuts off everything before index 1.
```
