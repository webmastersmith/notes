# SQL Create Read Update Delete

- Use single quotes only!

**scalar**

- return a single data value.

**Comment**

- `--` //double dash

### SQL Statements

- **DDL**
  - Data Definition Language - CREATE, ALTER, DROP // create/modify the table itself
  - SQL sub-commands to create, delete, database or tables.
- **DML**
  - Data Manipulation Language - SELECT, INSERT, UPDATE, DELETE // alter data in the table not table itself.
  - basic CRUD commands.
- **DCL**
  - Data Control Language - GRANT, REVOKE
- **TCL**
  - Transaction Control Language - SAVEPOINT, ROLLBACK, COMMIT
  - allows you to 'undo' your query.

# DDL

- Data Definition Language - CREATE, ALTER, DROP

### CREATE

- all table names in a database must be unique
  - once a table is created, you cannot re-create another table with the same name.

**Database**

```sql
CREATE DATABASE db_name;
USE db_name;  -- postgres  \c db_name

-- show databases
SELECT name FROM sys.databases; --sql
SHOW DATABASES; -- mysql
SELECT datname FROM pg_database; --postgresql
```

**Table**

```sql
-- show tables
SHOW TABLES; -- mysql
\dt; -- postgresql
\dt+; -- postgresql tables with size

-- show table schema
DESCRIBE yourDatabasename.yourTableName; -- mysql
SELECT * FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tableName'; --sql


-- schema examples
CREATE TABLE customers (
  id      INT NOT NULL AUTO_INCREMENT,
  name    VARCHAR(255), --characters
  age     INT,
  weight  DECIMAL(30, 2), -- DECIMAL(65) total. (before decimal, after decimal)
  PRIMARY KEY (id)
);

-- Using primary keys
CREATE TABLE Customers (
  customerId    INT NOT NULL   PRIMARY KEY,
  first_name    VARCHAR(255)   NOT NULL,
  last_name     VARCHAR(255)   NOT NULL,
  age           INT            CHECK(age > 18)
  driverid INT NOT NULL,
  FOREIGN KEY (LOCAL_COLUMN_NAME) REFERENCES TABLE_NAME (COLUMN_NAME),
  FOREIGN KEY (driverid) REFERENCES drivers (driverid),

)
-- another way
CREATE TABLE Customers (
  empId Integer NOT NULL,
  skillId Integer NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  age INTEGER CHECK(age > 18),
  CONSTRAINT empPK PRIMARY KEY(empId, skillId) -- each value in the empId must be unique.
  -- or
  CONSTRAINT empPK PRIMARY KEY(empId, skillId) -- Composite key.
)

-- Foreign Key
CREATE TABLE Customer_Phones (
  customerId INT,
  REFERENCES Customers(customerId), --foreign key to customers
  phone VARCHAR NOT NULL,
  PRIMARY KEY(customerId, phone)
)
-- another way
CREATE TABLE Customers (
  empId Integer NOT NULL,
  skillId Integer NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  age INTEGER CHECK(age > 18),
  CONSTRAINT empPk PRIMARY KEY(empId, skillId), // Composite key.
  CONSTRAINT empFk FOREIGN KEY(empId) REFERENCES Employee(empId),
  CONSTRAINT skillFk FOREIGN KEY(skillId) REFERENCES Skills(skillId),
)

-- ON DELETE CASCADE
CONSTRAINT empFk FOREIGN KEY(empId) REFERENCES Employee(empId) ON DELETE CASCADE,
-- ON UPDATE CASCADE
CONSTRAINT skillFk FOREIGN KEY(skillId) REFERENCES Skills(skillId) ON UPDATE CASCADE,
```

### ALTER

- add or remove columns
- ADD (column_name data_type) //ADD (column1_name data_type, column2_name...)
- MODIFY column_name data_type constraint, //sql
- ALTER COLUMN //other sql dialects
- DROP COLUMN table_name //remove a column
- RENAME TO table_name //change table name
- RENAME COLUMN //change column name
- DROP CONSTRAINT / ADD CONSTRAINT //may have to drop constraint to change column name then re-add the constraint.

