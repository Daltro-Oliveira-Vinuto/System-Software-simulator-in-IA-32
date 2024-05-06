; calculate fibonacci using a function that can be called from C program. 

extern fibonacci

%macro print 2  

pusha 

mov eax, 4
mov ebx, 1
mov ecx, %1 ; pointer to output buffer of a ascii value +0x30
mov edx, %2 ; number of bytes to print
int 0x80

popa 

%endmacro

%macro read 2 

pusha

mov eax, 3  
mov ebx, 0 
mov ecx, %1 ; pointer to input buffer, read a ascii value -0x30
mov edx, %2
int 0x80

popa

%endmacro

%macro kernel 4  

pusha

mov eax, %1
mov ebx, %2
mov ecx, %3
mov edx, %4
int 0x80

popa

%endmacro

section .data  

newLine db 0xa, 0xd
newLineSize equ $-newLine  

space db "  "
spaceSize equ $-space  

enterN db "Enter n: "
enterNSize equ $-enterN

section .bss

n resd 1
fib resd 1
aux resd 1

section .text

global _start
_start:


; ask the value o N  

print enterN, enterNSize  

; read the value of n, save the ascii in aux and the value in n  

read aux, 1
mov eax, dword [aux]
sub eax, 0x30
mov dword [n], eax

; convert from ascii to binary  

; print readed n after convert to ascii
mov eax, dword [n]
add eax, 0x30
mov dword [aux], eax  
print aux, 1
print newLine, newLineSize  


; call function fibonacci  

push dword [n]
call fibonacci  ; <----------------------- function 
add esp, 4     ; restore the stack

; save the value  
mov dword [fib], eax 

; print the fibonacci after convert to ascii

mov eax, dword [fib]
add eax, 0x30
mov dword [aux], eax
print aux, 1
print newLine, newLineSize


; end the program  

kernel 1, 0, 0, 0 

