# Puppeteer

## Docs

- <https://pptr.dev/>

## Training

- <https://try-puppeteer.appspot.com/>
- <https://pptr.dev/>
- <https://github.com/puppeteer/puppeteer/tree/main/examples/>
- <https://github.com/transitive-bullshit/awesome-puppeteer>
- <https://github.com/checkly/puppeteer-examples>
- <https://medium.com/data-scraper-tips-tricks/30-seconds-to-scrape-producthunt-305497c56243#.2w0b5bl8f>
- <https://medium.com/@bretcameron/how-to-build-a-web-scraper-using-javascript-11d7cd9f77f2>
- <https://masteringjs.io/tutorials/fundamentals/puppeteer>
- <https://pdf.co/blog/web-scraping-with-puppeteer-and-nodejs>
- <https://returnstring.com/articles/puppeteer-elements-and-values>
- <https://rag0g.medium.com/>

**Chrome Developer Tools** // `CTRL + F` shows search feature in dev tools.

- <https://peter.sh/experiments/chromium-command-line-switches/#user-agent>
- npm i puppeteer
- <https://www.npmjs.com/package/puppeteer>
- **Without Chromium**
  - npm i puppeteer-core

## Setup

```bash
npm init -y && npm i ts-node dotenv puppeteer && npm i -D @types/node && npx tsc --init
```

**package.json**

```json
  // "scripts": {
  //   "dev": "NODE_ENV=development nodemon index.ts",
  //   "prod": "NODE_ENV=production nodemon index.ts"
  // },
  "scripts": {
  "dev": "NODE_ENV=development tsc-watch --onSuccess \"node ./build/index.js\"",
  "build": "tsc -p .",
  "start": "tsc-watch --onSuccess \"node ./build/index.js\""
},

// tsconfig.json
"outDir": "./build",
```

## simplest

```ts
import puppeteer from 'puppeteer';

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://www.google.com');
  // other actions...
  await browser.close();
})();
```

## Simple Puppeteer setup

```ts
const puppeteer = require('puppeteer-core');

(async () => {
  const browser = await puppeteer.launch({
    headless: false, //defaultViewport: null;  -will cause browser to open up to viewport size.
    executablePath:
      'C:/Users/USER_NAME/AppData/Local/Chromium/Application/chrome.exe',
  });
  const page = await browser.newPage();
  // page.on('console', (consoleObj) => console.log(consoleObj.text()))
  await page.goto('https://linkedin.com');
  await page.focus('input.login-email');
  await page.type('login'); // your login here
  page.click('.submit-button');
  await page.waitForNavigation();
  console.log('done!');
  await page.close();
  await browser.close();
})();

// other simple with puppeteer-extra
import puppeteer from 'puppeteer-extra';
import StealthPlugin from 'puppeteer-extra-plugin-stealth';
import AdblockerPlugin from 'puppeteer-extra-plugin-adblocker';
(async function () {
  // Add stealth plugin and use defaults (all tricks to hide puppeteer usage)
  puppeteer.use(StealthPlugin());
  // Add adblocker plugin to block all ads and trackers (saves bandwidth)
  puppeteer.use(AdblockerPlugin({ blockTrackers: true }));

  async function createBrowser() {
    return await puppeteer.launch({
      headless: false,
      defaultViewport: null, //browser opens full viewport size.
      // devtools: true,
      executablePath:
        'C:/Users/USER_NAME/AppData/Local/Chromium/Application/chrome.exe',
    });
  }

  // create new browser or will not run in parallel.
  const browser = await createBrowser();
  const incognito = await browser.createIncognitoBrowserContext();
  const page = await incognito.newPage();
  try {
    // goto libivox page and get download links
    await page.goto('https://librivox.org/');
    await page.waitForSelector(
      '.chapter-download > tbody >tr > td:nth-child(2) a'
    );
    const links = await page.$$eval(
      '.chapter-download > tbody >tr > td:nth-child(2) a',
      (nodes) => nodes.map((node) => node.getAttribute('href'))
    );
    console.log(links);
  } catch (e) {
    console.log(e);
  } finally {
    page.close();
    incognito.close();
    browser.close();
  }
})();
```

## Simple + multiple browsers

- <https://github.com/puppeteer/puppeteer/issues/4219>
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#browsercreateincognitobrowsercontext>
- Creates a new incognito browser context. This won't share cookies/cache with other browser contexts.
- run in parallel
  - `browser.createIncognitoBrowserContext()`

```ts
// const puppeteer = require('puppeteer-core')
import puppeteer from 'puppeteer-core'; //if file.mjs
(async () => {
  async function createBrowser() {
    return await puppeteer.launch({
      headless: false,
      // devtools: true,
      executablePath: process.env.LOCAL,
    });
  }

  // create new browser or will not run in parallel.
  const browser1 = await createBrowser();
  const incognito1 = await browser1.createIncognitoBrowserContext();
  const browser2 = await createBrowser();
  const incognito2 = await browser1.createIncognitoBrowserContext();

  const [amazon, chase] = await Promise.all([
    getAmazon(incognito1),
    getChase(incognito2),
  ]);

  browser1.close();
  browser2.close();
})();
```

# Puppeteer Options

