# SQL Create Read Update Delete

- Use single quotes only!

**scalar**

- return a single data value.

**Comment**

- `--` //double dash

### SQL Statements

- **DDL**
  - Data Definition Language - CREATE, ALTER, DROP //create/modify the table itself
  - SQL sub-commands to create, delete, database or tables.
- **DML**
  - Data Manipulation Language - SELECT, INSERT, UPDATE, DELETE //alter data in the table not table itself.
  - basic CRUD commands.
- **DCL**
  - Data Control Language - GRANT, REVOKE
- **TCL**
  - Transaction Control Language - SAVEPOINT, ROLLBACK, COMMIT
  - allows you to 'undo' your query.

# CRUD

### CREATE

- all table names in a database must be unique
  - once a table is created, you cannot re-create another table with the same name.

**Database**

```sql
CREATE DATABASE db_name;
USE db_name  -- postgres  \c db_name
```

**Table**

```sql
CREATE TABLE customers (
id      INTEGER     PRIMARY KEY,
name    TEXT,
age     INTEGER,
weight  REAL
);

-- Using primary keys
CREATE TABLE Customers (
customerId    INTEGER   PRIMARY KEY,
first_name    VARCHAR   NOT NULL,
last_name     VARCHAR   NOT NULL,
age           INTEGER   CHECK(age > 18)
)
-- another way
CREATE TABLE Customers (
empId Interger NOT NULL,
skillId Interger NOT NULL,
first_name VARCHAR NOT NULL,
last_name VARCHAR NOT NULL,
age INTEGER CHECK(age > 18),
CONSTRAINT empPK PRIMARY KEY(empId, skillId) -- each value in the empId must be unique.
-- or
CONSTRAINT empPK PRIMARY KEY(empId, skillId) -- Composite key.
)

-- Foreign Key
CREATE TABLE Customer_Phones (
customerId INTEGER,
REFERENCES Customers(customerId), --foreign key to customers
phone VARCHAR NOT NULL,
PRIMARY KEY(customerId, phone)
)
-- another way
CREATE TABLE Customers (
empId Interger NOT NULL,
skillId Interger NOT NULL,
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

**sub-commands**

- ADD (column_name data_type) //ADD (column1_name data_type, column2_name...)
- MODIFY column_name data_type contraint, //sql
- ALTER COLUMN //other sql dialects
- DROP COLUMN table_name //remove a column
- RENAME TO table_name //change table name
- RENAME COLUMN //change column name
- DROP CONSTRAINT / ADD CONSTRAINT //may have to drop constraint to change column name then re-add the constraint.

```sql
ALTER TABLE table_name ADD COLUMN new_column_name VARCHAR(30);
-- or
ALTER TABLE ORDERS
  ADD CONSTRAINT empPk PRIMARY KEY (ID);
-- add foreign key
ALTER TABLE ORDERS
  ADD CONSTRAINT empPk FOREIGN KEY (ID)
    REFERENCES Skills(skillId);
```

### DROP

- cannot drop table with contraints

```sql
DROP TABLE table_name //all data will be lost.
TRUNCATE TABLE table_name //just remove data.
```

## DML

- Data Manipulation Language - SELECT, INSERT, UPDATE, DELETE //alter data in the table not table itself.

**Inserting data**

```sql
INSERT INTO table_name (column1_name, column2_name, ...) VALUES (value1, value2, ...)
if your not adding data to ALL the columns, you must specify what columns you are adding data to.

    Inserting data
    INSERT INTO customers VALUES (73, 'Brian', 33);  --must enter all data.

    Inserting partial data for named columns
    INSERT INTO customers (name) VALUES ('Brian');  --age will be null.
```

**Querying data**
**SELECT**

```sql
ORDER BY table_name; //sort

