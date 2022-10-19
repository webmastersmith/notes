# HTML

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <link
      href="https://fonts.googleapis.com/css?family=Megrim|Nunito+Sans:400,900"
      rel="stylesheet"
    />
    <link
      rel="icon"
      href="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/240/apple/155/ear-of-maize_1f33d.png"
    />

    <title>Fresh Avocados 🥑 /// NODE FARM</title>

    <style>
      *,
      *::before,
      *::after {
        margin: 0;
        padding: 0;
        box-sizing: inherit;
      }

      html {
        font-size: 62.5%;
        box-sizing: border-box;
      }

      body {
        ...;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>🌽 Node Farm 🥦</h1>

      <figure class="product">
        <div class="product__organic"><h5>Organic</h5></div>
        <a href="#" class="product__back">
          <span class="emoji-left">👈</span>Back
        </a>
        <div class="product__hero">
          <span class="product__emoji product__emoji--1">🥑</span>
          <span class="product__emoji product__emoji--2">🥑</span>
          <span class="product__emoji product__emoji--3">🥑</span>
          <span class="product__emoji product__emoji--4">🥑</span>
          <span class="product__emoji product__emoji--5">🥑</span>
          <span class="product__emoji product__emoji--6">🥑</span>
          <span class="product__emoji product__emoji--7">🥑</span>
          <span class="product__emoji product__emoji--8">🥑</span>
          <span class="product__emoji product__emoji--9">🥑</span>
        </div>
        <h2 class="product__name">Fresh Avocados</h2>
        <div class="product__details">
          <p><span class="emoji-left">🌍</span> From Portugal</p>
          <p><span class="emoji-left">❤️</span> Vitamin B, Vitamin K</p>
          <p><span class="emoji-left">📦</span> 4 🥑</p>
          <p><span class="emoji-left">🏷</span> 6.50€</p>
        </div>

        <a href="#" class="product__link">
          <span class="emoji-left">🛒</span>
          <span>Add to shopping card (6.50€)</span>
        </a>

        <p class="product__description">A ripe ...</p>
      </figure>
    </div>
  </body>
</html>
```
