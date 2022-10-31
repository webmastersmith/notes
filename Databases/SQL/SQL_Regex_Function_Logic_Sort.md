# SQL Regex, Functions, Logic, Comparisons

## Wildcards

- `%` // wildcard zero or more characters.
  - `Ro%` Rot, Roger, Rog would all match this query string
  - one or more chars.
- `_` // underscore. single char.
  - `SELECT column_name FROM table_name WHERE column_name LIKE '657-278-____'`

## Comparison Operators

- `age > 30` --greater than
- `>` // greater than
- `>=` // greater than equal to
- `<` // less than
- `<=` // less than equal to
- `=` // equal
- `!= | <>` // not equal -some DBMS use one or the other.

## Logic Operators

- `AND`
- `OR`
- `IN`
- `NOT`
- `BETWEEN`
- `LIKE` // used with wildcards.
- `HAVING` // use with GROUP BY

```sql
-- WHERE example
SELECT column_name FROM table_name WHERE column_name = 'value' AND column_name > 'value';

-- return a list of employee names in department 9 or salary greater than '100k'
SELECT emp_name FROM Employee WHERE deptId = 9 OR salary > '100k';

-- IN -return employee names that are in department 4, 6, and 9.
SELECT emp_name FROM Employee WHERE deptId IN (4, 6, 9);

-- NOT return employee names not in department 4, 6, and 9.
SELECT emp_name FROM Employee WHERE deptId NOT IN (4, 6, 9);

-- BETWEEN return employee names in department 4, 5 and 6.
-- same as return employee names in department >= 4, and <= 6.
SELECT emp_name FROM Employee WHERE deptId BETWEEN 4 AND 6;

-- LIKE return employee names starting with 'Ge'.
SELECT emp_name FROM Employee WHERE deptId LIKE 'Ge%';

-- HAVING return employee names and age with departmentId greater than or equal to 100.
SELECT emp_name, emp_age FROM Employee GROUP BY emp_age HAVING sum(deptId) >= 100;
```

## WHERE

- A `WHERE` clause is used to limit or filter the records affected by a command.
- Followed by a comparison statement that determines the conditions that need to be met in order for a record to be considered for the SQL command.
- A WHERE is always used in conjunction with another command.
- Update and delete must have a 'WHERE' condition.

```sql
SELECT * FROM albums
Where release_year = (SELECT min(release_year) FROM albums); -- finds min release_year, then compares.

-- field values with different names.
SELECT bands.name AS 'Band Name'
  FROM bands
  JOIN albums ON bands.id = albums.band_id
  GROUP BY albums.band_id
  HAVING COUNT(albums.id) > 0;
```

## AS

- alias name to reference column_name.
- aggregateFunction AS fn --returns it as a column_name.
- Join is usually faster than this type of query.
- Table
  - can add alias name after table name to give it an alias:

```sql
-- complex example
SELECT MIN(column_name) AS minimum_hours,
       MAX(column_name) AS maximum_hours,
       AVG(column_name) AS average_hours
FROM table_name
WHERE column_name > 7;

SELECT column_name1 AS 'c', column_name2 AS 'b' from table_name;
```

## DISTINCT

- remove duplicates from return.

```sql
SELECT DISTINCT column_name FROM table_name;
```

# SORT

**ORDER BY**

- sort data by column_name
- asc // default small to big (a-z, 0-9)
- desc // big to small (z-a, 9-0)

```sql
SELECT * FROM table_name ORDER BY column_name DESC;

SELECT column_name, aggregateFunction FROM table_name GROUP BY column_name ORDER BY aggregateFunction_results asc;

-- group all state populations and order.
SELECT state, sum(population) AS pop from cities GROUP BY state ORDER BY pop desc;

-- return name, year, duration of longest album.
SELECT a.name AS Name, a.release_year AS 'Release Year', sum(s.length) AS Duration FROM albums a
JOIN songs s ON s.album_id = a.id
GROUP BY a.name, a.release_year
ORDER BY Duration DESC LIMIT 1

```

# Functions

- [w3schools](https://www.w3schools.com/sql/sql_ref_sqlserver.asp)
- SUM()
- COUNT()
- MIN()
- MAX()
- AVG()

```sql
-- return number of records in the Employee table
SELECT COUNT(*) FROM Employee;

-- return min, max, avg of column_name, if other_column_name > 7
SELECT MIN(column_name) AS minimum_hours,
       MAX(column_name) AS maximum_hours,
       AVG(column_name) AS average_hours
FROM table_name
WHERE other_column_name > 7;
```

**Aggregate functions**

- process input and returns a scalar (single) value.
- PostgreSQL will create a result table and the aggregate function will name the column after itself unless you provide an alias. // `AS`
- `AVG(column_name)` FROM table_name; // return average value.
- `COUNT(*)` FROM table_name; // returns how many records in table.
  - `COUNT(column_name) FROM table_name;`
- `MIN/MAX(age) FROM customers;`
  - work with varchar (a-z) text as well.
  - `SELECT min(column_name) from table_name;` // returns lowest integer/char.
- `NOW()` // return date-time timestamp.
- `SUM(column_name) FROM table_name;` // integer returns sum.
  - `SELECT column, sum(column) AS pop FROM table_name GROUP BY column ORDER BY pop DESC;`
  - https://www.postgresqltutorial.com/postgresql-aggregate-functions/postgresql-sum-function/

**GROUP BY**

- Aggregate Function
  - groups data blocks to run: `MIN(), MAX(), COUNT(), SUM()...`
- container (group) data.

```sql
SELECT column1, column2, AggregateFunction FROM table_name GROUP BY column_name;
SELECT column1, column2, AggregateFunction FROM table_name;
-- See also: restricting results with HAVING.

-- GROUP BY
-- allows you to only process certain fields.
SELECT column_name, SUM(column_name) FROM table_name GROUP BY column_name;

-- return how many albums each band has.
SELECT b.name AS band_name, COUNT(*) AS count FROM albums a
JOIN bands b ON a.band_id = b.id
GROUP BY b.name

-- double join to filter info.
SELECT bands.name AS Band, SUM(z.total) FROM bands
JOIN (SELECT a.name AS album_name, a.band_id, COUNT(s.name) AS total FROM albums a
JOIN songs s
WHERE a.id = s.album_id
GROUP BY a.id) z ON bands.id = z.band_id
GROUP BY bands.name
```

**Custom Functions**

- custom aggregateFunction or procedure that you have to run everyday.

```sql
-- example custom function
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

-- to run
CALL procedure_name(params1, ...);
EXECUTE procedure_name(params1, ...);
```

**Subqueries**

- nested queries, inner query inform the outer
- subquery is just a query within a query. inner query is executed first.
- parenthesis is necessary to create the subquery.
- subquery always after comparison operator.
- If multiple matches, both records will be returned.
- IN // if the possibility of multiple matches
- `correlated subqueries` will run multiple times.
- `noncorrelated subqueries` will only run once.

```sql
-- Subqueries

SELECT *
FROM table_name
WHERE column_name IN -- can have a problem if two values match query. So use 'IN' in place of '='.
  (SELECT column_name
  FROM table_name
  WHERE column_name IN
   (SELECT MAX(column_name)
   FROM table_name
   )
  );

-- select lowest population from list of cities.
SELECT * FROM cities WHERE population = (SELECT MIN(population) FROM cities);

-- select lowest population and if two matches, select small id:
SELECT * FROM cities WHERE id IN
 (SELECT min(id) from cities WHERE population IN
  (SELECT min(population) from cities)
 );
```
