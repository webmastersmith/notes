# Typescript

- [Types](https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/node)

## Restart VSCode Server

- vscode: `ctrl + shift + p`, then type: `TypeScript: Restart TS Server`

# Extend & Type Alias

- <https://stackoverflow.com/questions/41385059/possible-to-extend-types-in-typescript>
- [Type Alias](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#type-aliases)
  - `type` // anything can be typed.
    - you cannot `extend` a type.

```ts
type Animal = {
  name: string;
};

type Bear = Animal & {
  honey: boolean;
};
```

- `interface` // another way to name an object type.
  - a `type` cannot be re-opened to add new properties vs an `interface` which is always extendable.

```ts
interface Animal {
  name: string;
}

interface Bear extends Animal {
  honey: boolean;
}
```

```ts
// Type Alias
type ID = number | string; // union

type UserEvent = Event & { UserId: string };
// or
type TourId = typeof Tour & { id?: number };

// or
type Event = {
  name: string;
  dateCreated: string;
  type: string;
};

interface UserEvent extends Event {
  UserId: string;
}
```

# Functions

**Parameter Annotations**

```ts
function greet(name: string) {
  console.log('Hello, ' + name.toUpperCase() + '!!');
}
```

**Return Type Annotations**

- [TS](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#return-type-annotations)

```ts
function getFavoriteNumber(): number {
  return 26;
}
```

# AS -Type Assertion

- [TS](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#type-assertions)
- Tell TypeScript what type you expect.
- TypeScript only allows type assertions which convert to a more specific or less specific version of a type.
- Sometimes this rule can be too conservative and will disallow more complex coercions that might be valid. If this happens, you can use two assertions, first to any (or unknown, which we’ll introduce later), then to the desired type:

```ts
// double assert to 'any' then to a type.
const a = expr as any as T;
const myCanvas = document.getElementById('main_canvas') as HTMLCanvasElement;
// angle bracket syntax.
const myCanvas = <HTMLCanvasElement>document.getElementById('main_canvas');
Try;
```

# Typeof

# Instanceof

# ReturnType<Model.find>

```ts
interface MyType = {
  model: typeof Model;
  query: ReturnType<typeof Model.find> | undefined;
}
```

# Union

- [TS](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)

```ts
function printId(id: number | string) {
  if (typeof id === 'string') {
    // In this branch, id is of type 'string'
    console.log(id.toUpperCase());
  } else {
    // Here, id is of type 'number'
    console.log(id);
  }
}
```
