# Math

- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math)

## parseInt(string, radix) // always provide radix. Problems happen when left out.

- returns an integer of the specified radix
  - An integer between 2 and 36
- retuns NaN or number.
  - spaces are ignored before and after, but not in between.
  - if first character cannot be converted into a number, will return NaN
  - stops at the first character that cannot be converted into number.

```js
// all return -15
parseInt("-F", 16);
parseInt("-0F", 16);
parseInt("-0XF", 16);
parseInt("-17", 8);
parseInt("-15", 10);
parseInt("-1111", 2);
parseInt("-15e1", 10);
parseInt("-12", 13);
```

# Coercion

<a href="https://stackoverflow.com/questions/17106681/parseint-vs-unary-plus-when-to-use-which"><img src="./images/parseIntvsplus.png" alt=""></a>
