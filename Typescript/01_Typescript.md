# Typescript

- [Types](https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/node)

## Restart VSCode Server

- vscode: `ctrl + shift + p`, then type: `TypeScript: Restart TS Server`

## ignore

```ts
// @ts-expect-error -same as @ts-ignore, but if no error, alerts to unneeded ignore.
// @ts-ignore -turn off type checking for line below.
// @ts-nocheck -disable error checking in 'JS' file.
// @ts-check -enable error checking in 'JS' file.
```

## Flags

- `-T` // transpile to JS only, don't type check.

# Types

- <https://www.typescriptlang.org/docs/handbook/2/everyday-types.html>
- string
- number
- boolean
- null
- void // no return value
- never // never expect to return anything.
- undefined
- Date
- function // `() => void` or `fn(): string;`
- array // string[]
- tuple `const item: [string, boolean, number] = ['b', true, 1]` // allows self labeling.
- object // typeof obj
- class // instanceof class

# Global

- `node_modules/@types/cookie-session/index.d.ts`

```ts
declare global {
  namespace CookieSessionInterfaces {
    interface CookieSessionObject {
      jwt: string;
    }
  }
}
```

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

// cast to any then type.
const a = expr as any as T;
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

# Class

- modifiers:
  - public - open to all
  - protected - access only inside class or child class
  - private - access only in parent class. Child cannot access.
- fields
  - d
- constructor - runs when initialize class.
  - shortcut

```ts
class Gender {
  // gender: string // if you use public you can leave this out
  constructor(public gender: 'm' | 'f'); // public/private/protected. You don't having to add this.color = color or initialize the field with color: string;
  // this.gender = gender // if you use public you can leave this out
}
class Person extends Gender {
  constructor(public name: string, gen: 'm' | 'f') {
    // don't use public on super variable.
    super(gen);
  }
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

- The instanceof operator checks if the prototype property of the constructor appears in the prototype chain of the object and returns true if it does.
- [(instanceof) 'X' Only refers to a type, but is being used as a value here](https://bobbyhadz.com/blog/typescript-instanceof-only-refers-to-type-but-is-being-used-as-value)
  - The error was caused because we used the instanceof operator with a type instead of a value.

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

# Destructure

- <https://flaviocopes.com/typescript-object-destructuring/>
  **objects**

```ts
interface imageType {
  fieldname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  buffer: Buffer;
  size: number;
}
type ImageType = {
  imageCover?: imageType[];
  images?: imageType[];
};

const { imageCover, images }: ImageType = req.files as any;
```
