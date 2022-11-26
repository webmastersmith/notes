# Console Module

**Time Program**

```js
const startTime = Date.now(); //or new Date() *then*
startTime.getTime();
// do something
const endTime = Date.now();
console.log(`Total time: ${(endTime - startTime) / 1000}s`); //outputs seconds

//easier way
console.time('First Test'); //label
console.time('Second Test');
console.timeEnd('First Test');
console.timeEnd('Second Test');
```

[Console Methods](https://dev.to/lissy93/fun-with-consolelog-3i59)
