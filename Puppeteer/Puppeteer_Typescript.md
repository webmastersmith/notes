# Puppeteer Typescript

**node**

- npm i puppeteer-core dotenv
  - <https://www.npmjs.com/package/puppeteer-core>
- npm i -D typescript
  - <https://github.com/puppeteer/puppeteer/blob/main/docs/api.md>

**nextjs**

- typescript and dotenv already installed.
- npm i puppeteer-core //run with 'ts-node fileName'.

**.env**

- `CHROME= "C:/Users/USER_NAME/AppData/Local/Chromium/Application/chrome.exe"`

**index.ts** // simple start

```ts
import puppeteer from 'puppeteer-core';
import 'dotenv/config';
(async () => {
  async function createBrowser() {
    return await puppeteer.launch({
      headless: false,
      devtools: true,
      executablePath: process.env.CHROME,
    });
  }

  const browser = await createBrowser();

  try {
    // Create a new incognito browser context
    const context = await browser.createIncognitoBrowserContext();
    // Create a new page inside context.
    const page = await context.newPage();

    await page.goto('https://google.com', { waitUntil: 'networkidle0' });
    console.log('Im in!!!!');
    await page.close();
  } catch (e) {
    console.error(e);
  } finally {
    // await browser.close()
  }
})();
```

# Extend typescript

- <https://github.com/puppeteer/puppeteer/issues/6214>

```ts
import * as puppeteer from 'puppeteer';

declare module 'puppeteer' {
  export interface Page {
    waitForTimeout(duration: number): Promise<void>;
  }
}
```
