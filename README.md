# Unoptimal

A language that is meant to be hard to optimise.

## Architecture

Unoptimal features 3 main circular arrays of integers which referred
to as loops as well as a data loop. The main loops are 7, 37, and 97
cells long. The data loop is of length 2^n where n can be set
dynamically.

The main loops are referred to as the `X`, `Y`, and `Z` loops, where
`X` is the shortest and `Z` is the longest. `D` refers to the data
loop.

The loop lengths were chosen to make it hard to operate on specific
data without waiting excedingly long. To make this more pronounced
functions can only be 15, 40, or 60 commands long. 

## Commands

Every command increments the pointer to each of the loops, with the
exception of function calls. Therefore, they do not count towards the
number of commands within a function definition.

### Main commands

The `dest` argument must be one of the loop names, in either upper or
lowercase. Other arguments can be a loop name or a literal integer in
base 10 (ten).

| Command                          | Description                                                   |
| -------------------------------- | ------------------------------------------------------------- |
| `add dest a b`                   | `dest = a + b`                                                |
| `sub dest a b`                   | `dest = a - b`                                                |
| `mul dest a b`                   | `dest = a * b`                                                |
| `div dest a b`                   | `dest = a / b`                                                |
| `and dest a b`                   | `dest = a & b`                                                |
| `xor dest a b`                   | `dest = a ^ b`                                                |
| `or dest a b`                    | `dest = a | b`                                                |
| `not dest a`                     | `dest = ~a`                                                   |
| `mov dest a`                     | `dest = a`                                                    |
| `set n`                          | Set `D`'s length to `2**a`                                    |
| `in dest`                        | Reads a byte from stdin and puts it into `dest`               |
| `out dest`                       | Write the byte `dest % 256` to stdout                         |
| `nop`                            | Does nothing                                                  |

#### Set

If the `set` command recieves a value less than the current length of
the `D` loop it will remove elements as it would have read them until
the loop is the correct length.

TODO: Example

If it recieves a value greater it will add zeros at the current
position until it has reached the correct length such that the next
value read will be the same as if the set command was a no-op.

TODO: Example

### Control Flow

#### If/Else

`if a op b ... (else ...) end`

The `op` argument refers to any of these string literals: `==`, `!=`,
`<`, `<=`, `>`, `>=`. If the command runs the functions listed in the
first `...` if the comparison evaluates to true, otherwise if there is
an else block it will run those functions.

#### Function Calls

As stated above functions can only have 15, 40, or 60 commands. Function
calls don't count towards this total. 

Function definitions are of the form `def name ... end` where name is
the name of the function and `...` can be any commands or functions.

### Repeat

`repeat a ... end`

The `repeat` command runs the functions in `...` `a` times.

## Example programs

None yet!
