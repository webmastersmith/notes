# JSON

[JSON](https://www.json.org/json-en.html)

- keys must be strings in double quotes.
- values can be any type. (number, string, array, object, boolean, null)
- No comments (// or /\* \*/) are allowed in JSON data.
- A JSON object is surrounded by curly braces {}.
- The name-value pairs are grouped by a colon (:) and separated by a comma (,).
- An array begins with a left bracket and ends with a right bracket [].
- The trailing commas and leading zeros in a number are prohibited.
- The octal and hexadecimal formats are not permitted.
- Each key within the JSON should be unique and should be enclosed within the double-quotes.
- The boolean type matches only two special values: true and false and NULL values are represented by the null literal (without quotes).

```json
{
  "firstName": "John",
  "lastName": "Snow",
  "age": 25,
  "children": ["Betty", "Sue", "Charlie"],
  "spouse": null,
  "address": {
    "street": "7504 Taylor Drive",
    "city": "New York City",
    "state": "New York",
    "postalCode": "11238"
  },
  "phoneNumbers": [
    {
      "type": "mobile",
      "number": "212 555-3346"
    },
    {
      "type": "fax",
      "number": "646 555-4567"
    }
  ]
}
```
