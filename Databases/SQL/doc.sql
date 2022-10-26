CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT,
  age INTEGER,
  weight REAL
);

-- Using primary keys
CREATE TABLE Customers (
  customerId INTEGER PRIMARY KEY,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  age INTEGER CHECK(age > 18)
) -- another way
CREATE TABLE Customers (
  empId Interger NOT NULL,
  skillId Interger NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  age INTEGER CHECK(age > 18),
  CONSTRAINT empPK PRIMARY KEY(empId, skillId) / / each value in the empId must be unique.
  or CONSTRAINT empPK PRIMARY KEY(empId, skillId) / / Composite key.
) -- Foreign Key
CREATE TABLE Customer_Phones (
  customerId INTEGER,
  REFERENCES Customers(customerId),
  --foreign key to customers
  phone VARCHAR NOT NULL,
  PRIMARY KEY(customerId, phone)
) -- another way
CREATE TABLE Customers (
  empId Interger NOT NULL,
  skillId Interger NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  age INTEGER CHECK(age > 18),
  CONSTRAINT empPk PRIMARY KEY(empId, skillId),
  / / Composite key.CONSTRAINT empFk FOREIGN KEY(empId) REFERENCES Employee(empId),
  CONSTRAINT skillFk FOREIGN KEY(skillId) REFERENCES Skills(skillId),
) -- ON DELETE CASCADE
CONSTRAINT empFk FOREIGN KEY(empId) REFERENCES Employee(empId) ON DELETE CASCADE,
-- ON UPDATE CASCADE
CONSTRAINT skillFk FOREIGN KEY(skillId) REFERENCES Skills(skillId) ON UPDATE CASCADE,