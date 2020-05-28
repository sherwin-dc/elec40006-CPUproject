# Note
1. Any number that is meant to be the operand N needs to be prefixed with a "#" (ie. #5)
2. Jump points must end with a ":"
3. Jump points cannot start with a digit (ie. p0: is a valid jump point but 12: is not)
4. Fields in curly braces {} are optional

# Syntax
### STP
> STP
<br/>

### CALL
> CALL Rd Fn I

Rd: register to store return address<br/>
Fn: jump point of function to call<br/>
I: offset to shift register window by<br/>

### RTN
> RTN Rd I

Rd: Register of return address<br/>
I: offset to shift register window by<br/>

### LSL
> LSL Rd Rs

Rd: Destination Register<br/>
Rs: Source Register<br/>

### LSR
> LSR Rd Rs {A}

Rd: Destination Register<br/>
Rs: Source Register<br/>
A (optional): Type of shift to perform
- L: Logical (default)
- A: Arithmetic

### CMP
> CMP Rd Rs COND SKIPLEN<br/>
CMP Rd #N COND SKIPLEN

Rd: Register 1 to compare<br/>
Rs: Register 2 to compare (specify only if not using operand)<br/>
N: operand to compare Rd to (specify only if not using Rs)<br/>
SKIPLEN: number of addresses in instruction to skip<br/>
COND: compare condition
- EQ: equal - Rd == Rs or Rd == N
- NQ: not equal - Rd != Rs or Rd != N
- GR: greater than - Rd > Rs or Rd > N
- LS: less than - Rd < Rs or Rd < N
- EZ: equal to zero - Rd == 0
- MI - 2s-complement negative - Rd < 0 (2s-complement)

### JMP
> JMP Rd<br/>
JMP addr

Rd: register containing the address to jump to<br/>
addr: jump point to jump to<br/>

### ADD
> ADD Rd Rs Rm<br/>
ADD Rd Rs #N

Rd: destination register<br/>
Rs: source register 1<br/>
Rm: source register 2 (specify only if operand is not used)<br/>
N: operand (specify only if not using Rm)<br/>

### SUB
> SUB Rd Rs Rm {EZ} {SL}<br/>
SUB Rd Rs #N {EZ} {SL}

Rd: destination register<br/>
Rs: source register 1<br/>
Rm: source register 2 (specify only if operand is not used)<br/>
N: operand (specify only if not using Rm)<br/>
EZ (optional): perform a compare if Rd ==0 afterwards and skip the next instruction
- N: don't perform compare and jump (default)
- J: perform compare and Jump

SL: (optional): number of additionaladdresses used by next instruction if performing jump
- 0: for Type-R instructions (default)
- 1: for Type-I instructions<br/>

### MAS
> MAS Rd Rs Rm<br/>
MAS Rs Rs #N {P}

Rd: destination register<br/>
Rs: source register 1<br/>
Rm: source register 2 (specify only if operand is not used)<br/>
N: operand (specify only if not using Rm)<br/>
P: position of operand (in product or sum)
- S: N in sum (default)
- P: N in product<br/>

### MOV
>MOV Rd Rs<br/>
MOV Rd #N

Rd: destination register<br/>
Rs: source register (specify only if not using operand)<br/>
N: operand (specify only if not using Rs)<br/>

### SET
> SET Rd{+/-#N} Rs{+/-#N} {M}

Rd: access address of PORTA<br/>
Rs: access address of PORTB<br/>
N (optional): addtional address offset (must be the same for Rd and Rs)<br/>
M (optional): which RAM to access
- D: data RAM (default)
- I: instruction RAM

### PLD
> PLD Rd Rs {M}

Rd: destination register for PORTA<br/>
Rs: destination register for PORTB<br/>
M (optional): which RAM to access
- D: data RAM (default)
- I: instruction RAM

### PST
> PST Rd Rs {M}

Rd: source register for PORTA<br/>
Rs: source register for PORTB<br/>
M (optional): which RAM to access
- D: data RAM (default)
- I: instruction RAM

### NOP
> NOP
<br/>

### ORG (RAM initialization)
> ORG addr

addr: address to select (must be in DEC)<br/>

### DCW (RAM initialization)
> DCW dat

dat: data to load into RAM (must be in DEC)<br/>
note: DCW automatically increments the memory address<br/>
