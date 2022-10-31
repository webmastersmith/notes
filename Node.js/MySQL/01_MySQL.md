# MySQL Nodejs

- [Node MySQL2](https://www.npmjs.com/package/mysql2)

```js
const mysql = require('mysql2');
const database = 'Avocados';

const con = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: database,
  port: 3306,
});

con.connect(function (err) {
  if (err) throw err;
  console.log('Connected!');
});
```

### Synchronous Readline

**index.ts**

```ts
import avocado_schema from './mysql/avocado_schema';
import avocado_data from './mysql/avocado_data';

(async function main() {
  const mysql = require('mysql2/promise');

  let con: any;
  const database = 'Avocados';
  try {
    con = await mysql.createConnection({
      host: '127.0.0.1',
      user: 'root',
      password: 'password',
      database: database,
      port: 3306,
    });
    console.log(`Successful connection to ${database} database`);
    // database must already exist, or error with the 'USE' function.
    // setup end

    await avocado_schema(con);

    const files = ['type', 'region', 'price'];
    // this is synchronous code. Will finish file before calling next file.
    for (const file of files) {
      await avocado_data(con, file);
    }
  } catch (e) {
    if (e instanceof Error) {
      console.log('Main: ', e.message);
    } else {
      console.log(String(e));
    }
  } finally {
    await con.end();
    console.log('Successfully Closed Connection.');
  }
})();
```

**schema.ts**

```ts
export default async function (con: any) {
  const type = `(
    typeid INT NOT NULL AUTO_INCREMENT,
    type VARCHAR(30),
    PRIMARY KEY (typeid)
  )`;
  const region = `(
    regionid INT NOT NULL,
    region VARCHAR(100),
    PRIMARY KEY (regionid)
  )`;
  // table must exist before referencing it with a foreign key.
  const price = `(
    id INT NOT NULL AUTO_INCREMENT,
    date DATE,
    avgprice DECIMAL(10, 2) NOT NULL,
    totalvol DECIMAL(10, 2) NOT NULL,
    avo_a DECIMAL(10, 2) NOT NULL,
    avo_b DECIMAL(10, 2) NOT NULL,
    avo_c DECIMAL(10, 2) NOT NULL,
    typeid INT NOT NULL,
    regionid INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (regionid) REFERENCES region (regionid),
    FOREIGN KEY (typeid) REFERENCES type (typeid)
  )`;

  // call order is important. table must exist before a foreign key can reference it.
  const tables = [
    ['type', type],
    ['region', region],
    ['price', price],
  ];

  await Promise.all(
    tables.map((table) => {
      let sql = `CREATE TABLE ${table[0]} ${table[1]};`;
      console.log(sql);
      return con.execute(sql);
    })
  );
}
```

**data.ts**

```ts
export default async function addData(con: any, file: string) {
  console.log(`${file} started`);
  const rl = require('readline/promises').createInterface({
    input: require('fs').createReadStream(`mysql/${file}.csv`),
    crlfDelay: Infinity,
  });
  let count = 0;
  // used this way instead of rl.on('line', (line)=>{}), because this is the only way to 'stream' a file synchronously with node. Connection will close before all lines can be read with rl.on('line').
  for await (const line of rl) {
    if (count === 0) {
      // skip 1st line
      count++;
    } else {
      // is file price?
      if (file === 'price') {
        const newLine = line.split(',');
        newLine[0] = `'${newLine[0]}'`;
        const sql = `INSERT INTO ${file} VALUES (${count++},${newLine});`;
        await con.execute(sql);
      } else {
        const sql = `INSERT INTO ${file} VALUES (${count++},'${
          line.split(',')[1]
        }');`;
        await con.execute(sql);
      }
    }
  }
  console.log(`${file} ended.`);
  return;
}
```
