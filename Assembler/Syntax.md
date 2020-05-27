# Note
1. Any number that is meant to be the operand needs to be prefixed with a "#" (ie. #5)
2. Jump points must end with a ":"
3. Jump points cannot start with a digit (ie. p0: is avalid jump point but 12: is not)

# Syntax
### STP
STP

### CALL
CALL Rd Fn I

Rd: register to store return address
Fn: jump point of function to call
I: offset to shift register window by

### RTN
RTN Rd I

Rd: Register of return address
I: offset to shift register window by
