# SQL

**Data Organization**

- quickly search records
- everyone needs to access records concurrently.
- users need the most recent data
- relation data should be linked (one change in one table that is linked to another table, info should be updated.)

**Structured Query Language**

- programming language used to communicate with data stored in a relational database management system. SQL syntax is similar to the English language, which makes it relatively easy to write, read, and interpret.
- SQL standard is managed by ANSI (American National Standards Institute)
- ANSI SQL refers to the pure SQL language.
  - different databases have there own additions.

**Naming**

- SQL commands are not case sensitive. Data, however, is case-sensitive.

**database**

- collection of (tables) organized information for easy access to manage, update.

**relational database**

- A relational database is a type of database. It uses a structure that allows us to identify and access data in relation to another piece of data in the database. Often, data in a relational database is organized into tables.
- A **relational database management system (RDBMS)** is a program that allows you to create, update, and administer a relational database. Most relational database management systems use the SQL language to access the database.

**query**

- single SQL statement.

**table (relation | file)**

- can have millions of rows and columns.
- ex... person table with multiple people, each person is a row, each column is a value (name, age, ...)

**rows (entry | tuple | record)**

- called records

**columns (attributes)**

- properties of each record

**Table Constraints**

- data normalization

**entity**

- something of importance that must be represented in a database.
- represented on single table.

**relation**

- table - matrix of rows and columns
- see normalize values.

**Database Keys**

**Unique Key**

- a column whose values must be unique in every row.

**Primary Key**

- Rules
  - must have a value.
  - value must be unique.
- Table can have 0 or 1 primary keys.
- A primary key is a field in a table which uniquely identifies each row/record in a database table. Primary keys must contain unique values. A primary key column cannot have NULL values.
- A table can have only one primary key, which may consist of single or multiple fields. When multiple fields are used as a primary key, they are called a **composite key**.
- If a table has a primary key defined on any field(s), then you cannot have two records having the same value of that field(s).

```sql
ALTER TABLE CUSTOMER ADD PRIMARY KEY (ID);
```

**Composite Key**

- two or more columns acting together as a primary key.
- a group of columns combined to uniquely identify a row.
- table can only have 0 or 1 composite key.

**Canidate Key**

- potential to become a primary key.

**Surrogate Key**

- unique numeric value added to serve as primary key.

**Non-Unique**

**Foreign Key**

- Makes a relational database, relational.
- a column or group of columns in one table that reference a column in another table. (usually primary key)
- A foreign key is a key used to link two tables together. This is sometimes also called as a **referencing key.**
- A Foreign Key is a column or a combination of columns whose values match a Primary Key in a different table.
- The relationship between 2 tables matches the Primary Key in one of the tables with a Foreign Key in the second table.

```sql
CREATE TABLE CUSTOMERS(
   ID   INT              NOT NULL,
   NAME VARCHAR (20)     NOT NULL,
   AGE  INT              NOT NULL,
   ADDRESS  CHAR (25) ,
   SALARY   DECIMAL (18, 2),
   PRIMARY KEY (ID)
);

CREATE TABLE ORDERS (
   ID          INT        NOT NULL,
   DATE        DATETIME,
   CUSTOMER_ID INT references CUSTOMERS(ID),
   AMOUNT     double,
   PRIMARY KEY (ID)
);

-- create foreign key
ALTER TABLE ORDERS
   ADD FOREIGN KEY (Customer_ID) REFERENCES CUSTOMERS (ID);
-- or
ALTER TABLE ORDERS
   ADD CONSTRAINT empPk PRIMARY KEY (ID)
```

**ON DELETE CASCADE**

- when you remove item from table, deletes relationship data in other tables
- CONSTRAINT empFk FOREIGN KEY(empId) REFERENCES Employee(empId) ON DELETE CASCADE,

**ON UPDATE CASCADE**

- when you update foreign key data, data in other relation tables are updated as well.
- CONSTRAINT skillFk FOREIGN KEY(skillId) REFERENCES Skills(skillId) ON UPDATE CASCADE,

Select

```sql
SELECT column1, column2, columnN FROM table_name;
SELECT \* FROM table_name;
```

Where (condition)

- appended to end of select statement.
- The SQL WHERE clause is used to specify a condition while fetching the data from a single table or by joining with multiple tables. If the given condition is satisfied, then only it returns a specific value from the table. You should use the WHERE clause to filter the records and fetching only the necessary records.
- The WHERE clause is not only used in the SELECT statement, but it is also used in the UPDATE, DELETE statement.

```sql
SELECT column1, column2, columnN
FROM table_name
WHERE [condition]

SELECT CUSTOMERS.AGE from CUSTOMERS where AGE > 20
```

Insert

- The SQL INSERT INTO Statement is used to add new rows of data to a table in the database.

```sql
INSERT INTO TABLE_NAME (column1, column2, column3,...columnN)
VALUES (value1, value2, value3,...valueN);

INSERT INTO CUSTOMERS (ID,NAME,AGE,ADDRESS,SALARY)
VALUES (1, 'Ramesh', 32, 'Ahmedabad', 2000.00 );
```
