# Logic Operators

### 7 Falsey Values

- [MDN](https://developer.mozilla.org/en-US/docs/Glossary/Falsy)
- values that when cast into a boolean, will be false.
- **false** // `typeof 'boolean'`
- **0 | -0 | 0n** // `typeof 'number'` // 0n bigint
- **NaN** // `typeof 'number'`
- **"" | '' | \`\`** // `typeof 'string'`
- **null** // `typeof 'object'`
- **undefined** // `typeof 'undefined'`
  - variable declared but not assigned value
  - property that does not exist on object // let myProp = {}
  - function returns without a value
  - calling a function(param) without it's argument.
- **Examples**
  - all true
  - negative integers
  - empty `{}`
  - empty `[]`
  - empty ' ' // string with space.

### Expressions and Logical Operators // answer in true or false.

- [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators)
- Comparison Operators
  - `>` greater than
  - `<` less than
  - `===` equal to without type coercion.
  - `==` equal with type coercion.

### Boolean Conversion

**!!**

- <https://medium.com/better-programming/javascript-bang-bang-i-shot-you-down-use-of-double-bangs-in-javascript-7c9d94446054>
- the double-bang explicitly caste element into boolean true/false.

**||**

- if left operand is **truthy**, return left operand.
- if left operand is **falsey**, return right operand.
  - `??` different from the `Nullish Coalescing Operator`. It will only return right side operand if left is `null` or `undefined`.
- a ? a : b

**&&**

- if left operand is **truthy**, return right operand.
- if left operand is **falsey**, return left operand.
- a ? b : a

**[?.](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators#optional_chaining_operator)** // optional chaining operator

- `obj?.prop or obj?.['prop']` // returns value if exist, otherwise returns undefined.
- `arr?.[0]`
- `myFunction?.()` // safely call functions only if the exist.
- short-circuits by stopping lookup when key doesn't exist.

**??**

- [`Nullish Coalescing Operator`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing)
- returns right operand when return is `null` or `undefined`.

**Higher the value, greater precedence.**

- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Operator_Precedence>

|            |                                                                                                                                                          |               |                      |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | -------------------- |
| Precedence | Operator type                                                                                                                                            | Associativity | Individual operators |
| 20         | [Grouping](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Grouping)                                                         | n/a           | ( … )                |
| 19         | [Member Access](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Property_Accessors#Dot_notation)                             | left-to-right | … . …                |
|            | [Computed Member Access](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Property_Accessors#Bracket_notation)                | left-to-right | … \[ … \]            |
|            | [new](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new) (with argument list)                                              | n/a           | new … ( … )          |
|            | [Function Call](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions)                                                                 | left-to-right | … ( … )              |
|            | [Optional chaining](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining)                                       | left-to-right | ?.                   |
| 18         | [new](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new) (without argument list)                                           | right-to-left | new …                |
| 17         | [Postfix Increment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Increment)                          | n/a           | … ++                 |
|            | [Postfix Decrement](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Decrement)                          |               | … --                 |
| 16         | [Logical NOT](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_Operators#Logical_NOT)                                 | right-to-left | ! …                  |
|            | [Bitwise NOT](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators#Bitwise_NOT)                                 |               | \~ …                 |
|            | [Unary Plus](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Unary_plus)                                |               | \+ …                 |
|            | [Unary Negation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Unary_negation)                        |               | \- …                 |
|            | [Prefix Increment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Increment)                           |               | ++ …                 |
|            | [Prefix Decrement](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Decrement)                           |               | -- …                 |
|            | [typeof](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/typeof)                                                             |               | typeof …             |
|            | [void](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/void)                                                                 |               | void …               |
|            | [delete](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/delete)                                                             |               | delete …             |
|            | [await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await)                                                               |               | await …              |
| 15         | [Exponentiation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Exponentiation)                        | right-to-left | … \*\* …             |
| 14         | [Multiplication](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Multiplication)                        | left-to-right | … \* …               |
|            | [Division](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Division)                                    |               | … / …                |
|            | [Remainder](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Remainder)                                  |               | … % …                |
| 13         | [Addition](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Addition)                                    | left-to-right | … + …                |
|            | [Subtraction](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Subtraction)                              |               | … - …                |
| 12         | [Bitwise Left Shift](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators)                                      | left-to-right | … \<\< …             |
|            | [Bitwise Right Shift](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators)                                     |               | … \>\> …             |
|            | [Bitwise Unsigned Right Shift](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators)                            |               | … \>\>\> …           |
| 11         | [Less Than](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Less_than_operator)                         | left-to-right | … \< …               |
|            | [Less Than Or Equal](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Less_than__or_equal_operator)      |               | … \<= …              |
|            | [Greater Than](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Greater_than_operator)                   |               | … \> …               |
|            | [Greater Than Or Equal](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Greater_than_or_equal_operator) |               | … \>= …              |
|            | [in](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/in)                                                                     |               | … in …               |
|            | [instanceof](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/instanceof)                                                     |               | … instanceof …       |
| 10         | [Equality](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Equality)                                    | left-to-right | … == …               |
|            | [Inequality](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Inequality)                                |               | … != …               |
|            | [Strict Equality](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Identity)                             |               | … === …              |
|            | [Strict Inequality](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Nonidentity)                        |               | … !== …              |
| 9          | [Bitwise AND](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators#Bitwise_AND)                                 | left-to-right | … & …                |
| 8          | [Bitwise XOR](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators#Bitwise_XOR)                                 | left-to-right | … ^ …                |
| 7          | [Bitwise OR](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators#Bitwise_OR)                                   | left-to-right | … \| …               |
| 6          | [Logical AND](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_Operators#Logical_AND)                                 | left-to-right | … && …               |
| 5          | [Logical OR](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_Operators#Logical_OR)                                   | left-to-right | … \|\| …             |
| 4          | [Conditional](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Conditional_Operator)                                          | right-to-left | … ? … : …            |
| 3          | [Assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Assignment_Operators)                                           | right-to-left | … = …                |
|            |                                                                                                                                                          |               | … += …               |
|            |                                                                                                                                                          |               | … -= …               |
|            |                                                                                                                                                          |               | … \*\*= …            |
|            |                                                                                                                                                          |               | … \*= …              |
|            |                                                                                                                                                          |               | … /= …               |
|            |                                                                                                                                                          |               | … %= …               |
|            |                                                                                                                                                          |               | … \<\<= …            |
|            |                                                                                                                                                          |               | … \>\>= …            |
|            |                                                                                                                                                          |               | … \>\>\>= …          |
|            |                                                                                                                                                          |               | … &= …               |
|            |                                                                                                                                                          |               | … ^= …               |
|            |                                                                                                                                                          |               | … \|= …              |
| 2          | [yield](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield)                                                               | right-to-left | yield …              |
|            | [yield\*](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield*)                                                            |               | yield\* …            |
| 1          | [Comma / Sequence](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comma_Operator)                                           | left-to-right | … , …                |

Comma Operator

- will only return last value. let i = \[5, 4\] //i = 4.
- let i = 1; (i++, i) // returns 2 because i++ executes and then i is returned.
  - must use parentheses.
- **ternary** (score) ? (score = 1, person = 4) : (score = 0, person = 5) // changes two variables.
