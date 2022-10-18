# Types

## Typeof

- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/typeof)
- Returns strings of all 7 types +
  - "function" // classes are functions as well.
  - "object" // all other objects.

```js
typeof obj; // returns a type as a string
```

## Types Primitives

- **[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures)**
- immutable

1. boolean //true, false
2. null //means absence of value. You assign Null.
3. undefined //absence of definition. Variable is declared but no value assigned. Undefined is assigned by the system.
4. number includes floats and integers.
5. bigint
6. string //any letter or number or special character.
7. symbol -(ES6 ES2015)

- Object
  - an object is a member of the built-in type Object. special type. Group of key/value pairs.
  - Function
    - a function is a callable object. A function that is associated with an object via a property is called a method.
  - Date
  - RegExp
  - Array
- Error -built in types, but mostly ignored as a type in JS.

## Boolean

- [MDN Description](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Boolean)
- Do not use the Boolean() constructor with new to convert a non-boolean value to a boolean value.

```js
true;
false;
```

### Boolean Coercion

```js
!true; // false
!!1; // true
const a = Boolean(1); // a = true
const a = new Boolean(1); // Do NOT use boolean constructor.
```

### 7 Falsy Values

1. **false** // typeof 'boolean'
2. **0 || -0** // typeof 'number'
3. **0n** // BigInt
4. **"" || ''** // typeof 'string'
5. **NaN** // typeof 'string'
6. **null** //typeof 'object'
7. **undefined** //typeof 'undefined'
   - undefined is assigned by the system.
   - variable declared but not assigned value
   - property not exist on object //let myProp = {} -call console.log(myProp.name)
   - function returns without a value

**Examples All True**

- negative integers
- empty {} // all objects true
- empty []
- empty ' ' // string with space.
- Symbol // true
- BigInt // except for 0n, all true

## Null

- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/null)
- The value null represents the **intentional** absence of any object value.
- null expresses a lack of identification, indicating that a variable points to no object.

```js
typeof null; // "object" (not "null" for legacy reasons)
```

## Undefined

```js
typeof undefined; // "undefined"
```
