# Unoptimal

A language that is meant to be hard to optimise.

The language features 3 main circular arrays of integers which I call
loops as well as a data loop. The main loops are 7, 37, and 97 cells
long. The data loop is of length 2^n where n can be set dynamically.

The loop lengths were chosen to make it hard to operate on specific
data without waiting excedingly long. To make this more pronounced
functions can only be 15, 40, or 60 commands long.

## Commands

Every command increments the pointer to each of the loops, with the
exception of function calls. Function calls also do not count towards
the number of commands within a function definition.

The main loops are referred to as the `X`, `Y`, and `Z` loops, where
`X` is the shortest and `Z` is the longest. `D` refers to the data
loop. In the command table `n` refers to a literal integer in base 10
(ten), `l` refers to any of the loop names, and `e` refers to either.

### Main commands

| Command | Arguments              | Description                                                   |
| ------- | ---------------------- | ------------------------------------------------------------- |
| `add`   | 1: `l`, 2: `e`, 3: `e` | Puts [2] + [3] into [1]                                       |
| `sub`   | 1: `l`, 2: `e`, 3: `e` | Puts [2] - [3] into [1]                                       |
| `mul`   | 1: `l`, 2: `e`, 3: `e` | Puts [2] * [3] into [1]                                       |
| `div`   | 1: `l`, 2: `e`, 3: `e` | Puts [2] / [3] into [1]                                       |
| `and`   | 1: `l`, 2: `e`, 3: `e` | Puts [2] & [3] into [1]                                       |
| `or`    | 1: `l`, 2: `e`, 3: `e` | Puts [2] | [3] into [1]                                       |
| `xor`   | 1: `l`, 2: `e`, 3: `e` | Puts [2] ^ [3] into [1]                                       |
| `not`   | 1: `l`, 2: `e`         | Puts ~[2] into [1]                                            |
| `mov`   | 1: `l`, 2: `e`         | Puts [2] into [1]                                             |
| `set`   | 1: `e`                 | Set `D`'s length to 2^[1]                                     |
| `in`    | 1: `l`                 | Reads a byte from stdin and puts it into [1]                  |
| `out`   | 1: `e`                 | Writes the byte [1] % 256 to stdout                           |
| `nop`   |                        | Does nothing                                                  |

#### Set

If the `set` command recieves a value less than the current length of
the `D` loop it will remove elements as it would have read them until
the loop is the correct length.

If it recieves a value greater it will add zeros at the current
position until it has reached the correct length such that the next
value read will be the same as if the set command was a no-op.

### Control Flow

### If/Else

The `if` command counts. `else` does not. Allows `=`, `<`, `<=`, `>`, `>=`.

### Function Calls

As stated above functions can only have 15, 40, or 60 commands. Function
calls don't count towards this total. 

Function definitions are of the form `def name ... end` where name is
the name of the function. 

### Repeat

The `repeat` command counts for one.


## Example programs

None yet!
