section .data

exiting db 0xa, 0xd,"exiting...", 0xa, 0xd
sizeExiting equ $-exiting

rows equ 10
cols equ 50
sizeMatrix equ rows * cols

section .bss 

aux resb 1000
size resb 1
vetor resd 10

section .text

global _start 
_start:


mov eax, 3
mov ebx, 0
mov ecx, aux  
mov edx, 80
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, aux 
mov edx, 80
int 0x80




mov esi, 0

mov edi, 0 
for:
   mov eax, edi 
   add eax, 0x30
   mov dword [vetor+esi*4], 0x39


   inc edi
   inc esi 
   cmp esi,10
   jne for

 

mov eax, 4
mov ebx, 1
mov ecx, vetor
mov edx, 40
int 0x80


; finish the program
mov eax, 4
mov ebx, 1
mov ecx, exiting
mov edx, sizeExiting
int 0x80

mov eax, 1
mov ebx, 0
int 0x80







