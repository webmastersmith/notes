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

## [Methods](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String)

**[includes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/includes)**

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
