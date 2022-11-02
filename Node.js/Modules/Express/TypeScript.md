# Express TypeScript

## Extending Request Method

1. (root directory) touch2 -p @types/Express/index.d.ts

```ts
declare namespace Express {
  export interface Request {
    requestTime?: string;
  }
}
```
