Puppeteer-Extra

- <https://www.npmjs.com/package/puppeteer-extra>
- <https://filipvitas.medium.com/how-to-set-user-agent-header-with-puppeteer-js-and-not-fail-28c7a02165da>
- <https://scrapingant.com/blog/puppeteer-tricks-to-avoid-detection-and-make-web-scraping-easier>
- npm i puppeteer-core puppeteer-extra puppeteer-extra-plugin-stealth dotenv puppeteer-extra-plugin-adblocker

**new**

```ts
import puppeteer from 'puppeteer-extra';
import { executablePath } from 'puppeteer';
puppeteer.use(require('puppeteer-extra-plugin-stealth')());
puppeteer.use(require('puppeteer-extra-plugin-anonymize-ua')());

export async function search() {
  // const resolution = {
  //   x: 1280,
  //   y: Number(`80${Math.floor(Math.random() * 10)}`), //0-9
  // };
  const args = [
    // `--window-size=${resolution.x},${resolution.y}`,
    '--no-sandbox',
    // '--disable-setuid-sandbox',
    // '--disable-infobars',
    // '--window-position=0,0',
    // '--ignore-certifcate-errors',
    // '--ignore-certifcate-errors-spki-list',
    // '--user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101 Firefox/108.0"'
  ];
  const browser = await puppeteer.launch({
    executablePath: executablePath(),
    ignoreHTTPSErrors: true,
    headless: true,
    args,
    // devtools: true,
    //defaultViewport: null;  -will cause browser to open up to viewport size.
  });
}
```

**old**

```ts
import puppeteer from 'puppeteer-extra';
//const puppeteer = require('puppeteer-extra')
//require('dotenv').config()

// Add stealth plugin and use defaults (all tricks to hide puppeteer usage)
const StealthPlugin = require('puppeteer-extra-plugin-stealth');
puppeteer.use(StealthPlugin());

// Add adblocker plugin to block all ads and trackers (saves bandwidth)
const AdblockerPlugin = require('puppeteer-extra-plugin-adblocker');
puppeteer.use(AdblockerPlugin({ blockTrackers: true }));

// That's it, the rest is puppeteer usage as normal 😊
puppeteer
  .launch({ headless: true, executablePath: process.env.LOCAL })
  .then(async (browser) => {
    const page = await browser.newPage();
    await page.setViewport({ width: 800, height: 600 });
    await page.setUserAgent(
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36'
    );

    console.log(`Testing adblocker plugin..`);
    await page.goto('https://www.vanityfair.com');
    await page.waitForTimeout(1000);
    await page.screenshot({ path: 'adblocker.png', fullPage: true });

    console.log(`Testing the stealth plugin..`);
    await page.goto('https://bot.sannysoft.com');
    await page.waitForTimeout(5000);
    await page.screenshot({ path: 'stealth.png', fullPage: true });

    console.log(`All done, check the screenshots. ✨`);
    await browser.close();
  });
```

**devtools -dock at bottom**

- [_https://chromium.googlesource.com/chromium/src/+/refs/heads/main/chrome/common/pref_names.cc_](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/chrome/common/pref_names.cc)
- [_https://www.npmjs.com/package/puppeteer-extra-plugin-user-preferences?activeTab=readme_](https://www.npmjs.com/package/puppeteer-extra-plugin-user-preferences?activeTab=readme)
- `ctrl + shift + d` // restore devtools last state.
- `ctrl + [ or ]` // move tabs in devtools

```ts
const puppeteer = require('puppeteer-extra');
const puppeteerPrefs = require('puppeteer-extra-plugin-user-preferences');

(async () => {
  puppeteer.use(
    puppeteerPrefs({
      userPrefs: {
        devtools: {
          preferences: {
            currentDockState: '"bottom"',
          },
        },
      },
    })
  );

  const browser = await puppeteer.launch({
    headless: false,
    devtools: true,
  });
})();
```
