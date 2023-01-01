# Error Boundary

- <https://www.solidjs.com/tutorial/flow_error_boundary>
- catch JS errors anywhere in their child component tree, log errors, display fallback UI.

```tsx
import { render } from 'solid-js/web';
import { ErrorBoundary } from 'solid-js';

const Broken = (props) => {
  throw new Error('Oh No');
  return <>Never Getting Here</>;
};

function App() {
  return (
    <>
      <div>Before</div>
      <ErrorBoundary fallback={(err) => err}>
        <Broken />
      </ErrorBoundary>
      <div>After</div>
    </>
  );
}
```
