; converte uma palavra de maisculo para minusculo

section .data

kangaroo db "KANGAROO",0xa,0xd
kangarooSize EQU $-kangaroo  

section .bss 

name resd 10  ; reserve 10*4 = 40 bytes 

section .text  

global _start
_start:

; imprime palavra em uppercase
mov eax, 4
mov ebx, 1
mov ecx, kangaroo 
mov edx, kangarooSize
int 0x80

; converte palavra de maisculo para minusculo
mov eax, kangaroo ; eax = endereco de kagaroo  
mov ebx, kangarooSize ; ebx = quantidade de letras
dec ebx
dec ebx

repeat:
   add byte [eax], 32  
   inc eax 
   dec ebx  
   jnz repeat 

; imprime a palavra em lowercase
mov eax, 4
mov ebx, 1
mov ecx, kangaroo
mov edx, kangarooSize
int 0x80



; sai do programa  
mov eax, 1 
mov ebx, 0
int 0x80
