# Typescript

- [Types](https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/node)

## Restart VSCode Server

- vscode: `ctrl + shift + p`, then type: `TypeScript: Restart TS Server`

# Extend

- <https://stackoverflow.com/questions/41385059/possible-to-extend-types-in-typescript>

```ts
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
