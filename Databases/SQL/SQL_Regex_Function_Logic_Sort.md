# SQL Regex, Functions, Logic, Comparisons

## Wildcards

- `%` // wildcard zero or more matches.
  - Rotterick, Roger, Rog would all match this query string
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
- `<>` or `!=` // not equal -some DBMS use one or the other.

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
```

## Sort

**GROUP BY**

- container (group) data.

```sql
SELECT column1, column2, AggregateFunction FROM table_name GROUP BY column_name;
```

**ORDER BY**

- sort data by column_name
- asc //default small to big (a-z, 0-9)
- desc //big to small (z-a, 9-0)

```sql
SELECT column_name, aggregateFunction FROM table_name GROUP BY column_name ORDER BY aggregateFunction_results asc;


-- group all state populations and order.
SELECT state, sum(population) AS pop from cities GROUP BY state ORDER BY pop desc;
```

## Functions

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
- PostgreSQL will create a result table and the aggregate function will name the column after itself unless you provide an alias. //AS
- AVG(column_name) FROM table_name; //return average value.
- COUNT(\*) FROM table_name; //returns how many records table has.
  - COUNT(column_name) FROM table_name; //counts repeats in column name.
- FIRST/LAST FROM table_name; --first row of table or last row of table.
- MIN/MAX(age) FROM customers;
  - work with varchar (a-z) text as well.
  - SELECT min(column_name) from table_name; //returns lowest integer/char.
- NOW() //return date-time timestamp.
- SUM(column_name) FROM table_name; //integer returns sum.
  - SELECT column, sum(column) AS pop from table_name group by column order by pop desc;
  - https://www.postgresqltutorial.com/postgresql-aggregate-functions/postgresql-sum-function/

```sql
SELECT column1, column2, AggregateFunction FROM table_name;
SELECT column_name, AggregateFunction FROM table_name; --must have comma!

-- See also: restricting results with HAVING.

-- GROUP BY
-- allows you to only process certain fields.
SELECT column_name, SUM(column_name) FROM table_name GROUP BY column_name;

-- WHERE
SELECT _ FROM table_name WHERE column_name > 25;
SELECT _ FROM table_name WHERE column_name LIKE "R%"; --any name starts with an 'R'.

-- LOGIC
AND, OR, NOT
LIKE "S%"; --wildcard
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
- IN //if the possibility of multiple matches

```sql
-- Subqueries

SELECT *
FROM table_name
WHERE column_name = ( -- can have a problem if two values match query. So use 'IN' in place of '='.
SELECT column_name
FROM table_name
WHERE column_name = (
SELECT MAX(column_name)
FROM table_name
)
);

-- select lowest population from list of cities.
select * from cities where population = (select min(population) from cities);

-- select lowest population and if two matches, select small id:
select * from cities where id = (select min(id) from cities where population = (select min(population) from cities));
```
