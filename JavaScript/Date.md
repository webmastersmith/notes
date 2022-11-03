# Date

- New Proposal: `Temporal`
- <https://2ality.com/2021/06/temporal-api.html>
- <https://blog.openreplay.com/is-it-time-for-the-javascript-temporal-api>

**Date Constructor**

- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date>
- <https://www.w3schools.com/jsref/jsref_obj_date.asp>
- the date is expressed as a number or string. new Date('January 1, 1970 00:00:00')
- Date object returns: (year, monthIndex \[, day \[, hours \[, minutes \[, seconds \[, milliseconds\]\]\]\]\]);
- Note: The only correct way to instantiate a new Date object is by
  using the new operator. If you simply call the Date object directly,
  such as now = Date(), the returned value is a string rather than a
  Date object.
- An integer value representing the number of milliseconds since 'Unix-Epoch': January 1, 1970, 00:00:00
- A day is made up of 86,400,000 milliseconds.
  - 86,400 seconds in a day.
- Coordinated Universal Time (UTC), the global standard time defined by the World Time Standard. This time is historically known as Greenwich Mean Time -GMT, as UTC lies along the meridian that includes London
  and nearby Greenwich in the United Kingdom. The user's device provides the local time.
- CST central standard time -6 hours from UTC Universal Time.

**new Date**

- newDate  =  new Date('2019-11-04T19:47:00-06:00') // year, month, day, Time 24 hour, -6 cst.
- anotherNewDate  =  new Date(2019, 10, 4, 19, 55, 40) //Mon Nov 04 2019 19:55:40 GMT-0600 (Central Standard Time)
  - year, month (0-11), day, hour (24), minute, seconds. Time zone comes from browser.

**Date String to Date Constructor**

- <https://stackoverflow.com/questions/5619202/parsing-a-string-to-a-date-in-javascript>

```js
var parts = '2014-04-03'.split('-');
// Please pay attention to the month (parts[1]); JavaScript counts months from 0:
// January - 0, February - 1, etc.
var mydate = new Date(parts[0], parts[1] - 1, parts[2]);
console.log(mydate.toDateString());

const d = '28/10/2013'.split('/'); //['28', '10', '2013']  //day, month, year
new Date(d[2], d[1] - 1, d[0]); //year, month, day
```

**Date Methods**

- <https://www.w3schools.com/jsref/jsref_obj_date.asp>
- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date>
- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/Date>
- **new Date().toDateString().replace(/\s/g, '\_') **//"Wed_Jan_01_2020"
- new Date().toISOString().split('T')\[0\] //"2022-02-15"
- **Date() //**When called as a function, returns a string representation of the current date and time, exactly as **new Date().toString()** does.
  - always returns a string.
- **Date.now()** // 1577920170345 (milliseconds since January 1, 1970 00:00:00 UTC)
  - The static Date.now() method returns the number of **milliseconds** elapsed since January 1, 1970
  - this can be manipulated just as easy as date. // const date = new Date(1577920170345).toLocaleString('default', {month: 'long'}) // January
- new Date().getTime() //1643665348069 (milliseconds since January 1, 1970 00:00:00 UTC)
  - <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getTime>
- new Date() object to Unix-Epoch milliseconds.
- new Date().getFullYear() // 2020
- new Date().getMonth() // 1 (0-11) **new Date().getMonth() + 1 // returns month (1-12)**
- new Date().getDate() // 1 (shows day of the month, interger 1-31)
- new Date().getDay() // 3 (0-6)
- new Date().getHours() // 16 (0-23)
- new Date().getMinutes() // 47 (0-59)
- new Date().getSeconds() // 03 (0-59)
- **new Date().toISOString()** //"2022-02-02T20:02:51.556Z" //**best way to store accurate date info.**
  - <https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/timestamp.proto>
  - In JavaScript, one can convert a Date object to this format using the standard

```js
// A Timestamp represents a point in time independent of any time zone or local
// calendar, encoded as a count of seconds and fractions of seconds at
// nanosecond resolution. The count is relative to an epoch at UTC midnight on
// January 1, 1970, in the proleptic Gregorian calendar which extends the
// Gregorian calendar backwards to year one.
//
// All minutes are 60 seconds long. Leap seconds are "smeared" so that no leap
// second table is needed for interpretation, using a [24-hour linear
// smear](https://developers.google.com/time/smear).
//
// The range is from 0001-01-01T00:00:00Z to 9999-12-31T23:59:59.999999999Z. (year 9999) By
// restricting to that range, we ensure that we can convert to and from [RFC
// 3339](https://www.ietf.org/rfc/rfc3339.txt) date strings.
```

- toLocaleString() //toLocaleDateString, toLocaleTimeString do the same thing except they add default info if you don't use options.
- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date#JavaScript_Date_instances>
- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleString>
- <https://stackoverflow.com/questions/1643320/get-month-name-from-date/18648314#18648314>

