# Loops

## For

- <https://www.solidjs.com/tutorial/flow_for>

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
```
