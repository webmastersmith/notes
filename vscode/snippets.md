# Snippets

- `f1 -> Snippets: Configure user snippets -> typescript.json` // only add shortcut to typescript files.
- copy everything into temp file.
  - search `ModelName` and replace with `${1:ModelName}` // use `tab` to switch next variable.
  - search `modelName` and replace with `${2:variableName}`
  - search `variables` and replace with `${3:StartName}`
- `ctrl + shift + down arrow` // makes sure minimize screen so no word wrap.
  - add `"` then press `end` then `",`
- copy and paste this into snippet `body` block.

```json
{
  "CRUD Mongo": {
    "prefix": "crudmongocontroller",
    "body": ["add copy pasted code here"]
  },
  "another function": {
    "prefix": "name_to_choose_snippet",
    "body": []
  }
}
```
