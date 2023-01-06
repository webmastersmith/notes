# Excel Formulas

## HINTS

- `F4` locks cell reference to absolute
- `F9` shows the results

## ARRAY

- `CTRL + SHIFT + ENTER` // `=SUM(CELL:CELL*CELL:CELL)` // {=SUM(C4:C7\*D4:D7)}

## CLEANING DATA

- remove non-printable characters, remove spaces, normalize names from data.
- `=CLEAN(TRIM(PROPER(cell)))`

## CELL

- see REFERENCING

## CONCAT

- `=CONCAT(CELL, " ", CELL)` // join two cells with a space between.

## COUNT

- COUNT // only count cells with numeric content.
- COUNTA // count cells with any content
- COUNTIF(C4:C20, ">=80") // greater than or equal to 80. Cells must be numeric.
- **COUNTIFS** // `=COUNTIFS(A4:A22,G12,B4:B22,H12,C4:C22,I12)`
  - Multiple arguments.

## CHOOSE

- <https://support.microsoft.com/en-us/office/choose-function-fc5c184f-cb62-4ec7-a46e-38653b98f5bc>
- `CHOOSE(index_num, value1, [value2], ...)`
- `=CHOOSE(RANDBETWEEN(1,4),$D$4,$D$5,$D$6,$D$7)`

## DATA VALIDATION GROUP

- **DROP DOWN LIST**
  - Data / Data Tools / Data Validation
    - List

## DATE & TIME

- `=TODAY()` // dynamic. will change when day changes.
  - `=NOW()` // dynamic. time stamp.
- `CTRL + ;` // date -fixed
- `SHIFT + CTRL + ;` // time -fixed
- **WEEKDAY**
  - given date shows what day of week. // 1-7

## FILTER

- `=FILTER(B4:E23, (B4:B23=G4)*(D4:D23=G7), "No Record")`

## FIND

- `=FIND("@", CELL)` // returns number of characters from left of word.
- `=LEFT(CELL, FIND("-", CELL)-1)` // regex
- `=RIGHT(B4, LEN(B4)-FIND("@",B4))` // find from right side.

## IF

- `=IF(D6>$G$6,D6*$H$6, 0)`
- **IF,AND**
  - `=IF(AND(B5>$G$5,B5<$G$6, ...),"Yes","Review")`
- **IFS,AND** // nested if's
  - `=IFS(AND(B5>$G$5,B5<$G$6),"Good",B5>=$G$6,"Excellent", B5<$G$5,"Review", ...)`
- **IF,OR**
  - `=IF(OR(B5>=$G$6,B5<=$G$5), $G$9,$G$10)`

## INDEX

- <https://support.microsoft.com/en-us/office/index-function-a5dcf0dd-996d-40a4-a822-b56b061328bd>
- `INDEX(array, row_num, [column_num])`
- **TWO WAY INDEX MATCH**
  - `=INDEX(C43:E49, XMATCH(B40,B43:B49,0),XMATCH(C40,C42:E42,0))`
  - `=INDEX(B4:M11,MATCH($G$14,Company,0),MATCH($G$15,Month,0))`
- **Find Most occurrence's**
  - `=INDEX(A4:A23,MODE.SNGL(MATCH(A4:A23,A4:A23,0)))` // `CTRL + SHIFT + ENTER`

## MATH

- **SUMIF**
  - <https://support.microsoft.com/en-us/office/sumif-function-169b8c99-c05c-4483-a712-1697a653039b>
  - `SUMIF(range, criteria, [sum_range])`
  - `=SUMIF(A4:A22,"=Apr", D4:D22)`
- **SUMIFS**
  - `=SUMIFS(D4:D22,A4:A22,"=Apr",B4:B22,"=BMW")`

## MATCH

- <https://support.microsoft.com/en-us/office/match-function-e8dffd45-c762-47d6-bf89-533f4a37673a>
- `=MATCH(lookup_value, lookup_array, [match_type])`

