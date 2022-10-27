# Join

- Joins can be faster than SELECT statements working across multiple tables.
- combines information from an operation of two tables. Returns a grid of columns
- The SQL Joins clause is used to combine records from two or more tables in a database. A JOIN is a means for combining fields from two tables by using values common to each.
- joining two tables requires that they have some data in common, like sharing a column.
- Foreign keys are easy to spot an easy way to join on.
- you can join on any column, but when columns match it's easier.

<img src="../images/joins.png" alt="sql table joins">

**Join**

```sql
-- only return records for empNam and deptName where employee.departmentId matches department.departmentId
SELECT empName, deptName
FROM Employee AS E Department AS D
WHERE E.deptId = D.deptId
```

**Outer Join**

- rows that do not have a match.

```sql
SELECT *
FROM Customers c
LEFT JOIN Order_History o -- Order_History AS o
ON c.id = o.id
WHERE o.id = NULL; -- everything that does not match o.id.
```

**Left Outer Join**

- return left table and results from right table.

```sql
-- return all empName column and only matching deptName.
SELECT empName, deptName
FROM Employee E LEFT OUTER JOIN Department D
     ON E.deptID = D.deptId
```

**Right Outer Join** // opposite of left join.

- return full right table with results from left.

**Full Outer Join**

- return all records from both tables.

**Inner Join**

- most common.
- only return records from both tables that match a condition.

```sql
-- Inner join
SELECT customers.name, orders.item FROM customers LEFT OUTER JOIN orders ON customers.id =

-- orders.customer_id;
SELECT customers.name, orders.item FROM customers JOIN orders ON customers.id = orders.customer_id;
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
