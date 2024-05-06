; int main(){
; x = 2;
; a = 1;
; y = 3;
; x = (a+y)*x
; }

%macro kernel 4

pusha

mov eax, %1
mov ebx, %2
mov ecx, %3
mov edx, %4
int 0x80

popa

%endmacro

%macro print 2

pusha

mov eax, 4
mov ebx, 1
mov ecx, %1   ; pointer to output buffer
mov edx, %2
int 0x80

popa

%endmacro

section .data 

x dd 2
a dd 1
y dd 3

newLine db 0xa, 0xd
newLineSize equ $-newLine

section .bss

output resd 1 ;  4 bytes

section .text 

global _start  
_start:  

mov edx, dword [x]
mov eax, dword [a]
add eax, dword [y]
mul edx 

mov dword [x], eax 

mov ecx, dword [x]
add ecx, 0x30
mov dword [output], ecx 

print output, 1
print newLine, newLineSize

kernel 1, 0, 0, 0 


















