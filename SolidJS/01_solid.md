# solidjs

## Templates

- <https://github.com/solidjs/templates/>

**solid.sh**

- add to .local/bin //your custom path.

```sh
#! /bin/bash
# typescript starter
# solid "NAME-OF-PROJECT"
npx degit solidjs/templates/ts-sass "$1" -y
cd "$1"
npm install # or pnpm install or yarn install
# get router
npm i @solidjs/router
mkdir -p src/pages
cd src/pages
touch index.ts
```

# Effects

- <https://www.solidjs.com/tutorial/introduction_effects>
- pushed to end of DOM update
- onMount()

## Create Effect

- runs after page load

```tsx
const [sig, setSig] = createSignal('settings');
createEffect(() => setSig('home'));

return <h1>This is the {sig()} </h1>; // changes after page load.
```

## Create Signal / Store / State

- **createSignal**
  - `const [sig, setSig] = createSignal(0)` // can be single, object, array.
    - getter and setter function.
    - `<h1>{sig()}</h1>` // must call function.
  - will always re-render what DOM node is linked to value.
- **createStore**
  - `const [store, setStore] = createStore({})` // array or object.
  - will only update the property that changed. Does not re-render all linked DOM nodes when one value is changed.

### State

- onMount // only runs one time.
- createEffect
- createSignal
- createStore

## Lazy Loading

```ts
// Users and Home components will only be loaded if you're navigating to them.
import { lazy } from 'solid-js';
import { Routes, Route } from '@solidjs/router';
const Users = lazy(() => import('./pages/Users'));
const Home = lazy(() => import('./pages/Home'));
```

## onMount

- <https://www.solidjs.com/tutorial/lifecycles_onmount>
- pushed to end of DOM update.
- only runs once, once all initial rendering is done.

```tsx
import { onMount } from 'solid-js';
onMount(async () => {
  const res = await fetch(
    `https://jsonplaceholder.typicode.com/photos?_limit=30`
  );
  setPhotos(await res.json());
});
```

## Router

- <https://www.npmjs.com/package/@solidjs/router>
- <https://github.com/solidjs/solid-router>
- `import { Router } from "@solidjs/router";`
  - wrap app with `<Router><App /></Router>`

```tsx
// index.tsx
import { render } from 'solid-js/web';
import { Router } from '@solidjs/router';
import App from './App';

render(
  () => (
    <Router>
      <App />
    </Router>
  ),
  document.getElementById('app')
);

// App.tsx
import { lazy } from 'solid-js';
import { Routes, Route, A } from '@solidjs/router';
const Users = lazy(() => import('./pages/Users'));
const Home = lazy(() => import('./pages/Home'));

export default function App() {
  return (
    <>
      <h1>My Site with Lots of Pages</h1>
      <nav>
        <A href="/about">About</A>
        <A href="/">Home</A>
      </nav>
      <Routes>
        <Route path="/users" component={Users} />
        <Route path="/" component={Home} />
        <Route
          path="/about"
          element={<div>This site was made with Solid</div>}
        />
      </Routes>
    </>
  );
}
```
