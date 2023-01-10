# Solid Start

- <https://start.solidjs.com/getting-started/what-is-solidstart>
- <https://github.com/solidjs/solid-start/tree/main/examples>

## Tutorials

- <https://dev.to/alexmercedcoder/creating-a-todo-list-with-solid-start-and-mongodb-1c4>
- <https://tahazsh.com/blog/building-a-solidjs-app-from-scratch/>

# Glossary

- **RPC** (Remote Procedure Call) one program request service from another program located in another network/computer/location without having to understand the networks details. Sometimes called a 'function call' or 'subroutine call'.
- **data-hk** data-hydration-keys. Allows tracking components and island creation.

# Vite.config.ts

```ts
// vite.config.ts
solid({ ssr: false });
solid({ ssr: true });
solid({ islands: true });
solid({ islands: true, islandsRouter: true }); // experimental
import unstable_island(() => import("./someComponent"))
```

## Actions

**createRouteAction**

- <https://start.solidjs.com/core-concepts/actions>
- communicate client to server.

# API Routes

- Routes do not have to be public. Using `RPC` functions you can keep routes private.
- For external routes you have to make public api:
  - in the `routes` folder create path ex... `api/users.ts`
  - the name of folder can be anything.
  - inside the `users.ts` create the route functions.
    - `GET, PUT, PATCH, POST, DELETE`
    - <https://start.solidjs.com/core-concepts/api-routes>

````ts
// users.ts
import { json, APIEvent } from 'solid-start';

export async function GET(event: APIEvent) {
  console.log(event.request.method); // returns 'GET'
  // return new Response('hello world');
  // or json
  return json({ id: 3434, name: 'bobby' });
}

export async function POST(event: APIEvent) {
  console.log(await event.request.text()); // body json is converted to text.
  return new Response('good job!');
}
```

## Component

```tsx
import { Component } from 'solid-js'
const Signup: Component = () => {
  ...
}
````

## Head and Meta Tags

- <https://start.solidjs.com/core-concepts/head-and-metadata>
- They can be used, not only as children of Head in root.tsx, but anywhere in your app, even deep in your component tree.

```tsx
export default function Root() {
  return (
    <Html lang="en">
      <Head>
        <Title>SolidStart - Bare</Title>
        <Meta charset="utf-8" />
        <Meta name="viewport" content="width=device-width, initial-scale=1" />
        <Link rel="icon" type="image/x-icon" href="/favicon.ico" />
        <Link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />
      </Head>
      <Body>
        <Suspense>
          <ErrorBoundary>
            <A href="/">Index</A>
            <A href="/about">About</A>
            <A href="/students">Students</A>
            <Routes>
              <FileRoutes />
            </Routes>
          </ErrorBoundary>
        </Suspense>
        <Scripts />
      </Body>
    </Html>
  );
}
```

## Routing

- <https://start.solidjs.com/core-concepts/routing>
- `/src/routes/students/[id]/[name].tsx` // `website.com/students/:id/:name`
  - `[id]/[name]` is a wildcard.
- `website.com/user/:id`
  **catchAll Routes**
- `src/routes/students/[...post]` // any route down students path will be caught.
- **API Routes**
  - API routes by using named exports with capitalized HTTP verbs: 'GET POST DELETE ...'
  - the core method of doing browser to server communication in SolidStart is by RPC (Remote Procedure Call).

```tsx
import { useParams } from 'solid-start';
export default function BlogPage() {
  const params = useParams();
  return <div>Blog {params.post}</div>;
}
```

**parent layout**

- default data you want all pages to share.

```sh
routes/
  users.tsx # default data all 'users' files will share.
  users
    index.tsx
    [id].tsx
    projects.tsx
```

**users.tsx**

```tsx
import { Outlet } from 'solid-start';
export default function UsersLayout() {
  return (
    <div>
      <h1>Users</h1> // all users will have an h1 tag.
      <Outlet />
    </div>
  );
}
```

**Route Groups**

- create folders for the sake of organization without affecting the URL structure.

```sh
routes/
  (static) # folder that is not part of path.
    about-us  # example.com/about-us
      index.tsx
    contact-us  # example.com/contact-us
      index.tsx
```

**Root Renaming**

- by default root entrypoint file is `index.tsx`. This can be changed by wrapping file name in `(fileName).tsx`

# Server Only

- these functions will run at **Compile Time**.

## createRouteData

