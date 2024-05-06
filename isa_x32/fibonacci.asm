; calcula fibonacci using a function that can be called from C program. 

global fibonacci

%define fib_lo dword [ebp - 4] ; local variable
%define fib_hi dword [ebp - 8] ; local variable
%define argN dword [ebp + 8]   ; function parameter

section .data  

newLine db 0xa, 0xd
newLineSize equ $-newLine  

space db "  "
spaceSize equ $-space  

section .bss


section .text

;global _start
;_start:


; fibonacci function 
; returns the first fibonacci number above argN
fibonacci: ; return can be by the stack, should be in eax
   enter 8, 0 

   push ebx 
   push esi  
   push edi 

   mov edx, argN
   mov fib_lo, 1
   mov fib_hi, 1 

   mov eax, fib_lo 
   add eax, fib_hi

   repeatFibonacci:
      mov eax, fib_lo
      mov ebx, fib_hi  

      add eax, ebx 
      mov fib_lo, ebx 
      mov fib_hi, eax 

      cmp eax, edx
      jb repeatFibonacci

   
   pop edi 
   pop esi 
   pop ebx

   leave  
   ret 0 ; C program will restore the stack by add esp, 4