# Solid Events

[All Events](https://developer.mozilla.org/en-US/docs/Web/API/Element#events)

- all methods can be lowercase or camelCase.
- Events are attributes prefixed with `on`.
- <https://www.solidjs.com/tutorial/bindings_events>

**create custom events**

```tsx
<button on:DOMContentLoaded={() => /* Do something */} >Click Me</button>
```

## onClick

-

## onInput

- keystrokes, select box.

```tsx
function handleSelect(event) {
  setEpisodes(event.target.value);
}

return (
  <select oninput={handleSelect}>
    <For each={data()}>
      {(item: any) => <option value={item.slug.current}>{item.title}</option>}
    </For>
  </select>
);
```

## onMouseMove
