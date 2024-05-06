section .data

digiteName db "Digite your name: "
sizeDigiteName equ $-digiteName  

repeatWelcome db "How many times to repeat welcome? "
sizeRepeatWelcome equ $-repeatWelcome

welcomeMessage db "Welcome to Assembly Language Programming "
sizeWelcomeMessage equ $-welcomeMessage

newLine db  0xa, 0xd
sizeNewLine equ $-newLine

section .bss 

user_name resb 20
response resb 1


section .text 

global _start
_start:
; ask user name
mov eax, 4
mov ebx, 1
mov ecx, digiteName
mov edx, sizeDigiteName
int 0x80

; read user name 
mov eax, 3
mov ebx, 0
mov ecx, user_name
mov edx, 20
int 0x80

; ask how many times to repeat the welcome 
mov eax, 4
mov ebx, 1
mov ecx, repeatWelcome  
mov edx, sizeRepeatWelcome
int 0x80

; read answer from user  
mov eax, 3
mov ebx, 0
mov ecx, response
mov edx, 1
int 0x80

; clear register ecx and get the integer value 
mov ecx, 0 
mov cl, [response]
sub cl, 0x30

; repeat welcome message + name + newline, response vezes
repeat:
   push ecx ; save ecx value

   ; imprime welcome  
   mov eax, 4
   mov ebx, 1
   mov ecx, welcomeMessage
   mov edx, sizeWelcomeMessage
   int 0x80

   ; print name of the user_name
   mov eax, 4
   mov ebx, 1
   mov ecx, user_name
   mov edx, 20
   int 0x80

   ; print new line 
   mov eax, 4
   mov ebx, 1
   mov ecx, newLine
   mov edx, sizeNewLine
   int 0x80

   pop ecx ; retrieve ecx value

   loop repeat ; until ecx == 0 jump to repeat



; end program
mov eax, 1
mov ebx, 0
int 0x80