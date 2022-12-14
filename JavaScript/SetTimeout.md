# SetTimeout / SetInterval

## setTimeout

- https://developer.mozilla.org/en-US/docs/Web/API/setTimeout
- always pass a function. //() => console.log()
- clearTimeout()

```js
setTimeout();
const timer = setTimeout(() => console.log('hi'), 1000);
return clearTimeout(timer);
```

**multiple args**

- https://www.freecodecamp.org/news/javascript-settimeout-how-to-set-a-timer-in-javascript-or-sleep-for-n-seconds/

```js
function greeting(name, role) {
  console.log(`Hello, my name is ${name}`);
  console.log(`I'm a ${role}`);
}

setTimeout(greeting, 3000, 'Nathan', 'Software developer');
```

**async**

```js
// Wait, one liner
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms)) //returns undefined
await sleep(2000)

// TypeScript
const sleep = (ms: number): Promise<void> => new Promise((res) => setTimeout(res, ms));
sleep(2000).then(() => console.log("I'm awake!"))
// or
await sleep(2000)
console.log("I'm awake!")


// Promise with setTimeout(), return something.
const promise = new Promise( res => setTimeout(res, 1000, 'Stuff Works!'))
.then(result => console.log(result)) //Stuff Works!
.catch(e => console.log(e))

// curried delay example
const delay = (t) => (v) => new Promise((res) => setTimeout(res.bind(null, v), t)) // time, value
const delayOneSec = delay(1000)
delayOneSec("heelo").then((x) => console.log(x))

//react
useEffect(() => {
const delay = setTimeout(() => {}, 1000ms)

return () => {clearTimeout(delay)}
}, [])
```

## setInterval

- https://developer.mozilla.org/en-US/docs/Web/API/setInterval

```js
const intervalTimer = setInterval(() => doSomething, 1000);
return clearInterval(intervalTimer);
```

## setImmediate() && process.nextTick()

- runs immediately after the event loop I/O queue
- A function passed to `process.nextTick()` is going to be executed on the current iteration of the event loop, after the current operation ends. This means it will always execute before `setTimeout` and `setImmediate`.
- A `setTimeout()` callback with a 0ms delay is very similar to `setImmediate()`. The execution order will depend on various factors, but they will be both run in the next iteration of the event loop.
- Event loop executes tasks in `process.nextTick queue` first, and then executes `promises microtask queue`, and then executes `macrotask queue`.

```js
import fs from 'fs';

(async function () {
  const wait = (ms: number) => new Promise((res) => setTimeout(res, ms));
  setImmediate(() => console.log('Immediate finished'));
  setTimeout(() => console.log('Timeout finished'), 0);
  process.nextTick(() => console.log('Process.nextTick finished!'));
  console.log('I am the top dog!');

  // read file
  await fs.readFile(process.cwd() + '/test-file.txt', 'utf-8', () => {
    setTimeout(() => console.log('Timeout in callback finished'), 0);
    setImmediate(() => console.log('Immediate in callback finished'));
    process.nextTick(() =>
      console.log('Process.nextTick in callback finished!')
    );
    console.log('This is what last looks like :-(');
  });
})();

// output
// I am the top dog!
// Process.nextTick finished!
// Timeout finished
// Immediate finished
// This is what last looks like :-(
// Process.nextTick in callback finished!
// Immediate in callback finished
// Timeout in callback finished
```
