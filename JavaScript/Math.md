# Math

- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math)
- <https://hikari.noyu.me/blog/2022-04-01-javascript-is-a-safer-language-for-integer-programming-than-c.html>
- In JavaScript, a + b with integer inputs could overflow and produce a value that's no longer an integer.\[5\] The resulting value is well-defined and guaranteed by the standard, so it's not the end of the world. But if you want to detect this overflow and handle it, it's easy: if ((a + b) \> 0x7FFFFFFF \|\| (a + b) \< -0x80000000). If you would prefer to have a two's-complement signed integer wraparound, that's also easy: (a + b) \| 0. If you would like an unsigned integer wraparound, add 0x100000000 to that then modulo.

**Operators**

- [**https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/JavaScript_basics**](https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/JavaScript_basics)

**Complete Expression and Operators list:**

- [**https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/JavaScript_basics**](https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/JavaScript_basics)

## ES2021: numeric separators

- `3_451`

## Math Operators

**Integer** is any whole number. Positive or negative.

- <https://exploringjs.com/impatient-js/ch_math.html>
- <https://www.w3schools.com/js/js_operators.asp>
- <https://www.w3schools.com/js/js_math.asp>
  - let a = 5 + 1; // Now a == 6.
- Its called bitwise XOR
  - 45^2 = 2,025 -same as: Math.pow(45, 2)
  - Math.pow(x,2) calculates x² but for square you better use x\*x as
    Math.pow uses logarithms and you get more approximations errors. (
    x² \~ exp(2.log(x)) )

**Floats** // 0.890

- use big.js -see below 'float problems'
- Can be added, subtracted, divided or multiplied.
- Anything with decimal is a float.
- All math variables can be floats.

**Modulus** %

- Mostly used to determine if number is even or odd.
- Does not show decimals.
- View remainder. a = 5 % 2; // a == 1.

**Exponential**

- **`4 ** 5`\*\* // 1024
- Math.pow(4, 5) // 1024

**Compound Assignment**

- Add 1 number or subtract 1 number

  - let a = a + 1; or let a = a++; // Same.
  - let a = a - 1; or let a = a--; // Same.

- Plus, equals operator +=
  - let a = 3; a = a + 12; a += 12; // Same.
  - a += 12
  - a -= 12;
  - a \*= 12;
  - a /= 12;

## Number

**MAX_SAFE_INTERGER**

- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER>
- `Number.MIN_SAFE_INTEGER = -9007199254740991`
- `Number.MAX_SAFE_INTEGER = 9007199254740991`
  - `2^53-1` // 9,007,199,254,740,991

**Infinity**

- JS special values: `Infinity, -Infinity`
- to check for
  - `isFinite(1/0)` // false
  - `isFinite(NaN)` // false

**All Number Methods**

- <https://www.w3schools.com/jsref/jsref_obj_number.asp>

**All Math object methods**

- <https://www.w3schools.com/jsref/jsref_obj_math.asp>

**Format Numbers**

- <https://github.com/s-yadav/react-number-format>
- Number toFixed // floating point
  - `num.toFixed(2)` // returns string
  - `+num.toFixed(2)` // returns number

```js
// number to formatted string
(99999.98).toLocaleString() + //"99,999.98"
  // formatted string to number.
  '99,999.98'.replace(/,/g, '') +
  '99,999.98'.split(',').join('');
```

## NaN

- `NaN + any number` will always return NaN.
- To check for NaN:

  - **Number.isNaN(x)** // this is the proper way to check for NaN.
    - returns `false` for everything not `NaN`.
    - `Boolean(x) === false || x !== x ? true : false` // boolean value equals false and not equal to itself is NaN.
  - NaN is the only value not equal to itself.
  - returns true if something is not a number.
  - It will convert number strings ('34.6') into a number and return
    false.
  - These will register as a number: null, " ", ""

- **Number.isInteger**
  - <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isInteger>
  - If the value is NaN or Infinity, return false.
- **NaN in Arrays**

```js
[NaN].includes(NaN) // true
[NaN].findIndex(x =\> Number.isNaN(x)) // 0
[NaN].find(x => Number.isNaN(x)) // NaN
```

