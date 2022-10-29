# MySQL Nodejs

- [Node MySQL2](https://www.npmjs.com/package/mysql2)

```js
const mysql = require('mysql2');

const con = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'Avocados',
  port: 3306,
});

con.connect(function (err) {
  if (err) throw err;
  console.log('Connected!');
});
```
