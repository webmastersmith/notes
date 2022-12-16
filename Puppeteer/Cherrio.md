# Cheerio

- <https://cheerio.js.org/>
- <https://vimeo.com/31950192> // video
- npm install cheerio

**Tutorials**

- <https://beshaimakes.com/js-scrape-data>
- <https://github.com/gahabeen/jsonframe-cheerio> // json extractor for cheerio

**index.mjs**

```js
import * as cheerio from 'cheerio';
//const cheerio = require('cheerio')

const html = await axios(url);

const $ = cheerio.load(html);
const salePrice = $('.sale-price').text();
```

- `$.html()` // outputs raw html.
- `$('.shot-area \> div').toArray();` // all divs to array.

**map array of divs**

```js
const shots = divs.map((div) => {
  const $div = $(div);
  // style="left:50px;top:120px" -> x = 50, y = 120
  // slice -2 to drop "px", prefix with `+` to make a number
  const x = +$div.css('left').slice(0, -2);
  const y = +$div.css('top').slice(0, -2);
  // class="tooltip make" or "tooltip miss"
  const madeShot = $div.hasClass('make');
  // tip="...Made 3-pointer..."
  const shotPts = $div.attr('tip').includes('3-pointer') ? 3 : 2;
  return { x, y, madeShot, shotPts };
});
```