- It's a resource creator that is aware of the router and the actions created on the page. It adds the concept of keys to the resource so that they can be granularly refetched using **refetchRouteData**.
- **useRouteData**
  1. Looks for and calls the `routeData` function.
     1. This function is created by you and does not have to be imported.
     2. It does need to be `exported`.
  2. The `routeData` function is only called once per route, the first time the user comes to that route.
  3. The `routeData` function is called before the route is rendered. // Compile Time

```tsx
import { useRouteData, createRouteData } from "solid-start"; 
type Student = { name: string; house: string; } 
export function routeData() {
  const [students] = createResource(async () => (await fetch("https://hogwarts.deno.dev/students")).json() as Student[];
  ); 
  return { students };
  // or
  return createRouteData(async () => (await fetch("https://hogwarts.deno.dev/students")).json();
  );
}

export default function Page() {
  const { students } = useRouteData<typeof routeData>(); 
  return (
    <ul>
      <For each={students()}>
        {(student) => <li>{student.name}</li>}
      </For>
    </ul>
  );
}
```

## createServerAction

- **form** if your fist argument is `form` and of type `form: FormData`, and you return a `redirect`, then it will act like a **progressively enhanced form**. -which means without JS, form will still update, server will send complete new page with every form change.
- **invalidate** can use `createServerAction(async (name)=> name, {invalidate: ['key1', 'key2'] })` to only refetch certain parts of page.
  - it seems to work in junction with `routeData/createServerData`

## createServerData

- <https://start.solidjs.com/api/createServerData>
- wrapper around `createResource` that adds granular mutation, helpers to refetch, solid states: `("unresolved" | "pending" | "ready" | "refreshing" | "errored")`.
- returns a `Solid Resource from createResource` <https://www.solidjs.com/docs/latest/api#createresource>
- only runs on server.
- allows for granular refetching. resources coordinate with actions/mutations.
- joins actions (submit form / params change) with data loading (fetch / refetch).
- creates named mutations.

## routeData

- <https://start.solidjs.com/core-concepts/data-loading>
- **routeData** is a function passed to the `Solid Router`. When you create the client route, you will have access to the `useRouteData` function. This function return a `createResource signal`.
- <https://start.solidjs.com/core-concepts/routing>
- <https://www.solidjs.com/docs/latest/api#createresource>
- Each route, leaf or layout, comes with the ability to export its own routeData function that will be managed by the router.

```tsx
import { createResource } from 'solid-js';
export function routeData({ params }) {
  // problems with createResource
  // when navigation happens resource will refetch.
  // when params change, resource will refetch.
  // createServerData addresses these problems and adds helper functions.
  const [user] = createResource(() => `user/${params.id}`, server(fetchAPI));
  return user;
}
```

## server$

- <https://start.solidjs.com/api/server>
- only runs on the server, returns to client.
- the name becomes the route name. (devtools/network/post) request.
  - RPC, so the server finds the identifier function (greeting) from route.
- function is hoisted, so can be placed anywhere inside code.
- this function was replace by `routeData/createServerData` and options where added to it.

```tsx
import server$ from 'solid-start/server';

let count = 1; // 'count' will be added to server code. Not client count.
// greeting fn can be inside 'Counter' or outside.
const greeting = server$(async (name: string) => {
  console.log('hello from greeting!');
  return `hello ${name} ${count}`;
});

export default function Counter() {
  const [count, setCount] = createSignal(0);
  return (
    <button
      class="increment"
      onClick={async () => {
        setCount(count() + 1);
        console.log(await greeting('bob'));
        // or because of hoisting this works as well.
        console.log(
          await server$(async (name: string) => {
            console.log('hello from greeting!');
            return `hello ${name} ${count}`; // 'count' comes from server variable 'count' not client.
          })('bob')
        );
      }}
    >
      Clicks: {count()}
    </button>
  );
}
```

### createServerData$

```tsx
import { For, Accessor, createResource } from 'solid-js';
import { useRouteData } from 'solid-start';
import { createServerData$ } from 'solid-start/server';
type Student = { name: string; house: string };

// only runs on the server
export function routeData() {
  return createServerData$(() => hogwarts.students.list());
}
export default function Page() {
  const students = useRouteData<typeof routeData>();
  return (
    <ul>
      <For each={students()}>{(student) => <li>{student.name}</li>}</For>
    </ul>
  );
}
```
