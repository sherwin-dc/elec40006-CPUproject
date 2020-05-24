# Setup
The assembler has been compiled for windows 10 as candybar
1. Add the directory of candybar (this folder's directory) to system PATH (under environment variables)

# Usage
The assembler will take in an assembly file and generate a MIF file. It can be used to assemble the RAM contents for both the Instruction and Data RAMs

> candybar assembly.s

MIF file output will be assembly.mif

optional -o argument to specify the name of the output file

> candybar assembly.s -o myfile.mif
