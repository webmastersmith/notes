# Destructuring

- https://ponyfoo.com/articles/es6-destructuring-in-depth
- https://betterprogramming.pub/javascript-nested-destructuring-assignment-de7348cfc04b

**Renaming**

- destructure and rename

```ts
const { item1: id, item2: anotherId } = obj;
```

**Default Value**

- only uses default value if object **key is missing**, or **value is undefined**.

```ts
// default values works with destructuring when key is missing or value is undefined.
const { a = 'foo' } = { a: undefined }; // foo
const { b = 'foo' } = { a: 'boy' }; // foo

// default does not work with null/false values.
const { c = 'foo' } = { c: false }; // false
const { d = 'foo' } = { d: null }; // null
```
