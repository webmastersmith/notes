# Generators

- <https://dev.to/muqsitadam/javascript-generators-a-beginners-guide-1ojf>
- Generators are functions that can be exited and later re-entered. (paused and resumed)
- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function*)
- a generator object is an iterator
- `generator.next().value` will return just value and not object.
- Generator functions do not have `arrow function` counterparts.

<img src="./images/generator_example.png" alt="Generator Example">

```ts
function* createGenerator() {
  yield 'This';
  yield 'is';
  yield 'a';
  yield 'Generator';
}
const generator = createGenerator(); // assigning the Generator function to the generator constant
generator.next(); // { value: 'This', done: false } // generator.next().value = 'This'
generator.next(); // { value: 'is', done: false }
generator.next(); // { value: 'a', done: false }
generator.next(); // { value: 'Generator', done: false }
generator.next(); // { value: undefined, done: true }

// array
// create an array of animals
const animals = ['Cat', 'Dog', 'Monkey', 'Bird', 'Fish'];

// create our looping generator
function* loop(arr) {
  for (const item of arr) {
    yield `I like a ${item} as a pet`;
  }
}

const animalGen = loop(animals);
console.log(animalGen.next()); // Object { value: "I like a Cat as a pet", done: false }
console.log(animalGen.next()); // Object { value: "I like a Dog as a pet", done: false }
console.log(animalGen.next().value); // "I like a Monkey as a pet"

// return()
function* animalsList() {
  yield 'Cat';
  yield 'Dog';
  yield 'Monkey';
}

const animals = animalsList();
console.log(animals.return()); // Object { value: undefined, done: true }
```
