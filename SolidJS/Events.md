# Solid Events

- all methods can be lowercase or camelCase.

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
