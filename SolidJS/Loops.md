# Loops

- Array.prototype.map // forces DOM to rerender every loop.

**For vs Index**

- `<For>` component uses **referential equality** to compare elements to the last state of the array.
  - **referential equality:** two objects are referentially equal when the pointers of the two objects are the same or when the operators are the same object instance.
  - based on memory location and not value.
  - In JavaScript, primitives (like strings and numbers) are always compared by value.
  1. Both values are undefined or null.
  2. Both values are either true or false.
  3. Both values are Strings having the same characters, length, and order.
  4. Both values are Numbers with the same value or NaN.
  5. Both values are Objects that point to one memory location.
- This is undesirable with input boxes, because value will change and the DOM node will have to recreated.
  - use `Index` in these cases.

## For

- <https://www.solidjs.com/tutorial/flow_for>
- DOM does not have to rerender on every call. Allows for tracking of data updates, and only has to render what is changed.
- wraps each item in a **Component**
- As the array changes, `<For>` updates or moves items in the DOM rather than recreating them.
- The only prop on **For** is **each**.
  - pass the array to loop over.
- Note that the **index is a signal**, not a constant number. This is because `<For>` is "keyed by reference": each node that it renders is coupled to an element in the array.
  - if an element changes placement in the array, rather than being destroyed and recreated, the corresponding node will move too and its index will change.
- you can turn other iterable objects into arrays with utilities like `Array.from, Object.keys, or spread syntax`.

```tsx
import { For } from 'solid-js';
<For each={cats()} fallback={<p>Loading...</p>}>
  {(cat, i) => (
    <li>
      <a target="_blank" href={`https://www.youtube.com/watch?v=${cat.id}`}>
        {i() + 1}: {cat.name}
      </a>
    </li>
  )}
</For>;

// another
<ul>
  <For each={data()}>{(item: any) => <li>{item.title}</li>}</For>;
</ul>;
```

## Index

- <https://www.solidjs.com/tutorial/flow_index>
- purpose is to cause less rerenders in certain situations.
- It has a similar signature to `<For>`, except this time the item is the signal and the index is fixed.
- Whenever the data in that spot changes, the signal will update.
- `<Index>` cares about each index in your array, and the content at each index can change.
- `Index` is for elements like `<input>` fields, where every change to that value would cause the `<input>` to be recreated.