## parseInt(string, radix) // always provide radix. Problems happen when left out.

- returns an integer of the specified radix
  - An integer between 2 and 36
- returns NaN or number.
  - spaces are ignored before and after, but not in between.
  - if first character cannot be converted into a number, will return NaN
  - stops at the first character that cannot be converted into number.

```js
// all return -15
parseInt('-F', 16);
parseInt('-0F', 16);
parseInt('-0XF', 16);
parseInt('-17', 8);
parseInt('-15', 10);
parseInt('-1111', 2);
parseInt('-15e1', 10);
parseInt('-12', 13);
```

# HEX

- 0, 1, 2, 3, 5, 6, 7, 8, 9, A, B, C, D, E, F

# Big Int

- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt>
- a bigint primitive, created by appending n to the end of an integer literal, or by calling the BigInt() constructor (but without the new operator) and giving it an integer value or string value.
- represent whole numbers larger than `2^53 - 1`
- `typeof 1n === 'bigint'` // true
- `typeof BigInt('1') === 'bigint'` // true

```js
const previouslyMaxSafeInteger = 9007199254740991n;

const alsoHuge = BigInt(9007199254740991);
// ↪ 9007199254740991n

const hugeString = BigInt('9007199254740991');
// ↪ 9007199254740991n

const hugeHex = BigInt('0x1fffffffffffff');
// ↪ 9007199254740991n

const hugeOctal = BigInt('0o377777777777777777');
// ↪ 9007199254740991n

const hugeBin = BigInt(
  '0b11111111111111111111111111111111111111111111111111111'
);
// ↪ 9007199254740991n
```

# Coercion

- `+string` same as `Number(string)`
- `string * 1` // returns number.
  <a href="https://stackoverflow.com/questions/17106681/parseint-vs-unary-plus-when-to-use-which"><img src="./images/parseIntvsplus.png" alt="coercion table"></a>
