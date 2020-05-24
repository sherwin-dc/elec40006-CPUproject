start:
MOV R1 #3
MOV R5 R1
ADD R0 R1 R2  //this is a comment
ADD R0 r1 #3

SUB r1 r4 r5
SUB R1 R4 #523 J 1

MAS R0 R1 R2
MAS R0 R1 #11 P

p0:

SET R0 [R1-#2] i
lol:

PLD x R4

CALL R1 100 2
CALL R1 hihi 2

RTN R1 3

LSL R1 R2
LSR r1 R2

CMP R0 r1 eq 0
JMP start
CMP R0 #18 gr 1

JMP R5

hihi:
SET [R0+#8] R2
PLD x R1 D
PST R0 R1 i

JMP p0
JMP lol

STP

ORG 1000
DCW 242
DCW 117
