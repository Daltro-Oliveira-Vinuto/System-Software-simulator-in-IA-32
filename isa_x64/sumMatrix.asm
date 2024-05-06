; sum two matrixes


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
mov ecx, %1 ; should be a pointer 
mov edx, %2
int 0x80
popa

%endmacro

columns equ 5
rows equ 4

section .data  
array1 
times 5 dd 1 
times 5 dd 2
times 5 dd 3
times 5 dd 4

array2 
times 5 dd 1
times 5 dd 2
times 5 dd 3 
times 5 dd 4

newLine db 0xa, 0xd
newLineSize equ $-newLine
space db "   "
spaceSize equ $-space

section .bss  

array3 resd 20 ; matrix 5 x 4 = 20*4 = 80 bytes
aux resd 2
auxd resd 2; 8 bytes

section .text  

global _start  
_start: 

; array3 = array1+array2

mov esi, 0
mov ebx, 0
mov ecx, rows

; sum two matrixes

sumMatrixLoop:
   mov eax, dword [array1 + ebx + esi*4]
   mov edx, dword [array2 + ebx + esi*4] 
   add eax, edx 
   mov dword [array3 + ebx + esi*4], eax

   mov eax, dword [array3 + ebx + esi*4]
   add eax, 0x30
   mov dword [aux], eax 

   print aux, 1
   print space, spaceSize

   mov eax, esi 
   add eax, 0x30
   mov dword [auxd], eax

   print auxd, 1
   print space, spaceSize

   mov eax, ebx
   add eax, 0x30
   mov dword [auxd], eax

   print auxd, 1
   ;kernel 3, 0, aux, 2
   print newLine, newLineSize

   inc esi 
   cmp esi, columns 
   jb sumMatrixLoop 

   mov esi, 0
   
   mov edx, columns
   mov eax, 4 
   mul edx
   add ebx, eax

   dec ecx
   cmp ecx, 0
   jne near sumMatrixLoop

; print the matrix

mov esi, 0
mov ebx, 0
mov ecx, rows 

printMatrixLoop:
   mov al, byte [array3 + ebx + esi*4]
   add al, 0x30
   mov byte [aux], al

   print aux, 1
   print space, spaceSize

   inc esi 
   cmp esi, columns 
   jb printMatrixLoop

   print newLine, newLineSize

   mov esi, 0

   mov edx, columns
   mov eax, 4 
   mul edx
   add ebx, eax

   loop printMatrixLoop


kernel 1,0,0,0