- [**https://javascript.info/operators**](https://javascript.info/operators)
- [**https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number)

**Number()** //returns number

- allowed characters **+ - . e \d+** if any letter, returns NaN
- if used on `Date()`, returns milliseconds since 1.1.1970
  - `let num = Number(new Date())` // 13435690098
- `Number(true)` // 1
- `Number(false)` // 0

**parseInt()** // returns decimal integer

- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt>
- allows characters: **+ - . e \d+** //if first character is digit will always return a number. stops at first letter.
- `parseInt('$2,345.09')` // NaN
  - if first character is not a digit, returns `NaN`
  - returns number only if the first item in string is a digit.
  - **parseInt('11111', 2)** // binary to decimal 32
  - to convert to other bases, use 45.toString(2) // 2-36

**parseFloat()** // returns floating point number

- if cannot convert, returns `NaN`
- if used on string, returns the first number it comes to.
- `- / * %` // all do conversion when used with a string.

**`+`** // always concatenates when one item is a string.

- `+'5'` // 'unary plus' used as a 'unary' operator in front of string.
- Same thing as Number(), but shorter
- applied before adding, because higher precedence.

**Syntactic pitfall: properties of integer literals**

- Accessing a property of an integer literal entails a pitfall: If the integer literal is immediately followed by a dot, then that dot is interpreted as a decimal dot:
- `7.toString();` // syntax error
- There are four ways to work around this pitfall:
  1. `7.0.toString()`
  2. `(7).toString()`
  3. `7..toString()`
  4. `7 .toString()` // space before dot

# Format

- `(2 * 36e5).toLocaleString()` // '7,200,000'

# Decimal Problems

- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/EPSILON>
- <https://stackoverflow.com/questions/11832914/how-to-round-to-at-most-2-decimal-places-if-necessary>

```js
// trying to round to two places
const fixed2 = (num) =< +(Math.round(num + "e+2")+ "e-2") // works good.
fixed2(0.1 + 0.2) //0.3
// 0.1 + 0.2 //0.30000000000000004
// or
Math.round((num + Number.EPSILON) * 100) / 100
```

# Decimal Math

- [Article](https://thecodebarbarian.com/a-nodejs-perspective-on-mongodb-34-decimal.html)

**Rounding decimals**

- was on MDN but removed.

```js
function roundToTwo(num) {
  return +(Math.round(num + 'e+2') + 'e-2');
}
// or
(num: number, places: number) => Math.round(num * 10 ** places) / 10 ** places;

console.log('1.005 => ', roundToTwo(1.005)); // 1.01
console.log('10 => ', roundToTwo(10)); // 10
console.log('1.7777777 => ', roundToTwo(1.7777777)); // 1.78
console.log('9.1 => ', roundToTwo(9.1)); // 9.1
console.log('1234.5678 => ', roundToTwo(1234.5678)); //1234.57

// extend Number.prototype.round
Number.prototype.round = function (places) {
  return +(Math.round(this + 'e+' + places) + 'e-' + places);
};
(8 / 3).round(2); // 2.67 -normally would output: 2.6666666666666665
```

# Math.Random

- [_https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random)
- [_https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random)
- Math.random() does not provide cryptographically secure random numbers. Do not use them for anything related to security. Use the Web Crypto API instead, and more precisely the [_window.crypto.getRandomValues()_](https://developer.mozilla.org/en-US/docs/Web/API/Crypto/getRandomValues) method.
- Returns a Number value with positive sign, greater than or equal to 0 but less than 1, chosen randomly or pseudo randomly. This function takes no arguments.

- - JS doesn’t do anything, it’s up to the browser
  - As of 2015, most browsers use an algorithm called `xorshift128+`
  - The numbers generated by `xorshift128+` aren’t really random, the
    sequence just take a long time to repeat and they’re relatively
    evenly distributed over the expected range of values.

```js
// Math.ceil & Math.floor & Math.round
Math.ceil(Math.random() * 3); // 1 - 3
Math.floor(Math.random() * 3); // 0 - 2
Math.floor(Math.random() * 6) + 1; // 1 - 6
Math.round(Math.random() * 5); // 0 - 5
Math.round(Math.random() * 5) + 1; // 1 - 6

// function -returns number between min & max, including min & max.
function getRndInteger(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

// rand with logic.
function rand(min, max) {
  var argc = arguments.length;
  if (argc === 0) {
    min = 0;
    max = 2147483647;
  } else if (argc === 1) {
    throw new Error('Warning: rand() expects exactly 2 parameters, 1 given');
  }
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
```

# Money

**Best Practice**

- <https://dev.to/damxipo/handle-money-with-js-4a13>
- Working with floating numbers

```js
// 1. Multiply each value by 100:
// prettier-ignore
(0.2 * 100 + 0.1 * 100) // = 30 cents.
// 2. Recover the value to money: 
(0.2 * 100 + 0.1 * 100) / 100 // = 0.30
```

**Dinerojs**

- <https://dinerojs.com/>
- <https://dinerojs.com/dinero.js.html>
  - Dinero has to be used with minor currency units (aka 'cents'). // $0.30 should be used as 30.

**@dintero/money**

- <https://www.npmjs.com/package/@dintero/money>

**Bigjs**

- <https://mikemcl.github.io/big.js/>
- 6 KB minified
- do not use const if you are switching back and forth from Big() object, toNumber().

```js
import Big from 'big.js';
// Big.strict = true  // all numbers must be string or big. False is default.
// new is optional.
const phone = new Big(100);
const tax = new Big(1.0825);
const total = phone.plus(Big(25)).times(tax).round(2).toNumber(); //135.31
```

- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toLocaleString#Browser_Compatibility>

```js
log(expo(26, 9).toLocaleString()); // 5,429,503,678,976
log(
  expo(26, 9).toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })
); // 5,429,503,678,976.00

num.toLocaleString('en-US', {
  minimumFractionDigits: 2,
  maximumFractionDigits: 2,
  style: 'currency',
  currency: 'USD',
});
```

# Formulas

**Fahrenheit to Celsius**

- `∘C=(∘F–32)×5/9` // f to c
- `∘F=∘C×9/5+32` // c to f
