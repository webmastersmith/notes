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

## Rendering

- <https://github.com/solidjs/solid/tree/main/packages/solid-ssr>
- There are three choices for implementing a SPA:
  - **Server-Side Rendering** (SSR): In the SSR, the server produces the application on the fly.
  - **Client-Side Rendering** (CSR): In the CSR, the browser is the thing that leads everything and gets the basic data from the server, and the application generates the views and introduces it into the DOM.
  - **Static Site Generators** (SSG): With SSG, the server returns a well-organized HTML with almost all the info. This approach is the fastest, but if you need to make a small change, the new page’s generation process will take time.

## Components

- functions that return `JSX`. Have access to **props**.

## Exports

- solidjs Components can have **default exports**.
- `export default () => <p>This is a Paragraph</p>`

## Signals

- createSignal, createStore
- when you change a signal's value, it automatically updates anything that uses it.

# Methods ----------------------------------------------------------------

### Effects

- <https://www.solidjs.com/tutorial/introduction_effects>
- pushed to end of DOM update
- onMount()
- observers that depend on a signal.

## createEffect

- runs after page load.
- any page side effects you want to run. any 'signal' included inside the 'effect' will run when the signal is updated.

```tsx
const [sig, setSig] = createSignal('settings');
createEffect(() => setSig('home')); // only runs once, after page load.

return <h1>This is the {sig()} </h1>; // changes after page load.
```

## createRenderEffect

- render before the DOM loads.
- <https://www.solidjs.com/docs/latest/api#createrendereffect>

## createResource

- <https://www.solidjs.com/tutorial/async_resources>

```tsx
import { createResource } from 'solid-js';
// returns a function.
const [data] = createResource(async () => {
  return fetch('https://www.learnwithjason.dev/api/schedule').then((res) =>
    res.json()
  );
});

<div>{JSON.stringify(data())}</div>;
```

## createSignal / Store

- **createSignal**
  - `const [sig, setSig] = createSignal(0)` // can be single, object, array.
    - getter and setter function.
    - `<h1>{sig()}</h1>` // must call function.
    - `setSig(c => c+1)` // uses previous value, or `setSig(sig()+ 1)`
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

## Suspense

- <https://www.solidjs.com/tutorial/async_suspense>

```ts
<Suspense fallback={<p>Loading...</p>}>
  <Show when={episode()}>
    <Greeting name="Jake" />
  </Show>
</Suspense>
```
