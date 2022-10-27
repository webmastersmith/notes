SQL Regex

- `%` // wildcard zero or more matches.
  - Rotterick, Roger, Rog would all match this query string
  - one or more chars.
- `_` // underscore. single char.
  - `SELECT column_name FROM table_name WHERE column_name LIKE '657-278-____'`