```ts
const puppeteer = require('puppeteer-core');
// https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#puppeteerdefaultargsoptions
// https://peter.sh/experiments/chromium-command-line-switches/
// https://src.chromium.org/viewvc/chrome/trunk/src/chrome/common/pref_names.cc?view=markup

async function Audio() {
  const resolution = {
    x: 1280,
    y: 800,
  };
  const args = [
    '--disable-gpu',
    `--window-size=${resolution.x},${resolution.y}`,
    '--window-position=0,0',
    '--no-sandbox',
  ];

  // https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#puppeteerlaunchoptions
  const browser = await puppeteer.launch({
    // headless: true,
    headless: false,
    handleSIGINT: false,
    args: args,
    devtools: true,
    executablePath:
      'C:/Users/USER_NAME/AppData/Local/Chromium/Application/chrome.exe',
  });
  try {
    const page = await browser.newPage();
    await page.setViewport({
      width: resolution.x,
      height: resolution.y,
    });
    await page.setUserAgent(
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36'
    );

    // remove images from page load.
    await page.setRequestInterception(true);
    page.on('request', (req) => {
      req.resourceType() == 'font' || req.resourceType() == 'image'
        ? req.abort()
        : req.continue();
    });
    // page.on('console', (consoleObj) => console.log(consoleObj.text()))
    let url = `https://snow-crash/`;
    await page.goto(url, { waitUntil: 'networkidle0' });
  } finally {
    browser.close();
  }
}
Audio();
```

## fetch

```ts
// not needed in node 18+
import fetch from 'fetch';
await page.exposeFunction('fetch', fetch); // expose it
await page.evaluate(`fetch()`); // use it
```

## JSON Data

```ts
// I would leave this here as a fail safe
await page.content();
const innerText = await page.$eval('body', (e) => JSON.parse(e.innerText));
console.log(JSON.stringify(innerText, null, 2));
```

## Documentation

- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md>
- <https://flaviocopes.com/puppeteer/>

## Node Functions

- `Page.on` // Node events -must be before `page.goto()` to see request.
- [https://github.com/puppeteer/puppeteer/blob/v1.14.0/docs/api.md#keyboardpresskey-options](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#keyboardpresskey-options)
- <https://nodejs.org/api/events.html#events_class_eventemitter>
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#class-httpresponse>
  - functions that return items from http response object
    - `url(), json(), text(), headers()`
- The Page class emits various events (described below) which can be handled using any of **Node's** native EventEmitter methods, such as **on**, **once** or **removeListener**.

## Intercept Request

```ts
// this must be before page.goto.
page.on('response', async (response) => {
  console.log(await response._request._resourceType);
});
// events:
_headers;
_request._resourceType;
_request._url;
// shorthand
response.url(); // same as '_request._url'
response.json();

const res = await response._request._url;
if (res.includes('image')) {
}
// don't load font's or images
await page.setRequestInterception(true);
page.on('request', (req) => {
  req.resourceType() == 'font' || req.resourceType() == 'image'
    ? req.abort()
    : req.continue();
});

// from docs
// https://pptr.dev/guides/request-interception
const browser = await puppeteer.launch();
const page = await browser.newPage();
await page.setRequestInterception(true);
page.on('request', (interceptedRequest) => {
  if (interceptedRequest.isInterceptResolutionHandled()) return;
  if (
    interceptedRequest.url().endsWith('.png') ||
    interceptedRequest.url().endsWith('.jpg')
  )
    interceptedRequest.abort();
  else interceptedRequest.continue();
});
await page.goto('https://example.com');
await browser.close();
```

# Page

- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#browsernewpage>
- **load** - consider navigation to be finished when the load event is fired. // default
- **domcontentloaded** - consider navigation to be finished when the DOMContentLoaded event is fired.
- **networkidle0** - consider navigation to be finished when there are no more than 0 network connections for at least 500 ms.
- **networkidle2** - consider navigation to be finished when there are no more than 2 network connections for at least 500 ms.
- `await browser.pages()` // array of all pages
- `await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36')`
- `await browser.close();` // use it in a try{} finally{await browser.close();}; so browser always closes, even if error.
- `await page.close()`
- [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagegotourl-options_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagegotourl-options)

```ts
// create new page from browser instance
await browser.newPage()
const incognito1 = await browser.createIncognitoBrowserContext([options])
// https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#browsercreateincognitobrowsercontextoptions
const page = await incognito1.newPage()  //must do this or page node will not work!!!!!!!!!

// go to page:
// https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagegotourl-options
await page.goto(url[, options])
await page.goto('https://google.com', { waitUntil: 'networkidle0' });  //navigate to google



await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36')
const html = await page.content()  //get complete webpage
//print
fs.writeFileSync('fileName.html', html)

// When creating new browser, you can access page with:
// https://scrapingant.com/blog/puppeteer-tricks-to-avoid-detection-and-make-web-scraping-easier
// you do not have to create new page, just use page already open when browser opens.


await page.goto('https://google.com', { waitUntil: 'networkidle0' });  //navigate to google
await page.goto('https://google.com', { waitUntil: load, timeout: 0});
page.close()  //can use await if need to await page close
```

### Navigation/Wait

- await page.**waitForNavigation**({waitUntil: 'load'});
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagewaitfornavigationoptions>
- <https://stackoverflow.com/questions/46948489/puppeteer-wait-page-load-after-form-submit>
- **load** // default
  - consider navigation to be finished when the load event is fired.
  - This is the default and very strict: your whole page including all dependent resources, i.e. images, scripts, css etc.
