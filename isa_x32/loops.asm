; using loops in assembly x86


%macro print 2

pusha

mov eax, 4
mov ebx, 1
mov ecx, %1 ; pointer to output buffer
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


MAX equ 3
MAXi equ 4
MAXj equ 2 

section .data 

newLine db 0xa, 0xd
newLineSize equ $-newLine

space db "  "
spaceSize equ $-space

sum db 0 

section .bss 

i resb 1 ; 1 byte
j resb 1 ; 1 byte

aux resb 1 ; 1 byte

section .text  

global _start
_start:  


;-------------------------

; sum = 0  
; for(i = MAX; i>0; i--) 
;     sum += i  


mov byte [i], MAX
mov ecx, 0
mov cl, byte [i]

for1:
   add byte [sum], cl 

   loop for1

mov al, byte [sum]
add al, 0x30
mov byte [aux], al;

print aux, 1
print newLine, newLineSize
print newLine, newLineSize

;----------------------

;----------------------
; i = 0;
; while (i < 100) {
; printf(" %d", i);
; i++;  
; }

mov byte [i], 0 

while1:
   mov cl, byte [i]
   cmp cl, MAX
   jae endWhile1

   mov al, byte [i]
   add al, 0x30
   mov byte [aux], al

   print aux, 1
   print newLine, newLineSize

   inc byte [i]
   jmp while1


endWhile1:
print newLine, newLineSize

;----------------------

;----------------------

; main() {
; int i, j;
; for(i=0; i < 4; i++) 
;     for(j=0; j < 2; j++)
;        printf("%d %d", i, j);

mov byte [i], 0 
fori:
   mov byte [j], 0 
   forj:
      mov al, byte [i]
      add al, 0x30
      mov byte [aux], al 
      print aux, 1
      print space, spaceSize  

      mov al, byte [j]
      add al, 0x30
      mov byte [aux], al 
      print aux, 1
      print newLine, newLineSize

      inc byte [j]
      cmp byte [j], MAXj  
      jb forj 

   inc byte [i]
   cmp byte [i], MAXi  
   jb fori




print newLine, newLineSize

;----------------------



; end the program

kernel 1, 0, 0, 0 
