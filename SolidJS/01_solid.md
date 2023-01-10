# Solidjs

## Templates

- <https://github.com/solidjs/templates/>

## Examples

- <https://github.com/solidjs/solid/blob/main/documentation/resources/examples.md>

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

## batch

- <https://www.solidjs.com/tutorial/reactivity_batch?solved>
- when multiple functions are ran, prevents double

```tsx
import { createSignal, batch } from 'solid-js';

const App = () => {
  const [firstName, setFirstName] = createSignal('John');
  const [lastName, setLastName] = createSignal('Smith');
  const fullName = () => {
    console.log('Running FullName');
    return `${firstName()} ${lastName()}`;
  };
  // without batch, this function will run twice with each button click.
  const updateNames = () => {
    console.log('Button Clicked');
    batch(() => {
      setFirstName(firstName() + 'n');
      setLastName(lastName() + '!');
    });
  };

  return <button onClick={updateNames}>My name is {fullName()}</button>;
};
```

## context

- <https://www.solidjs.com/tutorial/stores_context>
- To get started we create a Context object. This object contains a Provider component used to inject our data.

````tsx
// create context
import { createSignal, createContext, useContext } from 'solid-js';
const CounterContext = createContext();
export function CounterProvider(props) {
  const [count, setCount] = createSignal(props.count || 0),
    counter = [
      count,
      {
        increment() {
          setCount((c) => c + 1);
        },
        decrement() {
          setCount((c) => c - 1);
        },
      },
    ];
  return (
    <CounterContext.Provider value={counter}>
      {props.children}
    </CounterContext.Provider>
  );
}
export function useCounter() {
  return useContext(CounterContext);
}
// wrap children
render(
  () => (
    <CounterProvider count={1}>
      <App />
    </CounterProvider>
  ),
  document.getElementById('app')
);
// useContext
export default function Nested() {
  const [count, { increment, decrement }] = useCounter();
  return (
    <>
      <div>{count()}</div>
      <button onClick={increment}>+</button>
      <button onClick={decrement}>-</button>
    </>
  );
};
```

## createEffect

- runs after page load.
- any page side effects you want to run. any 'signal' included inside the 'effect' will run when the signal is updated.

```tsx
const [sig, setSig] = createSignal('settings');
createEffect(() => setSig('home')); // only runs once, after page load.

return <h1>This is the {sig()} </h1>; // changes after page load.
````

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
- **Signals for async request.**
- Signals designed specifically to handle Async loading. Their purpose is to wrap async values in a way that makes them easy to interact with in Solid's distributed execution model.
- The goal is for async to not block execution and not color our code.
  - A query to an async data fetcher function that returns a promise. The contents of the fetcher function can be anything. You can hit typical REST endpoints or GraphQL or anything that generates a promise.
- The resulting `Resource Signal` also contains reactive **loading** and **error** properties that make it easy to control our view based on the current status.
- `const [user, { mutate, refetch }] = createResource(userId, fetchUser);`
  - `mutate` // directly update internal signal
  - `refetch` // manually fetch data.
- **problems**
  - when navigation happens resource will refetch.
  - when params change, resource will refetch.

```tsx
import { createResource } from 'solid-js';
// returns a function.
const [data] = createResource(async () => {
  return fetch('https://www.learnwithjason.dev/api/schedule').then((res) =>
    res.json()
  );
});

<div>{JSON.stringify(data())}</div>;

// complex example
import { createSignal, createResource } from 'solid-js';
import { render } from 'solid-js/web';
const fetchUser = async (id) =>
  (await fetch(`https://swapi.dev/api/people/${id}/`)).json();