- **domcontentloaded**
  - consider navigation to be finished when the DOMContentLoaded event is fired.
  - less strict: when your HTML has loaded.
- **networkidle0**
  - consider navigation to be finished when there are no more than 0 network connections for at least 500 ms.
- **networkidle2**
  - consider navigation to be finished when there are no more than 2 network connections for at least 500 ms.

```ts
//new page -Navigate to Google
const page = await browser.newPage(); //open new tab
await page.goto('https://google.com', { waitUntil: 'networkidle0' }); //navigate to google
await page.goto('https://google.com', { waitUntil: load, timeout: 0 }); // inside try catch

const [response] = await Promise.all([
  page.waitForNavigation({ waitUntil: 'load' }), // The promise resolves after navigation has finished
  page.click('a.my-link'), // Clicking the link will indirectly cause a navigation
]);

const junk = await Promise.all([
  page.$eval(
    //click element, wait for naviagtion to finish.
    'div.pull-right.hidden-mobile > ul > li:nth-child(2) > div > ul > li:nth-child(3) > a',
    (elem: HTMLAnchorElement) => elem.click()
  ),
  page.waitForNavigation({ waitUntil: 'networkidle0' }),
]);
```

## CSS

```ts
ul#plList>li:not(.plSel)  //target ul with id of 'plList' that has a 'li' child element without the class 'plSel'

tr:nth-child(12)

a[rel]:not([rel=""])  // any 'a' tag with an attribute of 'rel', but not 'rel' that has an empty value.

<input type="checkbox" id="c2" name="c2" value="DE039230952"/>
'input[value][type="checkbox"]:not([value=""])'  //not empty value

//chaining 'not' attributes
:not([type="hidden"]):not([disabled])
```

## Timeout

- `await page.**waitForTimeout**(500)` // delay for 1/2 second
- [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagewaitfortimeoutmilliseconds_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagewaitfortimeoutmilliseconds)
- `page.waitForSelector('span[widgetid="dijit_form_ToggleButton_2"]',{timeout: 3000})`
  - must use try catch because timeout will error.
  - <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagewaitforselectorselector-options>
