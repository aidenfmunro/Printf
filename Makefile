all: asm bld lnk run

asm:
		@nasm -f elf64 myprintf_asm.s -o myprintf_asm.o

bld:
		@gcc -c myprintf_c.c -o myprintf_c.o

lnk:
		@gcc -no-pie myprintf_asm.o myprintf_c.o -o main

run:
		@./main
