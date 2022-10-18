# Rimraf

- `npm install -D rimraf`

```json
"script" {
  "prebuild": "rimraf ./build && tsc",
  "build": "ts-node build/index.ts"
}
```
