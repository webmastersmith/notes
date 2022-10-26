# SQL Normalization

**Normalization**

- means to design database in such a way that you have:

  - no composite columns.
  - little to no redundant data.
  - relationships make sense.

- 6 or 7 stages to normalization

  - if you reach the 3<sup>rd</sup> stage (Third Normal Form) your
    database is acceptable.

- before you normalize a database, you should know what the expectations
  are.

**Cons**

- normalizing data may make search parameters take longer to search two
  tables than just one.

## First Normal Form

1.  get rid of composite columns.

- - **composite column** -holds multiple data values. (phone number:
    123-456-7890, 345-567-8901)

    - prevents searching matches.

|            |            |           |              |
| ---------- | ---------- | --------- | ------------ |
| customerId | first_name | last_name | phone        |
| 1          | John       | Smith     | 143-456-7890 |
| 2          | Diane      | Smith     | 345-567-8901 |
| 2          | Diane      | Smith     | 123-456-7890 |
| 3          | David      | Davidson  | 555-333-4444 |

- can make customerId and phone primary the primary. now no composite
  columns.

1.  have primary key.

## Second Normal Form

- must first achieve first normal form.

- columns causing data duplication must be moved to seperate tables and
  relate with foreign key.

  - instead of duplicate data with customerId 2, create a seperate table
    of phone numbers.

Customer_Phones

| ---------- | ------------ |
| customerId | phone |
| 1 | 143-456-7890 |
| 2 | 345-567-8901 |
| 2 | 123-456-7890 |
| 3 | 555-333-4444 |

Customers

| ---------- | ---------- | --------- |
| customerId | first_name | last_name |
| 1 | John | Smith |
| 2 | Diane | Smith |
| 3 | David | Davidson |

## Third Normal Form

- you promise every column will describe the key, the whole key, nothing
  but the key.

- a table should not track any information that does not describe all of
  the columns that make up the primary or composite key.

- information not truly related to table, should be in another table.

- remove transitive dependencies.

  - ?

## Relationships

**one-to-many** //most common

- one-to-many (1:n) //once customer can have many phone numbers.
- almost always have a foreign key that is a column on the 'many' table.

**one-to-one** //not often used

- single row in one table refers to a single row in another table.
- most cases you would just combine the tables.

**many-to-many**

- is a new table in the middle of the both tables that is comprised of
  (id's) only.