- `await page.waitForResponse()`
  - [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagewaitforresponseurlorpredicate-options_](https://github.com/puppeteer/puppeteer/blob/v1.12.1/docs/api.md#pagewaitforresponseurlorpredicate-options)
- `await page.waitForRequest(urlOrPredicate[, options])`
  - [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagewaitforrequesturlorpredicate-options_](https://github.com/puppeteer/puppeteer/blob/v1.12.1/docs/api.md#pagewaitforrequesturlorpredicate-options)

```ts
// Default timeout
const page = await browser.newPage();
page.setDefaultTimeout(5000); // 5 seconds. default is 30.

await page.waitForTimeout(1000); //delay 1 second
```

**Reload**

- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagereloadoptions>
- `await page.reload()`
  - when you reload, you loose 'page' context variable. if 'page' was an argument of function, will need to be recalled with new 'page' variable.

**History**

- f

```ts
// access history and evaluate last url of page
const session = await page.target().createCDPSession();
const history = await session.send('Page.getNavigationHistory');
const last = history.entries[history.entries.length - 2];
```

**Screenshot**

- [https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagescreenshotoptions](https://github.com/puppeteer/puppeteer/blob/v10.0.0/docs/api.md#pagescreenshotoptions)
- [https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagescreenshotoptions](https://github.com/puppeteer/puppeteer/blob/v10.0.0/docs/api.md#pagescreenshotoptions)
- `await page.screenshot( {options} )`

- options
  - `path: 'fileName.png'` // mandatory
  - `fullpage: true` // scrolls down page to get full item.
  - `await page.screenshot({options})`
- Sharp
  - <https://sharp.pixelplumbing.com/api-constructor>
  - <https://github.com/lovell/sharp>
  - `const newPic = await sharp(pic).resize(400, 200).toBuffer()`
  - `sharp(inputBuffer).resize(320, 240).toFile('output.webp', (err, info) =\> { if (err) console.log('Sharp error: ', err) });`

```ts
await page.screenshot({
  path: './screenshot.jpg',
  type: 'jpeg',
  fullPage: true,
});
```

**PDF**

- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagepdfoptions>
- headless must be true or will not print pdf.
- <https://medium.com/swlh/making-a-resume-in-html-or-react-bd1781abcdef>
- <https://blog.risingstack.com/pdf-from-html-node-js-puppeteer/>
- <https://blog.tericcabrel.com/generate-a-pdf-in-a-nodejs-application-with-puppeteer/>

```ts
await page.pdf({
  path: 'name.pdf',
  printBackground: true,
  preferCSSPageSize: true,
});
```

# Interactions With Webpage

# JavaScript

## Get Selector

- <https://flaviocopes.com/selectors-api/>
- `document.querySelector('selector')`
- `document.querySelectorAll('selector')`

## Selectors

- <https://dev.to/annaqharder/demystifying-innertext-vs-textcontent-35fl>
- **innerText** = property returns just the text, without spacing and inner element tags.
  - innerText is aware of the **rendered** appearance of the text content of a node and its descendants.
  - may have to use **textContent**. `innerText` does not work all the time.
  - shows you _exactly as you would see on the page._ No element/style tags are shown.
- **innerHTML** = property returns the text, including all spacing and inner `<span>` element tags.
- **textContent** = property returns the text with spacing, but without inner element tags.
  - textContent returns the raw textual content inside the DOM node and its descendants, including script and style tags. textContent is aware of formatting such as spacing and line breaks.
  - the line break, indentation, and placeholder text are preserved.
    -no element/style tags are shown.

```ts
// check is selector exist
const is2faExist = await page.evaluate(() => {
  const el = document.querySelector( '#header-simplerAuth-dropdownoptions-styledselect' )
  return el ? true : false
})
if (is2faExist) { }
or
if ( await handle.$eval('table.improvements', () => true).catch(() => false) ) {...}  //I use this one for handles
or
if (await page.$(selector) !== null) {...}
```

## Attributes

- getAttribute(attribute_name) method fetches the value of an attribute, in HTML code whatever is present in left side of '=' is an attribute, the value on the right side is the Attribute value.
- <https://www.w3schools.com/cssref/css_selectors.asp>
- <https://chercher.tech/puppeteer/get-attribute-puppeteer>

```ts
//all of these give you the 'attribute value' of the 'src' attribute.
// evaluate
const results = await page.evaluate(
  'document.querySelector(".F8 > img:nth-child(1)").getAttribute("src")'
); // returns the url of the src attribute on an image.
// $eval
const results = await page.$eval('.F8 > img:nth-child(1)', (el) =>
  el.getAttribute('src')
);
// $
const element = await page.$('.F8 > img:nth-child(1)');
const text = await element.getProperty('src').jsonValue(); //can get the class property

var link = await page.$eval(".gb_d[data-pid='23']", (element) =>
  element.getAttribute('data-pid')
).someClass[(href *= 'https://www.linkedin.com/login?')]; //someClass with href that contains "https://..."

// link
var link = await page.$eval('.screenOnly > span', (el) => el.href);
```

## Select Box

```ts
// find select box and choose 250 results per page
await Promise.all([
  page.waitForNavigation({ waitUntil: 'domcontentloaded' }),
  page.select('#propertySearchOptions_recordsPerPage', '250'),
]);
```

# Element Nodes

## Evaluate

- [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageevaluatepagefunction-args_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageevaluatepagefunction-args)
- `page.evaluate(() => { htmlPage })`
  - enters page and allow you to use document.querySelector() on any element.
  - **cons**
    - Console.log happens only in the browser instance.
    - have to pass in outside variables. code is loaded in the browser, can only act onl what you pass in.
- will only return results, not element handle.
- With `page.evaluate()`, puppeteer sends function code to the browser as a string and browser compiles it and execute in the browser context, without access to the puppeteer context, so you need to transfer the argument number explicitly.

```ts
let imageHref = await page.evaluate((sel) => {
  return document.querySelector(sel).getAttribute('src').replace('/', '');
}, IMAGE_SELECTOR); // pass in a variable.
const images = await page.evaluate(() =>
  Array.from(document.images, (e) => e.src)
);

// grab all property id's from page.
const propListItems = await page.evaluate(() => {
  const idSelectors = Array.from(
    document.querySelectorAll('td.screenOnly > span[prop_id]')
  );
  const idList =
    idSelectors.length > 0
      ? idSelectors.map((el) => el.getAttribute('prop_id'))
      : []; //always return something.
  return idList;
});

// get all 'ul > li' elements
const listItems = await page.evaluate(() =>
  Array.from(document.querySelectorAll('ul#plList>li>div>span.plNum')).map(
    (el) => el.innerText
  )
);

// Get all the search result URLs
const links = await page.evaluate(function getUrls() {
  return Array.from(document.querySelectorAll('a cite').values()).map(
    (el) => el.innerHTML
  );
});

// pass in variable
// https://stackoverflow.com/questions/46088351/how-can-i-pass-variable-into-an-evaluate-function
// https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageevaluatepagefunction-args
const links = await page.evaluate((evalVar) => {
  console.log(evalVar);
}, evalVar); // pass variable as an argument
```

## Eval

- `await page.$eval(selector, (el) => el.innerText)`
  - allows you to operate on element with js.
- `page.$$eval(selector, (el) => el.map(e => e.innerText) )`
  - does `Array.from` for you.
  - short for `document.querySelectorAll('selector')`
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageevalselector-pagefunction-args-1>
- same as document.querySelector('#search')
- [_https://stackoverflow.com/questions/51280984/how-to-use-eval-function_](https://stackoverflow.com/questions/51280984/how-to-use-eval-function)
- [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageevalselector-pagefunction-args_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageevalselector-pagefunction-args)
- [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageevalselector-pagefunction-args_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageevalselector-pagefunction-args)

```ts
const list = await page.$eval(
  'div.propertyDeedHistoryGrantee',
  (e) => e.textContent
);
const link = await page.$eval('.screenOnly > span', (el) =>
  el.getAttribute('prop_id')
); // returns value of prop_id

// $$eval
const arr = await page.$$eval('selector', (e) => e.map((el) => el.textContent));

// https://stackoverflow.com/questions/56467696/get-the-value-of-html-attributes-using-puppeteer
const attr = await page.$$eval('span.styleNumber', (el) =>
  el.map((x) => x.getAttribute('data-Color'))
); //returns value of 'data-Color'
or;
// map multiple items and extract data.
const arr = await page.$$eval('selector', (rows) =>
  rows.map((row) => {
    // here is item block that can be modified.
    const properties = {};
    const titleElement = row.querySelector('.result-title');
    properties.title = titleElement.innerText;
    properties.url = titleElement.getAttribute('href');
    const priceElement = row.querySelector('.result-price');
    properties.price = priceElement ? priceElement.innerText : ''; //price may not exist
    const imageElement = row.querySelector('.swipe [data-index=0] img');
    properties.imageUrl = imageElement ? imageElement.src : '';
    return properties;
  })
);
```

## JSHandle -get the HTML node

- `page.$(selector)`
  - returns an element handle.
  - same as `document.getSelector('selector')`
  - **cons**
    - easy to over complicate things.
- `page.$$(selector)`
  - same as `document.getSelectorAll('selector')`
  - **cons**
    - will need to wrap it with `Array.from(await page.$$(selector))`
- [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageselector-1_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageselector-1)
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#class-elementhandle>
- ElementHandle instances can be used as arguments in page.**\$eval()** and page.**evaluate()** methods.
- `elementHandle.dispose()`
  - <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#elementhandledispose>
- **evaluateHandle** -extends JSHandle
  - [_https://chercher.tech/puppeteer/get-element-puppeteer_](https://chercher.tech/puppeteer/get-element-puppeteer)
  - [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#class-elementhandle_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#class-elementhandle)

```ts
    // grab all personDivs
    const personDivHandles = await page.$$('div.listing-content')
    // loop through divs and extract info
    const personArr = await Promise.all(
      personDivHandles.map(async (personHandle) => {
        const name = await personHandle.$eval('h2', (e) => e.innerHTML)
      })
    )


const cardHandles = await page.$$('.someSelector')  //gets complete element
// this will call all promises at once, but will wait till all are fullfilled before moving on.
const orderIds = await Promise.all( cardHandles.map( async (card) => await card.$eval('selector', (el) => el.textContent) )) //itterate each element

// get an array of elementHandles, in each handle click the button in for of loop
const elementHandle = await page.$$('selector') will return an array of element handles
// await elementHandle.$('selector').click()

// array of handles
 const improvementDetailsClassHandle = await page.$$(
    `table:nth-child(${improvementDetailsClass}) tbody tr`
  )
// remove details header
const newHandles = improvementDetailsClassHandle.filter((_, idx) => idx > 0)
// iterate over handles and extract data
await Promise.all(
  newHandles.map(async (handle, idx) => {
    const description = await handle.$eval(
      ':nth-child(3)',
      (el) => el.innerText
    )
    const yearBuild = await handle.$eval(
      ':nth-child(6)',
      (el) => el.innerText
    )
    const sqft = await handle.$eval(':nth-child(7)', (el) => el.innerText)
    return { description, yearBuild, sqft }
  })
)


// array of handles passed in cannot match there classnames, to get classnames
handle._remoteObject.description

// parallel
// https://github.com/checkly/puppeteer-examples/blob/master/5.%20parallel-pages/screenshots_parallel.js
// https://github.com/checkly/puppeteer-examples/blob/master/5.%20parallel-pages/screenshots_parallel_cologne_colleges.js
// get the items you want to map over.
const urls = await page.$$eval(
  '.pillars__block-link.link.link--secondary',
  (els) => els.map((el) => el.getAttribute('href').replace(/\//, ''))
)

const promises = urls.map((url) => {
  return browser.newPage().then(async (page) => {
    await page.setUserAgent(
      `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36`
    )
    await page.goto(`https://www.shopify.com/${url}`)
    await page.waitForSelector(
      '.section-heading h1.section-heading__heading'
    )

    const slogan = await page.$eval(
      '.section-heading h1.section-heading__heading',
      (el) => el.innerText.replace(/\n|\r|—/g, '')
    )
    return slogan
  })
})

const slogans = await Promise.all(promises)
console.log(slogans)
```

### Xpath

- [_https://chercher.tech/puppeteer/get-element-puppeteer_](https://chercher.tech/puppeteer/get-element-puppeteer)
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#elementhandlexexpression>
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagexexpression>
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#jshandlegetpropertypropertyname>
- can right click in chrome devtools to get complete xpath

```ts
const [el] = await page.$x('url');
const txt = await el.getProperty('innerText'); //string
const word = await txt.jsonValue();
```

# Actions

## Click

- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageclickselector-options>
- <https://stackoverflow.com/questions/49979069/puppeteer-element-click-not-working-and-not-throwing-an-error>

```ts
// most cases use this one!
await page.$eval('#link', (elem) => elem.click()); // always works better than page.click()
await page.evaluate(() => document.querySelector('SELECTOR').click());
// typescript
await page.$eval('button#signin-button', (elem: HTMLButtonElement) =>
  elem.click()
);

// wait for selector, then click
export const click = async (
  page: puppeteer.Page | puppeteer.Frame,
  selector: string
): Promise<void> => {
  await page.waitForSelector(selector);
  await page.$eval(selector, (elem: HTMLElement) => {
    elem.click();
  });
  return;
};

// tries to simulate real user movements. Crashes randomly. Avoid if can.
// problems with clicking sometimes not working
// https://github.com/puppeteer/puppeteer/issues/3347
// https://stackoverflow.com/questions/56226990/puppeteers-page-click-is-working-on-some-links-but-not-others/56227068
// https://stackoverflow.com/questions/60827605/puppeteer-page-click-works-but-page-evaluate-document-click-doesnt-work
await page.click('selector', { delay: 300 });
// click multiple items
// get length of items, click and record src attribute. Audio 'src' was in different spot on page is why it's complex.
const num = await page.$$eval('ul#plList>li', (el) => el.length); //return number of 'li' items.
const arr = [];
for (let i = 0; i < num; i++) {
  page.click(`ul#plList>li:nth-of-type(${i + 1})`);
  await page.waitForTimeout(1000);
  const link = await page.$eval('audio#audio1', (el) => el.getAttribute('src'));
  arr.push(link);
}

// not sure
await page.evaluate(() => document.querySelector('#btn').scrollIntoView()); //haven't tried
puppeteer.launch({ ignoreHTTPSErrors: true, headless: false }); //haven't tried
```

### Focus

- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagefocusselector>
- `page.focus('selector')` // also scrolls to item

### Mouse

- [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#class-mouse_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#class-mouse)

```ts
// default screen size is: 800 x 600
await page.mouse.move(resolution.x / 2, resolution.y / 2); // x: left,right, y: up,down
await page.mouse.click(x, y, { options });
```

### scroll

- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#mousewheeloptions>
- `await page.mouse.wheel({ deltaY: -100 });` // up/down negative scroll up. 96 pixels per inch.

### Hover

- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagehoverselector>
- `page.hover('selector')`

### type into input box

- [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagetypeselector-text-options_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagetypeselector-text-options)
- [_https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#keyboardtypetext-options_](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#keyboardtypetext-options)

```ts
// returns elementHandle of node.
const searchBox = await page.waitForSelector('#search-query');
await searchBox?.type('fridge', { delay: 100 });

// Type "JavaScript" into the search bar
await page.evaluate(() => {
  document.querySelector('input[name="q"]').value = 'JavaScript';
});
await page.$eval('#email', (el) => (el.value = 'JavaScript'));

// works only if you provide selector
await page.type("[name='q']", 'JavaScript');

// waits 1/2 second each character
await page.type("[name='q']", 'chercher tech', { delay: 500 });

// using focus
await page.focus('#username');
await page.keyboard.type(process.env.NAME, { delay: 100 });
await page.keyboard.type('Hello'); // Types instantly

// typescript
// page | iframe
export const inputBox = async (
  frame: puppeteer.Page | puppeteer.Frame,
  selector: string,
  text: string
) => {
  try {
    await frame.waitForSelector(selector);
    await frame.type(selector, text);
    // await frame.type(selector, text, { delay: 300 })
  } catch (e) {
    console.log(`Error with selector inputting text`, e.message);
  }
};
```

### keyboard

- <https://github.com/puppeteer/puppeteer/blob/v1.14.0/docs/api.md#keyboardpresskey-options>
- <https://github.com/puppeteer/puppeteer/blob/v1.14.0/lib/USKeyboardLayout.js>
- <https://stackoverflow.com/questions/46442253/pressing-enter-button-in-puppeteer>

```ts
await page.keyboard.press('Enter'); // works good
await page.keyboard.press(String.fromCharCode(13)); //enter
await page.type(String.fromCharCode(13));
```

### Cookies

- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagecookiesurls>
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagesetcookiecookies>
  <span id="anchor"></span>
-
- <https://stackoverflow.com/questions/56514877/how-to-save-cookies-and-load-it-in-another-puppeteer-session>
- <https://gist.github.com/gokusenz/5edc970bf14cc3be2be1babea7d2ff09>
- <https://github.com/puppeteer/puppeteer/issues/717>
- <https://rag0g.medium.com/using-cookies-to-speed-up-puppeteer-and-playwright-scripts-38eb413439f8>
- cookies will be an array of cookie objects.
- make sure you call 'page.setCookies(...cookies)' before calling page.goto(url) because if you call it afterwards, the cookies will be set after the page has been loaded.

```ts
const fs = require('fs')

// save cookies
//where to save cookies including file name, page to get cookies from.
export const saveCookies = async (
  page: puppeteer.Page,
  saveCookiePath: string
): Promise<void> => {
  const cookies = await page.cookies()
  fs.writeFileSync(saveCookiePath, JSON.stringify(cookies))
  return
}

[
  {
    "name": "spId",
    "value": "22b7922479",
    "domain": ".www.linkedin.com",
    "path": "/",
    "expires": -1,
    "size": 50,
    "httpOnly": false,
    "secure": true,
    "session": true,
    "sameParty": false,
    "sourceScheme": "Secure",
    "sourcePort": 443
  },
  ...
]


// load cookies
export const setCookies = async (
  page: puppeteer.Page,
  cookiePath: string
): Promise<boolean> => {
  // check if cookies exist
  if (fs.existsSync(cookiePath)) {
    try {
      const cookies: puppeteer.Protocol.Network.Cookie[] = JSON.parse(
        fs.readFileSync(cookiePath, 'utf-8')
      )
      // loop through each cookies and add to page.
      for (const cookie of cookies) {
        await page.setCookie(cookie)
      }
      return true
    } catch (e) {
      console.error(e)
      return false
    }
  } else {
    // cookies do not exist.
    return false
  }
}
```

# iFrame

- <https://stackoverflow.com/questions/56420047/how-to-select-elements-within-an-iframe-element-in-puppeteer>
- <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pageframes>
- <https://chercher.tech/puppeteer/iframes-puppeteer>
  - Iframes are nothing but different pages either from different websites or from the same website. So we puppeteer also treats them in the same way. just like a new tab.
  - `frame.contentFrame()` // moves you into the frame.

```ts
const browser = await puppeteer.launch({ headless: false });
const page = await browser.newPage();

await page.goto('http://www.espn.com/login')
await page.waitForSelector("iframe");

const frameHandle = await page.$('div#disneyid-wrapper iframe'); //gets the frame handle
const frame = await frameHandle.contentFrame(); //moves you into the frame.
await frame.waitForSelector('[ng-model="vm.username"]');
const username = await frame.$('[ng-model="vm.username"]');
await username.type('foo');
await browser.close()

or
frame.name()
https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#framename
If the 'name' attribute is empty or missing, returns the id attribute instead.
if the id is '#logonbox', then the name will be 'logonbox'
const frame = page.frames().find((frame) => frame.name() === 'myframe');
const text = await frame.$eval('.selector', (element) => element.textContent);
```

# localStorage

- <https://rag0g.medium.com/using-cookies-to-speed-up-puppeteer-and-playwright-scripts-38eb413439f8>

```ts
// save
const localStorage = await page.evaluate(() =>
  JSON.stringify(window.localStorage)
);
fs.writeFileSync('localstorage.json', localStorage);

// load
const localStorage = fs.readFileSync('localstorage.json', 'utf8');
const deserializedStorage = JSON.parse(localStorage);
await page.evaluate((deserializedStorage) => {
  for (const key in deserializedStorage) {
    localStorage.setItem(key, deserializedStorage[key]);
  }
}, deserializedStorage); // pass into evaluate.
```

# error handling

- [_https://stackoverflow.com/questions/51676159/puppeteer-console-log-how-to-look-inside-jshandleobject/66801550#66801550_](https://stackoverflow.com/questions/51676159/puppeteer-console-log-how-to-look-inside-jshandleobject/66801550#66801550)

```ts
import { ConsoleMessage, Page, JSHandle } from 'puppeteer';
const chalk = require('chalk');
 
export const listenPageErrors = async (page: Page) => {
  // make args accessible
  const describe = (jsHandle) => {
    return jsHandle.executionContext().evaluate((obj) => {
      // serialize |obj| however you want
      return `OBJ: ${typeof obj}, ${obj}`;
    }, jsHandle);
  }
 
  const colors: any = {
    LOG: chalk.grey, // (text: any) => text,
    ERR: chalk.red,
    WAR: chalk.yellow,
    INF: chalk.cyan,
  };
 
  // listen to browser console there
  page.on('console', async (message: ConsoleMessage) => {
    const args = await Promise.all(message.args().map(arg => describe(arg)));
    // make ability to paint different console[types]
    const type = message.type().substr(0, 3).toUpperCase();
    const color = colors[type] || chalk.blue;
    let text = '';
    for (let i = 0; i < args.length; ++i) {
      text += `[${i}] ${args[i]} `;
    }
    console.log(color(`CONSOLE.${type}: ${message.text()}\n${text} `));
  });
}
 
Put it between const page = await browser.newPage(); and page.goto(URL), and it will work as should
 
const page = await browser.newPage();
await listenPageErrors(page); // <- like there
page.goto(URL)


// try catch(e) {}
  async function deleteFile(file) {
    const delay = (ms) => new Promise((res) => setTimeout(res, ms))
    try {
      fs.unlinkSync(file)
    } catch (e) {
      try {
        await delay(2000)
        fs.unlinkSync(file)
      } catch (e) {
        try {
          await delay(2000)
          fs.unlinkSync(file)
        } catch (e) {
          console.log(`Problem deleting ${file}. Waited 4 seconds: `, e)
        }
      }
    }
  }

// check if selector exist -cannot use $eval()
let productType = await page.evaluate(() => {
  let el = document.querySelector(".foo")
  return el ? el.innerText : ""
})
```

# Logging / Debuging

- <https://nitayneeman.com/posts/getting-to-know-puppeteer-using-practical-examples/>
  - `const browser = await puppeteer.launch({ headless: false, slowMo: 200 });`
- <https://stackoverflow.com/questions/46198527/puppeteer-log-inside-page-evaluate>
- <https://chromedevtools.github.io/devtools-protocol/>

```ts
const browser = await puppeteer.launch();
const page = await browser.newPage();

---------------------
page.on('console', consoleMessageObject => function (consoleMessageObject) {
    if (consoleMessageObject._type !== 'warning') {
        console.debug(consoleMessageObject._text)
    }
});

or

page.on('console', consoleObj => console.log(consoleObj.text()));   //this works but get a bunch of other stuff. - without this can see log showing in chromium console.
--------------------

await page.goto('https://google.com');
const result = await page.evaluate(() => {
    console.log('Browser scope.');
    return 'Normal scope.';
});
console.log(result)


// debugging port
start chrome with an extra CLI flag --remote-debugging-port=9229. Then you can open http://localhost:9229/json/version and find the webSocketDebuggerUrl

 async function createBrowser() {
    return await puppeteer.launch({
      headless: false,
      defaultViewport: null, //browser opens full viewport size.
      // devtools: true,
      executablePath:
        'C:/Users/webmaster/AppData/Local/Chromium/Application/chrome.exe',
      debuggingPort: 9229  //can be any interger.
    })
  }
```

# Events

- <https://nitayneeman.com/posts/getting-to-know-puppeteer-using-practical-examples/>

```ts
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Emitted when the DOM is parsed and ready (without waiting for resources)
  page.once('domcontentloaded', () => console.info('✅ DOM is ready'));

  // Emitted when the page is fully loaded
  page.once('load', () => console.info('✅ Page is loaded'));

  // Emitted when the page attaches a frame
  page.on('frameattached', () => console.info('✅ Frame is attached'));

  // Emitted when a frame within the page is navigated to a new URL
  page.on('framenavigated', () => console.info('👉 Frame is navigated'));

  // Emitted when a script within the page uses `console.timeStamp`
  page.on('metrics', (data) =>
    console.info(`👉 Timestamp added at ${data.metrics.Timestamp}`)
  );

  // Emitted when a script within the page uses `console`
  page.on('console', (message) =>
    console[message.type()](`👉 ${message.text()}`)
  );

  // Emitted when the page emits an error event (for example, the page crashes)
  page.on('error', (error) => console.error(`❌ ${error}`));

  // Emitted when a script within the page has uncaught exception
  page.on('pageerror', (error) => console.error(`❌ ${error}`));

  // Emitted when a script within the page uses `alert`, `prompt`, `confirm` or `beforeunload`
  page.on('dialog', async (dialog) => {
    console.info(`👉 ${dialog.message()}`);
    await dialog.dismiss();
  });

  // Emitted when a new page, that belongs to the browser context, is opened
  page.on('popup', () => console.info('👉 New page is opened'));

  // Emitted when the page produces a request
  page.on('request', (request) => console.info(`👉 Request: ${request.url()}`));

  // Emitted when a request, which is produced by the page, fails
  page.on('requestfailed', (request) =>
    console.info(`❌ Failed request: ${request.url()}`)
  );

  // Emitted when a request, which is produced by the page, finishes successfully
  page.on('requestfinished', (request) =>
    console.info(`👉 Finished request: ${request.url()}`)
  );

  // Emitted when a response is received
  page.on('response', (response) =>
    console.info(`👉 Response: ${response.url()}`)
  );

  // Emitted when the page creates a dedicated WebWorker
  page.on('workercreated', (worker) =>
    console.info(`👉 Worker: ${worker.url()}`)
  );

  // Emitted when the page destroys a dedicated WebWorker
  page.on('workerdestroyed', (worker) =>
    console.info(`👉 Destroyed worker: ${worker.url()}`)
  );

  // Emitted when the page detaches a frame
  page.on('framedetached', () => console.info('✅ Frame is detached'));

  // Emitted after the page is closed
  page.once('close', () => console.info('✅ Page is closed'));

  await page.goto('https://pptr.dev');

  await browser.close();
})();
```

## Custom-events

- <https://github.com/puppeteer/puppeteer/blob/main/examples/custom-event.js>

```ts
'use strict';

const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Define a window.onCustomEvent function on the page.
  await page.exposeFunction('onCustomEvent', (e) => {
    console.log(`${e.type} fired`, e.detail || '');
  });

  /**
   * Attach an event listener to page to capture a custom event on page load/navigation.
   * @param {string} type Event name.
   * @returns {!Promise}
   */
  function listenFor(type) {
    return page.evaluateOnNewDocument((type) => {
      document.addEventListener(type, (e) => {
        window.onCustomEvent({ type, detail: e.detail });
      });
    }, type);
  }

  await listenFor('app-ready'); // Listen for "app-ready" custom event on page load.

  await page.goto('https://www.chromestatus.com/features', {
    waitUntil: 'networkidle0',
  });

  await browser.close();
})();
```

# Custom Commands

- <https://chercher.tech/puppeteer/custom-commands-in-puppeteer>

```ts
module.exports = {
  ClickMe: async function (page, selector) {
    try {
      await page.waitForSelector(selector);
      await page.click(selector);
      console.log((await 'Clicked on : ') + selector);
    } catch (error) {
      throw new Error('Could not click on the');
    }
  },
};

// test file:
const puppeteer = require('puppeteer');
const { ClickMe } = require('./custom-commands');
async function run() {
  const browser = await puppeteer.launch({ headless: false });
  const page = await browser.newPage();
  await page.goto('https://google.com/');
  await ClickMe(page, 'div>a');
}
run();

or;
async function InputBox(element = page, selector, text) {
  try {
    await element.waitForSelector(selector);
    await element.type(selector, text);
  } catch (e) {
    console.log(`Error with selector ${selector}`, e.message);
  }
}
async function Click(element = page, selector) {
  try {
    await element.waitForSelector(selector);
    await element.click(selector);
  } catch (e) {
    console.log(`Error with selector ${selector}`, e.message);
  }
}
```

# Get Images

```ts
// get all image address
const fs = require('fs/promises');

const urls = await page.$$eval('selector', (el) => el.map((x) => x.src));
// for loop get all photos
for (const imageUrl of urls) {
  const imageName = imageUrl.split('/').pop();
  const image = await.goto(imageUrl); // this changes the page, so code written after this will point to this page.
  await fs.writeFile('imageName', image.buffer()); //write buffer to file.
}
```