SELECT column1,column2, ... From table_name;

  -- * wildcard -select all columns
    SELECT * FROM customers;

    Filter with condition
    SELECT * FROM customers WHERE age > 21;

    Filter with multiple conditions
    SELECT * FROM customers WHERE age < 21 AND state = "NY";

    Filter with IN
    SELECT * FROM customers WHERE plan IN ("free", "basic");

    Select specific columns
    SELECT name, age FROM customers;

    Order results
    SELECT * FROM customers WHERE age > 21 ORDER BY age DESC;

    Transform with CASE
    SELECT name, CASE WHEN age > 18 THEN "adult" ELSE "minor" END "type" FROM customers;
-- See also: filtering with LIKE, restricting with LIMIT, using ROUND and other core functions.
```

**Aggregate functions**

- process input and returns a scalar (single) value.
- PostgreSQL will create a result table and the aggregate function will name the column after itself unless you provide an alias. //AS
- AVG(column_name) FROM table_name; //return average value.
- COUNT(\*) FROM table_name; //returns how many records table has.
  - COUNT(column_name) FROM table_name; //counts repeats in column name.
- FIRST/LAST FROM table_name; --first row of table or last row of table.
- MIN/MAX(age) FROM customers;
  - work with varchar (a-z) text as well.
  - SELECT min(column_name) from table_name; //returns lowest interger/char.
- NOW() //return date-time timestamp.
- SUM(column_name) FROM table_name; //interger returns sum.
  - SELECT column, sum(column) AS pop from table_name group by column order by pop desc;
  - https://www.postgresqltutorial.com/postgresql-aggregate-functions/postgresql-sum-function/

```sql
SELECT column1, column2, AggregateFunction FROM table_name;
SELECT column_name, AggregateFunction FROM table_name; --must have comma!

-- See also: restricting results with HAVING.

-- GROUP BY
allows you to only process certian fields.
SELECT column_name, SUM(column_name) FROM table_name GROUP BY column_name;

-- WHERE
SELECT _ FROM table_name WHERE column_name > 25;
SELECT _ FROM table_name WHERE column_name LIKE "R%"; --any name starts with an 'R'.

-- LOGIC
AND, OR, OR NOT
LIKE "S%"; --wildcard
```

**Custom Functions**

- custom aggregateFunction or procedure that you have to run everyday.

```sql
-- example custom funtion
CREATE FUNCTION fn_name (
input1 type1,
input2 type2,
...
) RETURN type
BEGIN
--logic
END;
```

**Custom Stored Procedures**

- series of SQL statements executed as a batch, and invoked by a name.
- live on the database, but can be executed remotely by Java, Python ...
- Stored Procedures are safer and should be used where possible.

```sql
-- custom stored procedure
CREATE PROCEDURE procedure_name (
parameter1 IN type1,
parameter2 OUT type2,
...
)
BEGIN
--logic
END [procedure_name];

// to run
CALL procedure_name(params1, ...);
EXECUTE procedure_name(params1, ...);
```

**Subqueries**

- nested queries, inner query inform the outer
- subquery is just a query within a query. inner query is executed first.
- parenthesis is necessary to create the subquery.
- subquery always after comparison operator.
- If multiple matches, both records will be returned.
- IN //if the posibility of multiple matches

```sql
-- Subqueries

SELECT \*
FROM table_name
WHERE column_name = ( -- can have a problem if two values match query. So use 'IN' inplace of '='.
SELECT column_name
FROM table_name
WHERE column_name = (
SELECT MAX(colulmn_name)
FROM table_name
)
);

-- select lowest population from list of cities.
select \* from cities where population = (select min(population) from cities);

-- select lowest population and if two matches, select small id:
select \* from cities where id = (select min(id) from cities where population = (select min(population) from cities));
```

**Updating data**

- change data without having to add or remove whole row.

```sql
UPDATE table_name SET column1_name=value, column2_name= value, ....;

UPDATE table_name
SET column_name = newValue -- target attributes you want to change.
WHERE column_name = 'George'; -- specify row or rows you want to change

-- wildcard
UPDATE table_name
SET column_name = newValue -- target attributes you want to change.
WHERE column_name LIKE 'Ge%'; -- specify rows you want to change

