
all: 
	#./main.exe -o sum16bits.asm sum16bits.o
	clear
	nasm -f elf funcoes.asm -o funcoes.o 
	nasm -f elf simulador.asm -o simulador.o  
	gcc -Wall -Wextra -m32 trabalho2.c funcoes.o simulador.o -o trabalho2.exe 
	
run:
	#./trabalho2.exe sum16bits.o
	#./trabalho2.exe fatorial.obj

both: all run