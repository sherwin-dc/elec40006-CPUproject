MOV R2 #10
SET R2 R2+#1
PLD R0 R2
p0: 
MOV R3 R2
SET R2 R2+#1
PLD R1 R2
CMP R0 R1 EQ 2
CMP R2 R0 NP 2
JMP p0
MOV R0 R3
STP