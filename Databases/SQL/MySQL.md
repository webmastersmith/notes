# MySQL

- [MariaDB](https://mariadb.org/)

## Stop Server Windows

- cmd prompt
  - `net stop MySQL80`

## Start Server Windows

- [cmd line](https://dev.mysql.com/doc/refman/8.0/en/windows-start-command-line.html)
  - `C:\> "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld" -p`
- windows service name: `MySQL80`
- cmd prompt
  - `net start MySQL80`

**Workbench Import csv**

1. create table
2. Run import cmd.

```sql
LOAD DATA INFILE 'c:/tmp/discounts.csv'
INTO TABLE discounts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

**Show folder where you can upload from**
SHOW VARIABLES LIKE "secure_file_priv";

**Auto Increment**

```sql
CREATE TABLE Customers (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255)
);
```

# Export to CSV

- may have to run this command to see where safe to copy file to.
  - `SHOW VARIABLES LIKE "secure_file_priv";`
- all lines are necessary or MySQL will error.

```sql
SELECT date,avgprice,totalvol,avo_a,avo_b,avo_c,typeid,regionid FROM price
INTO OUTFILE '/var/lib/mysql-files/price.csv'
FIELDS ENCLOSED BY ''
TERMINATED BY ','
ESCAPED BY '"'
LINES TERMINATED BY '\r\n';
```
