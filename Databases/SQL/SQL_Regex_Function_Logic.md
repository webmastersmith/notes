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
-- sme as return employee names in department >= 4, and <= 6.
SELECT emp_name FROM Employee WHERE deptId BETWEEN 4 AND 6;
-- LIKE return employee names starting with 'Ge'.
SELECT emp_name FROM Employee WHERE deptId LIKE 'Ge%';
```

## AS

- alias name to reference column_name.
- aggregateFunction AS fn --returns it as a column_name.
- Join is usually faster than this type of query.
- Table
  - can add alias name after table name to give it an alias:

```sql
-- simple example
SELECT customer_id FROM Customers;

-- complex example
SELECT c.id,
c.lastname,
o.id,
o.order_cost
FROM Customers c,
OrderHistory o
WHERE c.id = o.id;
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