const App = () => {
  const [userId, setUserId] = createSignal();
  const [user, { mutate, refetch }] = createResource(userId, fetchUser); //when 'userId' changes, fetchUser will be called.
  return (
    <>
      <input
        type="number"
        min="1"
        placeholder="Enter Numeric Id"
        onInput={(e) => setUserId(e.currentTarget.value)}
      />
      <span>{user.loading && 'Loading...'}</span>
      <div>
        <pre>{JSON.stringify(user(), null, 2)}</pre>
      </div>
    </>
  );
};
```

## createSignal

- signal is the reactive part of solidjs. Any element subscribing to the signal, will automatically update when signal updates.
- `const [sig, setSig] = createSignal(0)` // can be single, object, array.
  - getter and setter function.
  - `<h1>{sig()}</h1>` // must call function.
  - `setSig(c => c+1)` // uses previous value, or `setSig(sig()+ 1)`
- will always re-render the DOM node linked to the signal value.
- signals can be global, and exported, but data is not persistent. If you change pages or refresh, data will be lost.
  - `export const [data, setData] = createSignal(0)`
  - `import { data, setData } from '~/index.tsx'`

```tsx
import { createSignal, createMemo, createRoot } from 'solid-js';
function createCounter() {
  const [count, setCount] = createSignal(0);

```

# createStore

- `const [store, setStore] = createStore({})` // can only be an array or object.
- will only update the property that changed. Does not re-render all linked DOM nodes when one value is changed.
- **solves nested reactivity**. All objects are wrapped in a **proxy** and the properties are tracked and any nested objects inside the proxy are wrapped in a proxy and also have their properties tracked.
- all Signals in Stores are created lazily as requested.
- The `createStore` call takes the initial value and returns a read/write tuple similar to Signals.
- **produce**
  - 3rd party libraries might need this.
  - <https://www.solidjs.com/tutorial/stores_mutation>
  - function that allows you to mutate `store` state and still maintain reactivity with functions like `push`.

```tsx
// createStore todos
import { render } from 'solid-js/web';
import { For } from 'solid-js';
import { createStore } from 'solid-js/store';

const App = () => {
  let input;
  let todoId = 0;
  const [todos, setTodos] = createStore([]);

  const addTodo = (text) => {
    setTodos([...todos, { id: ++todoId, text, completed: false }]);
  };

  const toggleTodo = (id) => {
    setTodos(
      (todo) => todo.id === id,
      'completed',
      (completed) => !completed
    );
  };

  return (
    <>
      <div>
        <input ref={input} />
        <button
          onClick={(e) => {
            if (!input.value.trim()) return;
            addTodo(input.value);
            input.value = '';
          }}
        >
          Add Todo
        </button>
      </div>
      <For each={todos}>
        {(todo) => {
          const { id, text } = todo;
          console.log(`Creating ${text}`);
          return (
            <div>
              <input
                type="checkbox"
                checked={todo.completed}
                onchange={[toggleTodo, id]}
              />
              <span
                style={{
                  'text-decoration': todo.completed ? 'line-through' : 'none',
                }}
              >
                {text}
              </span>
            </div>
          );
        }}
      </For>
    </>
  );
};

// produce
const addTodo = (text) => {
  setTodos(
    produce((todos) => {
      todos.push({ id: ++todoId, text, completed: false });
    })
  );
};
const toggleTodo = (id) => {
  setTodos(
    (todo) => todo.id === id,
    produce((todo) => (todo.completed = !todo.completed))
  );
};
```

### global Store

- <https://www.solidjs.com/tutorial/stores_nocontext>
- It doesn't matter if state is inside or outside components. There is no separate concept for global vs local state. It is all the same thing.

```tsx
// create global store with reactive root.
import { createSignal, createMemo, createRoot } from 'solid-js';
function createCounter() {
  const [count, setCount] = createSignal(0);
  const increment = () => setCount(count() + 1);
  const doubleCount = createMemo(() => count() * 2);
  return { count, doubleCount, increment };
}
export default createRoot(createCounter);
// use global store
import { render } from 'solid-js/web';
import counter from './counter';
function Counter() {
  const { count, doubleCount, increment } = counter;
  return (
    <button type="button" onClick={increment}>
      {count()} {doubleCount()}
    </button>
  );
}
render(() => <Counter />, document.getElementById('app'));
```

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

- <https://www.solidjs.com/tutorial/async_lazy>

```ts
// Users and Home components will only be loaded if you're navigating to them.
import { lazy } from 'solid-js';
import { Routes, Route } from '@solidjs/router';
const Users = lazy(() => import('./pages/Users'));
const Home = lazy(() => import('./pages/Home'));
```

## on

- <https://www.solidjs.com/tutorial/reactivity_on>
- helper that enables setting explicit dependencies for effects.

## onCleanup

- <https://www.solidjs.com/tutorial/lifecycles_oncleanup>
- `onCleanup`is a first-class method. You can call it at any scope and it will run when that scope is triggered to re-evaluate and when it is finally disposed.
- Use it in your components or in your Effects.
- `onCleanup(() => cancelAnimationFrame(frame));`
- ` onCleanup(() => clearInterval(timer));`
- `onCleanup(() => document.body.removeEventListener("click", onClick));`

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
- Props are what we call the **object** that is passed to our component function on execution that represents all the attributes bound to its JSX.
- Props objects are readonly and have reactive properties which are wrapped in Object getters.
- For this reason it is also **very important to not destructure props objects**, as that would lose reactivity if not done within a tracking scope.
  - This applies not just to destructuring, but also to spreads and functions like Object.assign.
- **spread**
  - spread in an object. // `props.name, props.id, ...`
  - `<Info {...pkg} />`
- **mergeProps**
  - which merges potentially reactive objects together
- **splitProps**
  - destructuring will loose reactivity.
- **children**
  - <https://www.solidjs.com/tutorial/props_children>
  - when you work with children, you need to be careful to avoid creating the children multiple times.
  - Solid has the `children` helper. This method both creates a `memo` around the children prop and resolves any nested child reactive references so that you can **interact with the children directly**.

```tsx
//
import { render } from 'solid-js/web';
import { createSignal } from 'solid-js';
import Greeting from './greeting';
function App() {
  const [name, setName] = createSignal();
  return (
    <>
      <Greeting greeting="Hello" />
      <Greeting name="Jeremy" />
      <Greeting name={name()} />
      <button onClick={() => setName('Jarod')}>Set Name</button>
    </>
  );
}
// mergeProps
import { mergeProps } from 'solid-js';
export default function Greeting(props) {
  const merged = mergeProps({ greeting: 'Hi', name: 'John' }, props);
  return (
    <h3>
      {merged.greeting} {merged.name}
    </h3>
  );
  // return <h3>{props.greeting || "Hi"} {props.name || "John"}</h3>
}

// splitProps
export default function Greeting(props) {
  const [local, others] = splitProps(props, ['greeting', 'name']);
  return (
    <h3 {...others}>
      {local.greeting} {local.name}
    </h3>
  );
}

// children props - memoize it to avoid re-creating children with attribute change.
import { createEffect, children } from 'solid-js';
export default function ColoredList(props) {
  const c = children(() => props.children);
  createEffect(() => c().forEach((item) => (item.style.color = props.color)));
  return <>{c()}</>;
}
// parent
import { render } from 'solid-js/web';
import { createSignal, For } from 'solid-js';
import ColoredList from './colored-list';
function App() {
  const [color, setColor] = createSignal('purple');
  return (
    <>
      <ColoredList color={color()}>
        {' '}
        // parent. // creating multiple children, passing in props.
        <For each={['Most', 'Interesting', 'Thing']}>
          {(item) => <div>{item}</div>}
        </For>{' '}
        // child
      </ColoredList>
      <button onClick={() => setColor('teal')}>Set Color</button>
    </>
  );
}
```

## Ref

- <https://www.solidjs.com/tutorial/bindings_refs>
- You can always get a reference to a DOM element in Solid through assignment,
  - `const myDiv = <div>My Element</div>;` // slows render.
- Instead you can get a reference to an element in Solid using the ref attribute.
- Refs are basically assignments like the example above, which happen at creation time before they are attached to the document DOM.
- **forward ref**
  - parent can have access to child DOM node.
  - `<Parent ref={myRef} />`
    - `<div ref={props.myRef} >child</div>`

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
- coordinates display of multiple async events. Shows a fallback until content is loaded.
- This can improve user experience by **removing visual jank** caused by too many intermediate and partial loading states.
- Suspense automatically detects any descendant async reads and acts accordingly. **You can nest as many Suspense components as needed** and only the nearest ancestor will transform to fallback when the loading state is detected.

```ts
<Suspense fallback={<p>Loading...</p>}>
  <Show when={episode()}>
    <Greeting name="Jake" />
  </Show>
</Suspense>;
// or
function Deferred(props) {
  const [resume, setResume] = createSignal(false);
  setTimeout(() => setResume(true), 0);
  return <Show when={resume()}>{props.children}</Show>;
}
```

## SuspenseList

- <https://www.solidjs.com/tutorial/async_suspense_list>
- coordinate multiple loading states.
- **revealOrder**
  - `<SuspenseList revealOrder="forwards"`
  - **forwards** // reveal in the order they appear in the tree, regardless when they are received.
  - **backwards** // reverse the order they appear.
  - **together** // wait for all before revealing.
- **tail**
  - **hidden** // show no fallbacks
  - **collapsed** //

## Switch / Match

- <https://www.solidjs.com/tutorial/flow_switch>
- It will try in order to match each condition, stopping to render the first that evaluates to true. Failing all of them, it will render the the fallback.
- Use in place of `<Show>` when you have multiple options.
- see **Dynamic** for more options.

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

## untrack

- <>
- prevent events from being notified of change.

```tsx
import { createSignal, createEffect, untrack } from 'solid-js';

const App = () => {
  const [a, setA] = createSignal(1);
  const [b, setB] = createSignal(1);

  // effect will not be notified if 'b' changes. 'setB' will still work.
  createEffect(() => {
    console.log(a(), untrack(b));
  });

  return (
    <>
      <button onClick={() => setA(a() + 1)}>Increment A {a}</button>
      <button onClick={() => setB(b() + 1)}>Increment B {b}</button>
    </>
  );
};
```

## useTransition

- <https://www.solidjs.com/tutorial/async_transitions>
- Suspense allows us to show fallback content when data is loading. This is great for initial loading, but on subsequent navigation it is often worse UX to fallback to the skeleton state.

```tsx
import { createSignal, Suspense, Switch, Match, useTransition } from 'solid-js';
import { render } from 'solid-js/web';
import Child from './child';

import './styles.css';

const App = () => {
  const [tab, setTab] = createSignal(0);
  const [pending, start] = useTransition();
  const updateTab = (index) => () => start(() => setTab(index));

  return (
    <>
      <ul class="inline">
        <li classList={{ selected: tab() === 0 }} onClick={updateTab(0)}>
          Uno
        </li>
        <li classList={{ selected: tab() === 1 }} onClick={updateTab(1)}>
          Dos
        </li>
        <li classList={{ selected: tab() === 2 }} onClick={updateTab(2)}>
          Tres
        </li>
      </ul>
      <div class="tab" classList={{ pending: pending() }}>
        <Suspense fallback={<div class="loader">Loading...</div>}>
          <Switch>
            <Match when={tab() === 0}>
              <Child page="Uno" />
            </Match>
            <Match when={tab() === 1}>
              <Child page="Dos" />
            </Match>
            <Match when={tab() === 2}>
              <Child page="Tres" />
            </Match>
          </Switch>
        </Suspense>
      </div>
    </>
  );
};

render(App, document.getElementById('app'));
```