```

**Deleting data**

- permanent memory loss.

```sql
DELETE FROM table_name; -- all rows deleted!
DELETE FROM customers WHERE id = 73;
DELETE FROM customers WHERE column_name LIKE '7%';

```

**WHERE**

- A WHERE clause is used to limit or filter the records affected by a command.
- Followed by a comparison statement that determines the conditions that need to be met in order for a record to be considered for the SQL command.
- A WHERE is always used in conjunction with another command.
- Update and delete must have a 'WHERE' condition.

**Comparison Operators**

- `age > 30` --greater than
- `=`
- `<`
- `<=`
- `=` --equal
- `!=` --not equal

**AS**

- alias name to reference column_name.
- aggregateFunction AS fn --returns it as a column_name.
- Join is usually faster than this type of query.
- Table
  - can add alias name after table name to give it an alias:

```sql
//simple example
SELECT cust.id FROM Customers cust;

//complex example
SELECT c.id,
c.lastname,
o.id,
o.order_cost
FROM Customers c,
OrderHistory o
WHERE c.id = o.id;
```

**GROUP BY**

- contanerize (group) data.

```sql
SELECT column1, column2, AggregateFunction FROM table_name GROUP BY column_name;
```

**ORDER BY**

- sort data by column_name
- asc //default small to big (a-z, 0-9)
- desc //big to small (z-a, 9-0)

```sql
select column_name, aggregateFunction from table_name group by column_name order by aggregateFunction_results asc;


-- group all state populations and order.
select state, sum(population) AS pop from cities group by state order by pop desc;
```

## TCL

- Transaction Control Language - SAVEPOINT, ROLLBACK, COMMIT
- allows you to 'undo' your query.

**COMMIT**

- queries to database are not 'permanent' immediately.
- `SET AUTOCOMMIT = OFF;` //turns off autocommit. on by default
- COMMIT commits all uncommited changes.
- multiple sql commands can be commited at once.
- others may not be able to access data or change data till you commit.

**SAVEPOINT**

- saves a snapshot of database at any point
- can have multiple save points
- SAVEPOINT savepoint_name; //creates a snapshot of data.

**ROLLBACK**

- ROLLBACK TO SAVEPOINT savepoint_name; //restores data to this snapshot.
- you cannot undo a rollback action.
- cannot rollback past COMMIT statement.
- only work on data that has been changed since database was turned on, to truly have a backup, you must use physical backups.

# Join

- Joins can be faster than SELECT statements working accross muliple tables.
- combines information from an operation of two tables. Returns a grid of columns
- The SQL Joins clause is used to combine records from two or more tables in a database. A JOIN is a means for combining fields from two tables by using values common to each.
- joining two tables requires that they have some data in common, like sharing a colomn.
- Foreign keys are easy to spot an easy way to join on.
- you can join on any column, but when columns match it's easier.

```sql
-- Inner join
SELECT customers.name, orders.item FROM customers LEFT OUTER JOIN orders ON customers.id =

orders.customer_id;
SELECT customers.name, orders.item FROM customers JOIN orders ON customers.id = orders.customer_id;
```

**Inner Join**

- most common.
- return only records from both tables that match a condition.

**Left Join**

- return left table and results from right table.

**Right Join** //opposite of left join.

- return full right table with results from left.

**Full Join**

- return all records from both tables.

**Outer Join**

- rows that do not have a match.

```sql
SELECT \*
FROM Customers c
LEFT JOIN Order_History o
ON c.id = o.id
WHERE o.id = NULL; //everything that does not match o.id.
```

## Union

- see results from two or more different SELECT statements.
- results stack vertically instead of horizontally.
- first column of first SELECT statement will line up with first column of second SELECT statement.
- rules
  - the number of columns returned must be the same.
  - data types must match in each column.

```sql
SELECT customerId, firstname, lastname
FROM Customers
UNION
SELECT customerId, firstname, lastname
FROM VIP_Customers
```
