# Solidjs Styles

- <https://stackoverflow.com/questions/72297265/conditional-styling-in-solidjs>
- <https://www.solidjs.com/tutorial/bindings_style>
- <https://www.solidjs.com/docs/latest/api#classlist>
- <https://www.solidjs.com/docs/latest/api#style>
  - accepts strings or objects.
  - object keys take the dash-case form, like "background-color" rather than "backgroundColor", and that any units must be explicitly provided (e.g., width: 500px rather than width: 500).
- **classList**
  - solid uses `class` instead of className.
  - conditionally set classes with `classList`.
  - **key is the class name(s)** and the value is a boolean expression. When true, the class is applied, and when false, it is removed.

```tsx
// class list example -conditional class list.
// dynamic
import { active } from "./style.module.css"
<div classList={{ [active]: isActive() }} />
// object
<button
  classList={{selected: current() === 'foo'}}
  onClick={() => setCurrent('foo')}
>foo</button>
// ternary -old way of doing it.
 <button
  class={current() === 'foo' ? 'selected' : ''}
  onClick={() => setCurrent('foo')}
>foo</button>

// style example
<div style={{
  color: `rgb(${num()}, 180, ${num()})`,
  "font-weight": 800,
  "font-size": `${num()}px`}}
>

<button
  style={{
    color: votes().has(4) ? "blue" : "red",
  }}
  onClick={castVote}
>

<div onclick={toggle}>
  <span>conditon: {cond() ? 'true' : 'false'}</span>
  {` `}
  <span
    style={{ 'background-color': cond() ? 'red' : 'blue', color: 'white' }}
  >
    Using Object
  </span>
  {` `}
  <span
    style={`background-color: ${cond() ? 'red' : 'blue'}; color: white;`}
  >
    Using String
  </span>
</div>
```
