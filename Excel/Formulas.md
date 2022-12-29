# Excel Formulas

## CLEANING DATA

- remove non-printable characters, remove spaces, normalize names from data.
- `=CLEAN(TRIM(PROPER(cell)))`

## CONCAT

- `=CONCAT(CELL, " ", CELL)` // join two cells with a space between.

## COUNT

- COUNT // only count cells with numeric content.
- COUNTA // count cells with any content
- COUNTIF(C4:C20, ">=80") // greater than or equal to 80. Cells must be numeric.

## DATE & TIME

- `=TODAY()` // dynamic. will change when day changes.
  - `=NOW()` // dynamic. time stamp.
- `SHIFT + ;` // date -fixed
- `SHIFT + CTRL + ;` // time -fixed

## FIND

- `=FIND("@", CELL)` // returns number of characters from left of word.
- `=LEFT(CELL, FIND("-", CELL)-1)` // regex

## vLOOKUP & xLOOKUP

- can only look left-to-right when match is found.
- cannot look right-to-left.
- go to sheet with info / CTRL + a / type in upper left box your name `name bridge`.
- `=VLOOKUP(CELL, NAME-BRIDGE, COLUMN-NUMBER, FALSE)` // false -exact match.
- xLOOKUP goes both directions.
- Errors
  - `=IFNA(VLOOKUP(B8,Catalogue,2,FALSE), "Not Found")`

## MOVE

- `CTRL + UP-ARROW` // jump to cell row 1
- `CTRL + UP-DOWN` // jump to cell last cell

## NAMING RANGE OF CELLS

- select entire row, including title / Defined Names + Create from Selection / choose top row.
- for multiple at once naming
  - select entire rows/columns, including title / Defined Names + Create from Selection / choose top row.
  - now all title's will be the named rows.
  - all names will be in the upper left corner drop down box.
  - `=COUNT(NAME-OF-CELL)`
    - when you need to see what named ranges you have press `F3` // `=COUNT(F3-pick-name)`

## REFERENCING

- Absolute Referencing // one reference stays on one cell.
  - `F4` or `D2*$J$1` // $ sign locks reference, so when you drag, will always reference one cell.
  - `F4` or `D2*J$1` is 'mixed referencing'. // locks row not column.
  - `F4` or `D2*$j1` locks column not row.
- Relative Referencing // all cells move down by one.

## TEXT

- left // `=LEFT(CELL, NUMBER-OF-CHARS)`
- right // `=RIGHT(CELL, NUMBER-OF-CHARS)`
- mid // `=MID(CELL, START, NUMBER-OF-CHARS)` // returns text.
- search // `=SEARCH(",", CELL)` // returns number of spaces from the left.

## UNIQUE

- `=UNIQUE(CELLS)` // returns all unique values.
