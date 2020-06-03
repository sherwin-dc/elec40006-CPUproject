    MOV R0 #5  // R0 = n
    MOV R1 H  // R1 = H
A:  CMP R0 #1 GR 3  // Skip to SUB instr if R0 (n) > 1
    MOV R0 #1  // R0 = 1
    RTN R1 3  //TODO PC = R1 (E or F), Move window up by 3
    SUB R3 R0 #2  // R3 = n - 2
    CALL R4 A 3  //TODO R4 = PC + 1 (E), Jump to address A, Move window down by 3
E:  MOV R2 R3  // R2 = fib(n-2)
    SUB R3 R0 #1  // R3 = n - 1
    CALL R4 A 3  //TODO R4 = PC + 1 (F), Jump to address A, Move window down by 3
F:  ADD R0 R2 R3  // R0 = fib(n-2) + fib(n-1)
    RTN R1 3  //TODO PC = R1 (E or F), Move window up by 3
H:  STP  // Stop

