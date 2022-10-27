# SQLite3

### install

[sqlite3](https://kontext.tech/article/617/install-sqlite-3-on-wsl)

**Version**

- `sqlite3 --version`

**enter sqlite3 shell**

- `sqlite3 databaseName.db` // if not exist will create in local directory.

**exit sqlite3 shell**

- `.exit`

**Create Database**

- sqlite3 test.db
- list database: `.databases` // must be in sqlite shell

**Data Types**

- null, integer, real, text, and blob.

**Create Table**

- list tables `.tables`

```sql
CREATE TABLE IF NOT EXISTS table_name (
	column_1 data_type PRIMARY KEY,
  column_2 data_type NOT NULL,
	column_3 data_type DEFAULT 0,
	table_constraints
);
CREATE TABLE IF NOT EXISTS Customers (
	id integer PRIMARY KEY NOT NULL,
  name text NOT NULL,
	age integer DEFAULT 0
);
```

**Insert**

```sql
INSERT INTO table_name (column1,column2 ,..) VALUES( value1, value2,...);
INSERT INTO Customers VALUES (1, "Adam", 30);
INSERT INTO Customers VALUES (2, "Sagar", 31);
INSERT INTO Customers VALUES (3, "Arman", 32);

```

## Import from csv

1. set mode:`.mode csv`
2. import: `.import File_Name Table_Name`
3. verify: `.schema Table_Name`
4. `.exit`
