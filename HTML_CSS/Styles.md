# Styles

## Modules

- import

```tsx
import styles from './App.module.scss';
```

## Solidjs

- <https://stackoverflow.com/questions/72297265/conditional-styling-in-solidjs>

```tsx
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
