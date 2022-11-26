# Block, Element, Modifier

https://en.bem.info/methodology/quick-start/

## Block

- A functionally independent page component that can be reused.

## Element

- A composite part of a block that can't be used separately from it.

```html
<form class="search-form">
  <!-- `input` element in the `search-form` block -->
  <input class="search-form__input" />

  <!-- `button` element in the `search-form` block -->
  <button class="search-form__button">Search</button>
</form>
```
