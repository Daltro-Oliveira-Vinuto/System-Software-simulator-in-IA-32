
%macro print 2 

pusha  

mov eax, 4 
mov ebx, 1 
mov ecx, %1 
mov edx, %2   
int 0x80

popa
%endmacro

%macro kernel 4

mov eax, %1
mov ebx, %2
mov ecx, %3
mov edx, %4
int 0x80
 

%endmacro 

section .data 

myfile1 db "myfile1.txt",0
myfile2 db "myfile2.txt",0

%define size 5

section .bss 

arrayX resd 100  
arrayY resd 100
file1 resd 1 
file2 resd 1
aux resd 1

section .text 


global _start  
_start: 

kernel 5, myfile1, 00, 0777

mov dword [file1], eax

mov ecx, size 
mov esi, 0

le1:
   push ecx
   kernel 3, dword [file1], aux, 2
   pop ecx
   mov eax, dword [aux]
   mov dword [arrayX+esi*4], eax

   inc esi 
   
   loop le1


kernel 6, dword [file1] , 0, 0 


mov ecx, size 
mov esi, 0

loopY:
   mov eax, dword [arrayX+esi*4]

   mov dword [aux], eax 
   print aux, 2

   cmp eax, 0 
   ja pos

   mov eax, 0

   jmp end 
   pos:
      mov eax, 1 
   end:

   mov dword [arrayY+esi*4],eax


   inc esi 
   
   loop loopY



kernel 5, myfile2, 01, 0744

mov dword [file2], eax 

mov ecx, size 
mov esi, 0

le2:

   mov eax, dword [arrayY+esi*4]
   add eax, 0x30
   mov dword [aux], eax
   push ecx
   kernel 4, dword [file2], aux, 2
   pop ecx

   mov dword [aux], eax 
   print aux, 2

   inc esi 
   
   loop le2



kernel 6, dword [file2] , 0, 0 


kernel 1,0,0,0 