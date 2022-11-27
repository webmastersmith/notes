# Vite

- This allows you to use relative directory paths: `import { Something } from 'Components'`
- add baseUrl to ./src
  **tsconfig.js**

```json
"compilerOptions": {
  "baseUrl": "src/",
  ...
}
```

**vite.config.ts**

- vite needs to be updated as well.
- <https://github.com/aleclarson/vite-tsconfig-paths>
- npm i -D vite-tsconfig-paths

```ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tsconfigPaths from 'vite-tsconfig-paths';
import path from 'node:path';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), tsconfigPaths()],
});
```