## MOVE

- `CTRL + UP-ARROW` // jump to cell row 1
- `CTRL + UP-DOWN` // jump to cell last cell

## NAMING RANGE OF CELLS

- select entire row, including title / Formulas / Defined Names + Create from Selection / choose top row.
- for multiple at once naming
  - select entire rows/columns, including title / Defined Names + Create from Selection / choose top row.
  - now all title's will be the named rows.
  - all names will be in the upper left corner drop down box.
  - `=COUNT(NAME-OF-CELL)`
    - when you need to see what named ranges you have press `F3` // `=COUNT(F3-pick-name)`

## RAND

- `=RANDBETWEEN(0,100)` // random number 1-99
- `=RANDARRAY(ROWS, COLUMNS, MIN, MAX, WHOLE-NUMBERS)` // `=RANDARRAY(5,7,10,100,TRUE)`

## REFERENCING

- Absolute Referencing // one reference stays on one cell.
  - `F4` or `D2*$J$1` // $ sign locks reference, so when you drag, will always reference one cell.
  - `F4` or `D2*J$1` is 'mixed referencing'. // locks row not column.
  - `F4` or `D2*$j1` locks column not row.
- Relative Referencing // all cells move down by one.

## SEQUENCE

- <https://support.microsoft.com/en-us/office/sequence-function-57467a98-57e0-4817-9f14-2eb78519ca90>
- `=SEQUENCE(ROWS, COLUMNS, START-NUMBER, STEP)` // `=SEQUENCE(3,5,1,1)`

## SORT

- `=SORT(RANGE, COLUMN-NUMBER, ASCENDING/DESCENDING, COLUMN/ROW-SORT)` // `=SORT(B4:E23, 4, -1,FALSE)`
- COLUMN-NUMBER starts at 1 from left to right.
- COLUMN/ROW-SORT // default is FALSE. can leave off.
- **SORTBY**
  - `=SORTBY(RANGE, COLUMN-RANGE, ASCENDING/DESCENDING)` // `=SORTBY(B4:E23, E4:E23, -1)`

## SWITCH

- <https://support.microsoft.com/en-us/office/switch-function-47ab33c0-28ce-4530-8a45-d532ec4aa25e>
- switch statement
- `SWITCH(Value to switch, Value to match1...[2-126], Value to return if there's a match1...[2-126], Value to return if there's no match)`
- may be easier to use `IFS`.

## TEXT

- left // `=LEFT(CELL, NUMBER-OF-CHARS)`
- right // `=RIGHT(CELL, NUMBER-OF-CHARS)`
- mid // `=MID(CELL, START, NUMBER-OF-CHARS)` // returns text.
- search // `=SEARCH(",", CELL)` // returns number of spaces from the left.

## UNIQUE

- `=UNIQUE(RANGE)` // returns all unique values.
- **columns**
  - `=UNIQUE(RANGE, TRUE)`

## VLOOKUP

- can only look left-to-right when match is found.
- cannot look right-to-left.
- go to sheet with info / CTRL + a / type in upper left box your name `name bridge`.
- `=VLOOKUP(CELL, NAME-BRIDGE, COLUMN-NUMBER, FALSE)` // false=exact match.
- xLOOKUP goes both directions.
- Errors
  - `=IFNA(VLOOKUP(B8,Catalogue,2,FALSE), "Not Found")`

## XLOOKUP

- <https://support.microsoft.com/en-us/office/xlookup-function-b7fd680e-6d10-43e6-84f9-88eae8bf5929>
- `=XLOOKUP(lookup_value, lookup_array, return_array, [if_not_found], [match_mode], [search_mode])`
- `=XLOOKUP(A4, Employees[NAME],Employees[TEAM],"Not Found",0,1)`
- can look up right-to-left
- your lookup_value is the info thats common between tables.

## XMATCH

- `=XMATCH(F3,App)` // returns position in column.
