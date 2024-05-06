; sum the elements of a array and write the result in the screen

%macro print 2

mov eax, 4
mov ebx, 1
mov ecx, %1
mov edx, %2
int 0x80

%endmacro

%macro kernel 4

mov eax, %1
mov ebx, %2
mov ecx, %3
mov edx, %4
int 0x80

%endmacro

section .data

array dd 1, 2, 3
arraySize equ ($-array)/4 

newLine db 0xa, 0xd  
newLineSize equ $-newLine

section .bss 

sum resd 1 ; 4 bytes
aux resd 1 ; 4 bytes

section .text

global _start
_start:

; sum array 

mov ecx, arraySize
mov esi, 0
mov eax, 0

forSumArray:
   add eax, dword [array+esi*4] 
   inc esi 
   loop forSumArray 


; save array sum  

mov dword [sum], eax 

; get the value and convert to ascii  
mov eax, dword [sum]
add eax, 0x30
mov dword [aux], eax


; print the sum of the array  

mov eax, 4
mov ebx, 1  
mov ecx, aux
mov edx, 4
int 0x80

print newLine, newLineSize

print aux, 4
print newLine, newLineSize

kernel 4, 1, aux, 4
print newLine, newLineSize


; end program 
kernel 1, 0, 0, 0 












