# Errors

**try catch error**

- [Kent Dodds ](https://kentcdodds.com/blog/get-a-catch-block-error-message-with-typescript)

```js
try {
  throw new Error("Oh no!");
} catch (error) {
  if (error instanceof Error) {
    console.log(error.message);
  } else {
    console.log(String(error));
  }
}

// function
function getErrorMessage(error: unknown) {
  if (error instanceof Error) return error.message;
  return String(error);
}
```
