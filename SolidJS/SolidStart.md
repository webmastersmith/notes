# Solid Start

- <https://start.solidjs.com/getting-started/what-is-solidstart>
- <https://github.com/solidjs/solid-start/tree/main/examples>

## Tutorials

- <https://dev.to/alexmercedcoder/creating-a-todo-list-with-solid-start-and-mongodb-1c4>

## Routing

- <https://start.solidjs.com/core-concepts/routing>
- `/src/routes/students/[id]/[name].tsx` // `website.com/students/:id/:name`
  - `[id]/[name]` is a wildcard.
- `website.com/user/:id`
  **catchAll Routes**
- `src/routes/students/[...post]` // any route down students path will be caught.

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

## Compile Time Functions

- <https://start.solidjs.com/core-concepts/data-loading>
- **createRouteData**
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

## Server Only code

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

## Actions

**createRouteAction**

- <https://start.solidjs.com/core-concepts/actions>
- communicate client to server.
