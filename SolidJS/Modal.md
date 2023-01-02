# Modal

- <https://www.solidjs.com/tutorial/bindings_directives?solved>

```tsx
// external code
import { onCleanup } from 'solid-js';
export default function clickOutside(el, accessor) {
  const onClick = (e) => !el.contains(e.target) && accessor()?.();
  document.body.addEventListener('click', onClick);
  onCleanup(() => document.body.removeEventListener('click', onClick));
}

// modal
import { render } from 'solid-js/web';
import { createSignal, Show } from 'solid-js';
import clickOutside from './click-outside';
import './style.css';

function App() {
  const [show, setShow] = createSignal(false);

  return (
    <Show
      when={show()}
      fallback={<button onClick={(e) => setShow(true)}>Open Modal</button>}
    >
      <div class="modal" use:clickOutside={() => setShow(false)}>
        Some Modal
      </div>
    </Show>
  );
}
```
