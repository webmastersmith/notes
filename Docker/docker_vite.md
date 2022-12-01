# Docker Vite

1. install vite and get working on host.
2. copy everything over. npm i would not copy some of the npm packages correctly.
3. `docker run --rm --name client -p5173:5173 $(docker build -q .)`

```dockerfile
FROM node:19.2-slim
RUN npm install -g npm@9.1.3
ENV NODE_ENV=production
WORKDIR /app
COPY package.json package-lock.json ./
COPY node_modules node_modules
COPY index.html tsconfig.json tsconfig.node.json vite.config.ts ./
COPY public public
EXPOSE 5173
# this is done last, so changes, only this will be copied and everything else will be cached.
COPY src src
CMD ["npm", "run", "dev"]
```

**vite.config.ts**

```ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tsconfigPaths from 'vite-tsconfig-paths';
import path from 'node:path';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), tsconfigPaths()],
  server: {
    watch: {
      usePolling: true,
    },
    host: true, // needed for the Docker Container port mapping to work
    strictPort: true,
    port: 5173, // you can replace this port with any port
  },
});
```
