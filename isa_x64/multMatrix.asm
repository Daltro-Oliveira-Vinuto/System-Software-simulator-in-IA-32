; program to multiply two matrixes

%macro print 2

pusha
mov eax, 4
mov ebx, 1
mov ecx, %1 ; pointer to output buffer
mov edx, %2
int 0x80

popa

%endmacro

%macro read 2

pusha
mov eax, 3
mov ebx, 0
mov ecx, %1 
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

%define rows 2
%define cols 2 

section .data

newLine db 0xa, 0xd
newLineSize equ $-newLine

space db "  "
spaceSize equ $-space

section .bss 

array1 resd 25 ; 5*5 = 25*4 = 100 bytes
array2 resd 25
array3 resd 25 
aux resd 1

i resd 1
j resd 1 
k resd 1

sum resd 1
prod resd 1

a resd 1
b resd 1

section .text 

global _start
_start:

; read the matrix 1

mov esi, 0
mov ebx, 0
mov ecx, rows 

readMatrix1:
   
   read aux, 2
   mov eax, dword [aux]
   sub eax, 0x30

   mov dword [array1 + ebx + esi*4], eax 

   inc esi 
   cmp esi, cols 
   jb readMatrix1 

   mov esi, 0

   mov eax, 4
   mov edx, cols
   mul edx 
   add ebx, eax 

   loop readMatrix1


; read matrix 2

mov esi, 0
mov ebx, 0
mov ecx, rows 

readMatrix2:
   
   read aux, 2
   mov eax, dword [aux]
   sub eax, 0x30

   mov dword [array2 + ebx + esi*4], eax 

   inc esi 
   cmp esi, cols 
   jb readMatrix2

   mov esi, 0 

   mov eax, 4 
   mov edx,cols 
   mul edx 
   add ebx, eax 

   loop readMatrix2


; calculate the product of two matrixes array1 and array2  


mov dword [i], 0 

fori:
   mov dword [j], 0 
   forj:
      mov dword [k], 0 
      mov dword [sum], 0
      fork:
         mov edx, dword [i]
         mov eax, cols
         mul edx
         mov ebx, eax
         mov eax, 4
         mul ebx
         mov ebx, eax

         mov esi, dword [k]

         mov eax, dword [array1 + ebx + esi*4]
         mov dword [a], eax 


         mov edx, dword [k]
         mov eax, cols
         mul edx
         mov ebx, eax
         mov eax, 4
         mul ebx
         mov ebx, eax


         mov esi, dword [j]

         mov eax, dword [array2 + ebx +esi*4]
         mov dword [b], eax 

         mov eax, dword [a]
         mov ebx, dword [b]
         mul ebx 
         mov dword [prod], eax

         mov eax, dword [i]
         mov edx, rows  
         mul edx 
         mov ebx, eax
         mov eax, 4
         mul ebx
         mov ebx, eax


         mov esi, dword [j]

         mov eax, dword [prod]
         add dword [sum], eax
         mov eax, dword [sum]

         mov dword [array3 + ebx + esi*4], eax 


         inc dword [k]
         cmp dword [k], cols 
         jb fork 

      inc dword [j]
      cmp dword [j], cols 
      jb forj 

   inc dword [i]
   cmp dword [i], rows 
   jb fori 


; print the product matrix  

mov esi, 0
mov ebx, 0
mov ecx, rows

printMatrix:
   mov eax, dword [array3 + ebx + esi*4]

   add eax, 0x30
   mov dword [aux], eax 

   print aux, 1
   print space, spaceSize  

   inc esi 
   cmp esi, cols
   jb printMatrix

   mov esi, 0

   mov eax, 4
   mov edx, cols
   mul edx
   add ebx, eax

   print newLine, newLineSize  

   loop printMatrix



; end program  
kernel 1, 0, 0, 0

