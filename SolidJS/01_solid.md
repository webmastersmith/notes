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
- functions that access signals, are **derived signals**. They gain their reactivity from the signal they access.

# Methods ----------------------------------------------------------------

### Effects

- <https://www.solidjs.com/tutorial/introduction_effects>
- pushed to end of DOM update
- onMount()
- **observers** that depend on a signal.

## createEffect

- runs after page load.
- any page side effects you want to run. any 'signal' included inside the 'effect' will run when the signal is updated.

```tsx
const [sig, setSig] = createSignal('settings');
createEffect(() => setSig('home')); // only runs once, after page load.

return <h1>This is the {sig()} </h1>; // changes after page load.
```

## createMemo

- <https://www.solidjs.com/tutorial/introduction_memos>
- use memos to evaluate a function and store the result until its dependencies change.
- This is great for **caching calculations** for **effects that have other dependencies** and mitigating the work required for expensive operations like DOM node creation.
- Memos are both an observer, like an effect, and a read-only signal.
- Memos are preferable to registering effects that write to signals.

```tsx
import { render } from 'solid-js/web';
import { createSignal, createMemo } from 'solid-js';

function fibonacci(num) {
  if (num <= 1) return 1;
  return fibonacci(num - 1) + fibonacci(num - 2);
}

function Counter() {
  const [count, setCount] = createSignal(10);
  const fib = createMemo(() => fibonacci(count()));
  // prettier-ignore
  return (
    <>
      <button onClick={() => setCount(count() + 1)}>Count: {count()}</button>
      <div>1. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
      <div>2. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
      <div>3. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
      <div>4. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
      <div>5. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
      <div>6. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
      <div>7. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
      <div>8. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
      <div>9. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
      <div>10. {fib()} {fib()} {fib()} {fib()} {fib()}</div>
    </>
  );
}
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

## Dynamic

- <https://www.solidjs.com/tutorial/flow_dynamic>
- replaces `<Switch> <Match>...` statements with single statement.

```tsx
import { render, Dynamic } from 'solid-js/web';
import { createSignal, Switch, Match, For } from 'solid-js';

const RedThing = () => <strong style="color: red">Red Thing</strong>;
const GreenThing = () => <strong style="color: green">Green Thing</strong>;
const BlueThing = () => <strong style="color: blue">Blue Thing</strong>;

const options = {
  red: RedThing,
  green: GreenThing,
  blue: BlueThing,
};

function App() {
  const [selected, setSelected] = createSignal('red');

  return (
    <>
      <select
        value={selected()}
        onInput={(e) => setSelected(e.currentTarget.value)}
      >
        <For each={Object.keys(options)}>
          {(color) => <option value={color}>{color}</option>}
        </For>
      </select>
      <Dynamic component={options[selected()]} />
    </>
  );
}
```

## Lazy Loading

```ts
// Users and Home components will only be loaded if you're navigating to them.
import { lazy } from 'solid-js';
import { Routes, Route } from '@solidjs/router';
const Users = lazy(() => import('./pages/Users'));
const Home = lazy(() => import('./pages/Home'));
```

## onCleanup

- <https://www.solidjs.com/tutorial/lifecycles_oncleanup>
- `onCleanup`is a first-class method. You can call it at any scope and it will run when that scope is triggered to re-evaluate and when it is finally disposed.
- Use it in your components or in your Effects.
- `onCleanup(() => cancelAnimationFrame(frame));`
- ` onCleanup(() => clearInterval(timer));`

```tsx
import { render } from 'solid-js/web';
import { createSignal, onCleanup } from 'solid-js';

function Counter() {
  const [count, setCount] = createSignal(0);

  const timer = setInterval(() => setCount(count() + 1), 1000);
  onCleanup(() => clearInterval(timer));

  return <div>Count: {count()}</div>;
}
```

## onMount

- <https://www.solidjs.com/tutorial/lifecycles_onmount>
- pushed to end of DOM update.
- only runs once, after all initial rendering is done.
- Lifecycles are only run in the browser, so putting code in onMount has the benefit of not running on the server during SSR.

```tsx
import { onMount } from 'solid-js';
onMount(async () => {
  const res = await fetch(
    `https://jsonplaceholder.typicode.com/photos?_limit=30`
  );
  setPhotos(await res.json());
});
```

## Portal

- <https://www.solidjs.com/tutorial/flow_portal>
- used for **Modals**.
- anything you would take out of the flow with `z-index`, use `<Portal>` instead.

```tsx
import { render, Portal } from 'solid-js/web';
import './styles.css';

function App() {
  return (
    <div class="app-container">
      <p>Just some text inside a div that has a restricted size.</p>
      <Portal>
        <div class="popup">
          <h1>Popup</h1>
          <p>Some text you might need for something or other.</p>
        </div>
      </Portal>
    </div>
  );
}
```

## Props

- <https://www.solidjs.com/tutorial/bindings_spreads>
- **spread**
  - `<Info {...pkg} />`

## Ref

- <https://www.solidjs.com/tutorial/bindings_refs>
- You can always get a reference to a DOM element in Solid through assignment,
  - `const myDiv = <div>My Element</div>;` // slows render.
- Instead you can get a reference to an element in Solid using the ref attribute.
- Refs are basically assignments like the example above, which happen at creation time before they are attached to the document DOM.
- **forward ref**
  - `<canvas ref={props.ref} width="256" height="256" />`

```tsx
let myDiv;
<div ref={myDiv}>My Element</div>;
<div ref={el => /* do something with element */}>My Element</div>;
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

## Show

- <https://www.solidjs.com/tutorial/flow_show>
- **Show** is for conditionals `a ? a : b` and `a && b`.
- see **Suspense**

```tsx
import { render } from 'solid-js/web';
import { createSignal, Show } from 'solid-js';

function App() {
  const [loggedIn, setLoggedIn] = createSignal(false);
  const toggle = () => setLoggedIn(!loggedIn());

  return (
    <Show when={loggedIn()} fallback={<button onClick={toggle}>Log in</button>}>
      <button onClick={toggle}>Log out</button>
    </Show>
  );
}
```

### State

- onMount // only runs one time.
- createEffect
- createSignal
- createStore

## Suspense

- <https://www.solidjs.com/tutorial/async_suspense>

```ts
<Suspense fallback={<p>Loading...</p>}>
  <Show when={episode()}>
    <Greeting name="Jake" />
  </Show>
</Suspense>
```

## Switch / Match

- <https://www.solidjs.com/tutorial/flow_switch>
- It will try in order to match each condition, stopping to render the first that evaluates to true. Failing all of them, it will render the the fallback.
- Use in place of `<Show>` when you have multiple options.

```tsx
<Switch fallback={<p>{x()} is between 5 and 10</p>}>
  <Match when={x() > 10}>
    <p>{x()} is greater than 10</p>
  </Match>
  <Match when={5 > x()}>
    <p>{x()} is less than 5</p>
  </Match>
</Switch>
```
