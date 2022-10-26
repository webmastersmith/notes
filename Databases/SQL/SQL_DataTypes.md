Data Types

- <https://www.guru99.com/sql-cheat-sheet.html>

Comment

- \-- //double dash

Data Types

Text Data Types

- VARCHAR(255) //VARCHAR -same as VARCHAR(255) A variable section from
  0 to 255 characters long.
- CHAR(255) A fixed section from 0 to 255 characters long.
- TINYTEXT A string with a maximum length of 255 characters.
- TEXT A string with a maximum length of 65535 characters.
- BLOB A string with a maximum length of 65535 characters.
- MEDIUMTEXT A string with a maximum length of 16777215 characters.
- MEDIUMBLOB A string with a maximum length of 16777215 characters.
- LONGTEXT A string with a maximum length of 4294967295 characters.
- LONGBLOB A string with a maximum length of 4294967295 characters.

Number types

- INTEGER //signed 32 bit whole number -2,147,483,648 to 2,147,483,647
- SMALLINT //signed 16 bit whole number
- NUMBER(n,d) //decimal numbers. NUMBER(5,2) can store number up to 3
  digits with 2 decimal places.
- NUMERIC //both integer and float
- FLOAT //holds floating point number without a limit on digits

Date / Time data types

- DATE YYYY-MM-DD
- DATETIME YYYY-MM-DD HH:MM:SS
- TIMESTAMP YYYYMMDDHHMMSS
- TIME HH:MM:SS

Null

- every data type can have a null value. mean "contains no data".
- NULL //means cell is empty and contains no data.
- NOT NULL //must have value, even if 0 or empty string.

Others

- CHECK //column value must meet specific condition. (min length, age
  above 0)
- ENUM To store text value chosen from a list of predefined text
  values.
- SET This is also used for storing text values chosen from a list of
  predefined text values. It can have multiple values.
- BOOL Synonym for TINYINT(1), used to store Boolean values
- BINARY Similar to CHAR, difference is texts are stored in binary
  format.
- VARBINARY Similar to VARCHAR, difference is texts are stored in
  binary format.

Contraints

- Table

  - default contraint is default value if a value is not given.
  -
