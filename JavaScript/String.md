# String

- [code units, code points, bytes, pixels, terminal columns](https://blog.bitsrc.io/how-big-is-a-string-ef2af3d222e6)
- strings are immutable. `str[0] = 'B'` // will not work

## Iterate

- for of

```js
for (const c of str) {
  console.log(c);
}
```

- spread

```js
const s = [...str].map((c) => c);
```

## Whitespace

- <https://dmitripavlutin.com/javascript-string-trim/>
- SPACE (U+0020 code point)
- CHARACTER TABULATION (U+0009 code point)
- LINE TABULATION (U+000BU code point)
- FORM FEED (FF) (U+000C code point)
- NO-BREAK SPACE (U+00A0 code point)
- ZERO WIDTH NO-BREAK SPACE (U+FEFFU code point)
- Any other character from Space Separator category
- Common whitespace characters are space ' ', '\s' and tab '\t'.

## String Mismatch:

- string.trim() // possibly whitespace
- string.length // to verify hidden characters.

## Template Strings

- In JS there is no difference between single quotes and double quotes.
- <https://www.taniarascia.com/understanding-template-literals/>
- using `map` inside a template literal will have to end `.join('')`
  - else a comma will be added to beginning of every string returned.

```js
let myName = 'Bob'
console.log(`My name is ${myName} and I'm cool!`)
`${arr.map(do-something).join('')}`
```

# Carriage Returns / Line Feeds

**Line Terminators**

- `\r\n` // windows
  - CR = Carriage Return ( \r , 0x0D in hexadecimal, 13 in decimal) — moves the cursor to the beginning of the line without advancing to the next line.
  - windows a line is represented with a carriage return (CR) and a line feed (LF) thus (CRLF). (\r\n)
- `\n` // linux
  - LF = Line Feed ( \n , 0x0A in hexadecimal, 10 in decimal) — moves the cursor down to the next line without returning to the beginning of the line.
  - Unix systems the end of a line is represented with a line feed (LF).
  - when you get code from git that was uploaded from a unix system they will only have an LF.

## [Methods](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String)

**[includes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/includes)**

- <https://www.w3schools.com/jsref/jsref_obj_string.asp>

```js
str.includes('s');
```

# Regex

```js
// find and remove blank lines
split(/\r?\n\s*\r?\n/).join(os.EOL);

// every match replace with function return value.
str.replace(/\b(lt|lte|gt|gte)\b/g, (m) => `$${m}`);
```

# Slice 

- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/slice>
- returns new string
- immutable
- str.slice(inclusive, exclusive);

```js
str.slice(4, 19); // inclusive, exclusive
str1.slice(4, -2); // stop 2 from end. the -2 is exclusive.
```

# Split

**str.split every n characters**

```js
const arr = ['01010101101010101010101010110101010101000101010101'];
arr[0].match(/.{1,5}/g); // ['01010', '10110', ...]

// keep the delimiter
const lines = 'str'.split(/(?<=\n)/g); //split on '\n' but keep it. This is a positive lookbehind regex. Must have parens.
```
