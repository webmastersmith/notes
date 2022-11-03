# If Else Ternary

# Ternary

- <https://blog.thoughtspile.tech/2022/01/17/jsx-conditionals/>
- (score) ? (score = 1, person = 4) : (score = 0, person = 5) // will change two variables.

```js
return arr[n] === 0 ? 1 : arr[n] * arr[n];
// multiple executions.
activePlayer === 0
  ? ((activePlayer = 1),
    document.querySelector('.player-1-panel').classList.remove('active'),
    document.querySelector('.player-0-panel').classList.add('active'))
  : ((activePlayer = 0),
    document.querySelector('.player-0-panel').classList.remove('active'),
    document.querySelector('.player-1-panel').classList.add('active'));

var foo =
  bar === 'a'
    ? 1 // if
    : bar === 'b'
    ? 2 // else if
    : bar === 'c'
    ? 3 // else if
    : null; // else
```

### Nested Ternary

```jsx
// nested ternary
// prettier-ignore
{isEmoji
    ? <EmojiButton /> // true needs to return something.
    : isCoupon // false calls anther ternary
        ? <CouponButton />
        : isLoaded && <ShareButton />}
```