```sql
ALTER TABLE table_name ADD COLUMN new_column_name VARCHAR(30);
-- or
ALTER TABLE Orders
  ADD CONSTRAINT empPk PRIMARY KEY (ID);
-- add foreign key
ALTER TABLE Orders
  ADD CONSTRAINT empPk FOREIGN KEY (ID)
    REFERENCES Skills(skillId);
-- DROP foreign key
ALTER TABLE Orders
  DROP CONSTRAINT empFk;

-- CHECK CONSTRAINT
ALTER TABLE Orders
  ADD CONSTRAINT holidayDates
  CHECK (startDate < endDate)
```

### DROP

- cannot drop table with constraints

```sql
DROP TABLE table_name -- all data will be lost.
TRUNCATE TABLE table_name -- just remove data.
```

# DML

- Data Manipulation Language - SELECT, INSERT, UPDATE, DELETE //alter data in the table not table itself.

### SELECT

- extract data from database.
- create a new relation
- feed information into new query.

**Querying data**

```sql
ORDER BY table_name; -- sort

SELECT column1,column2, ... FROM table_name; -- return all data from those columns.

-- * wildcard -select all columns
SELECT * FROM customers;

-- Filter with condition
SELECT * FROM customers WHERE age > 21;

-- Filter with multiple conditions
SELECT * FROM customers WHERE age < 21 AND state = "NY";

-- Filter with IN
SELECT * FROM customers WHERE plan IN ("free", "basic");

-- Select specific columns
SELECT name, age FROM customers;

-- Order results
SELECT * FROM customers WHERE age > 21 ORDER BY age DESC;

-- Transform with CASE
-- See also: filtering with LIKE, restricting with LIMIT, using ROUND and other core functions.
SELECT name, CASE WHEN age > 18 THEN "adult" ELSE "minor" END "type" FROM customers;

-- Distinct -remove duplicate rows
SELECT DISTINCT column_name FROM table_name;

-- Limit
SELECT * FROM table_name LIMIT 10;
```

### INSERT

```sql
-- if your not adding data to ALL the columns, you must specify what columns you are adding data to.
INSERT INTO table_name (column1_name, column2_name, ...) VALUES (value1, value2, ...)
-- Inserting data
INSERT INTO customers VALUES (1973, 'Brian', 33);  --must enter all data.
-- Inserting partial data for named columns
INSERT INTO customers (name) VALUES ('Brian');  --year and age will be null.

INSERT INTO customers
VALUES (1950, 'John', 55), (1999, 'Ajax', 5), (1980, 'Bob', 40) -- each will be a new row in 'customers' table.
```

### Update

- change data without having to add or remove whole row.

```sql
UPDATE table_name SET column1_name=value, column2_name= value, ....;

UPDATE table_name
SET column_name = newValue -- target attributes you want to change.
WHERE column_name = 'George'; -- specify row or rows you want to change

UPDATE table_name SET column_name = 31 WHERE id=1;

-- wildcard
UPDATE table_name
SET column_name = newValue -- target attributes you want to change.
WHERE column_name LIKE 'Ge%'; -- specify rows you want to change

```

### DELETE

- permanent memory loss.

```sql
DELETE FROM table_name; -- all rows deleted!
DELETE FROM table_name WHERE column_name = 'value';
DELETE FROM Customers WHERE id LIKE '7%'; -- delete all rows where id value starts with a 7

```

# DCL

- Data Control Language - GRANT, REVOKE

```sql
-- change 'password' to your new password.
ALTER USER 'root'@'localhost' IDENTIFIED BY 'yourNewPassword';
```

# TCL

- Transaction Control Language - SAVEPOINT, ROLLBACK, COMMIT
- allows you to 'undo' your query.

**COMMIT**

- queries to database are not 'permanent' immediately.
- `SET AUTOCOMMIT = OFF;` // turns off auto commit. on by default
- COMMIT commits all uncommitted changes.
- multiple sql commands can be committed at once.
- others may not be able to access data or change data till you commit.

**SAVEPOINT**

- saves a snapshot of database at any point
- can have multiple save points
- SAVEPOINT savepoint_name; // creates a snapshot of data.

**ROLLBACK**

- ROLLBACK TO SAVEPOINT savepoint_name; //restores data to this snapshot.
- you cannot undo a rollback action.
- cannot rollback past COMMIT statement.
- only work on data that has been changed since database was turned on, to truly have a backup, you must use physical backups.