```js
new Date('2021-05-12').toLocaleString('en-US', {
  //all options values must be type string.
  day: 'numeric', //options: 2-digit | numeric   -1-31
  month: 'long', //options: 2-digit | numeric | narrow | short  -numeric is 0-11
  year: 'numeric', //options: 2-digit | numeric  -numeric 2021
}); // May 11, 2021

const d = new Date(); // Date Wed Jan 01 2020 16:47:03 GMT-0600 (Central Standard Time)
d.toString(); // "Wed Jan 01 2020 16:47:03 GMT-0600 (Central Standard Time)"
d.toDateString(); // "Wed Jan 01 2020"
d.toLocaleString(); // "1/1/2020, 4:47:03 PM"
d.toLocaleString('default', { month: 'long' }); // "January"
d.toLocaleString('en-US', { month: 'long' }); // "January"
log(
  d.toLocaleString('en-US', {
    // what you put in here will be displayed.
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    weekday: 'long',
  })
); // "Wednesday, January 1, 2020"
d.toLocaleTimeString(); //"4:47:03 PM"
```

**Convert Unix-Epoch time stamp to date:**

- const d = new Date(1577920170345) //returns date object. (Mon Mar 23 2020 19:18:07 GMT-0500 (Central Daylight Time))
  - d.toLocaleString() //3/23/2020, 7:06:48 PM

**Leap Year**

- a leap year happens every year that is divisible by four -- and here’s the tricky part -- except for the years that are both:
  - divisible evenly by 100 and
  - not divisible evenly by 400.

```js
function isLeapYear(year) {
  if (year % 4 === 0) {
    if (year % 100 === 0 && year % 400 !== 0) {
      return false;
    }
    return true;
  }
  return false;
}

const isLeapYear = (year) =>
  year % 4 !== 0 ? false : year % 100 === 0 && year % 400 !== 0 ? false : true;
console.log(isLeapYear(2016));
// leap years
// 2004, 2008, 2012, 2016, 2020, 2024, 2028, 2032, 2036, 2040, 2044, 2048, 2052, 2056, 2060, 2064, 2068, 2072, 2076, 2080, 2084, 2088, 2092, 2096.
// not a leap year because they are evenly divisible by 100 but not by 400.
// 1700, 1800, 1900, 2100, 2200, 2300, 2500, 2600
```

**Day in Year**

```js
// prettier-ignore
function daysIntoYear(date){
    return (Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()) - Date.UTC(date.getFullYear(), 0, 0)) / 24 / 60 / 60 / 1000;
}
const day = daysIntoYear(new Date()); //6 -day 6 of 365 days.
```

**Date.parse()**

- convert date to millisecond
  - `var msec = Date.parse("March 21, 2012")` // 1332306000000
- convert back to date object
  - `var d = new Date(msec)` // Wed Mar 21 2012 00:00:00 GMT-0500

**Setters**

- 3 date input formats

1. ISO Date // "2015-03-25" (The International Standard)
   1. ISO is most common
2. Short Date needs leading zeros or can cause error.
   1. Short Date // "03/25/2015"
3. Long Date // "Mar 25 2015" or "25 Mar 2015"

```js
var d = new Date('1975-03-25'); // Mon Mar 24 1975 19:00:00 GMT-0500
```

Date Library's

- [_https://github.com/iamkun/dayjs_](https://github.com/iamkun/dayjs)
- [_https://momentjs.com/_](https://momentjs.com/)
- [_https://date-fns.org/_](https://date-fns.org/)

Luxon

- <https://www.npmjs.com/package/luxon>
- <https://moment.github.io/luxon/api-docs/index.html>

Moment 3rd Party Library

- <https://momentjs.com/docs/>

- <https://cdnjs.com/libraries/moment.js>

- <https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment-with-locales.min.js>

  - Note: if you chain multiple actions to construct a date, you should
    start from a year, then a month, then a day etc. Otherwise you may
    get unexpected results, like when day=31 and current month has only
    30 days (the same applies to native JavaScript Date manipulation),
    the returned date will be the 30th of the current month (see month
    for more details).

log(moment().year(1975).month(5).date(4).format('MMM D, YYYY')) // Jun
4, 1975

- - Get Time Only

    - moment().format('h:mm:ss a') //**4:50:57 pm //A = PM**

const now = moment()

log(now.hour())

log(now.minute())

log(now.second())

log(now.millisecond())

log(moment().\_d) // date object

log(now.toString())

log(now.quarter())

- - <https://momentjs.com/docs/#/displaying/>

log(now.format('MMMM D, Y'))

- - add and subtract / clone
  - <https://momentjs.com/docs/#/manipulating/>

const newNow = now.clone()

// now.add(number, string)

now.add(1, 'y')

log(now.toString())

log(newNow.toString())

- - .fromNow()
  - [**https://momentjs.com/docs/#/displaying/fromnow/**](https://momentjs.com/docs/#/displaying/fromnow/)

now.subtract(1, 'w').subtract(20, 'd')

log(now.fromNow()) // a month ago; a few seconds ago; a week ago.

- - timeStamp
  - [**https://momentjs.com/docs/#/displaying/unix-timestamp-milliseconds/**](https://momentjs.com/docs/#/displaying/unix-timestamp-milliseconds/)

log(now.valueOf()) // (1575600176594) milliseconds since unix-epoch

- - Do not use moment().unix() for timestamp. -this will be wrong,
    because epoch time is in milliseconds not seconds.

log(moment(1575600176594).toString()) // Thu Dec 05 2019 20:42:56
GMT-0600

- - subtact two timestamp dates

    - unix converts to seconds

moment(1577936186899).subtract(1577936170899).unix() *// 16 seconds*

moment(1577936186899).subtract(1577936170899).format('s') // '16'
(seconds)

- -
