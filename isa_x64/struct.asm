; how structs are made in assembly
; we are going to implement the following struct:
; struct discipline {
;   int code;
;   int limit;
;   int registered;
;   int room; 
;  }


%define code 0
%define limit 4
%define registered 8
%define room 12


%macro loadStruct 3

mov eax, %2  
mov eax, dword [eax+%3]
add eax, 0x30
mov dword [%1], eax 

%endmacro

%macro print 2

mov eax, 4
mov ebx, 1
mov ecx, %1
mov edx, %2
int 0x80

%endmacro

section .data

newLine db 0xa, 0xd
sizeNewLine equ $-newLine

askCode db "Digite o codigo do curso: "
sizeAskCode equ $-askCode

askLimit db "Digite o limite de alunos: "
sizeAskLimit equ $-askLimit

askRegistered db "Digite a quantidade de alunos  matriculados: "
sizeAskRegistered equ $-askRegistered

askRoom db "Digite o numero da sala: "
sizeAskRoom equ $-askRoom

section .bss

discipline resb 16
response resb 2
aux resd 4 

section .text 

global _start
_start:

; solicita o codigo do curso  
mov eax, 4
mov ebx, 1
mov ecx, askCode
mov edx, sizeAskCode
int 0x80

; le resposta
mov eax, 3
mov ebx, 0
mov ecx, response
mov edx, 2
int 0x80

; corrige resposta
mov ebx, 0
mov bl, byte [response]
sub bl, 0x30

; armazena codigo, equivalente a discipline.code 
mov eax, discipline
mov dword [discipline+code], ebx ; one possible way of doing structs

;solicita limite de alunos do curso 
mov eax, 4
mov ebx, 1
mov ecx, askLimit
mov edx, sizeAskLimit
int 0x80

; le resposta  
mov eax, 3
mov ebx, 0
mov ecx, response  
mov edx, 2 
int 0x80

; corrige resposta
mov ebx, 0
mov bl, byte [response]
sub bl, 0x30

; armazena limite de alunos, equivalente a discipline.limit 
mov eax, discipline 
mov dword [eax+limit], ebx 

; solicita quantidade de alunos matriculados
mov eax, 4
mov ebx, 1
mov ecx, askRegistered
mov edx, sizeAskRegistered
int 0x80

; le resposta 
mov eax, 3
mov ebx, 0
mov ecx, response
mov edx, 2
int 0x80

; corrige resposta
mov ebx, 0
mov bl, byte [response]
sub bl, 0x30

; salve alunos matriculados, equivale a discipline.registered
mov eax, discipline
mov dword [eax+registered], ebx 

; pergunta o numero da sala 
mov eax, 4
mov ebx, 1
mov ecx, askRoom
mov edx, sizeAskRoom
int 0x80

; le a resposta
mov eax, 3
mov ebx, 0
mov ecx, response
mov edx, 2
int 0x80

; corrige resposta
sub ebx, ebx 
mov bl, byte [response]
sub bl, 0x30

; salve numero da sala, equivale a discipline.room 
mov eax, discipline 
mov dword [eax+room], ebx 


; imprime discipline.code 
mov eax, discipline 
mov eax, dword [eax+code]
add eax, 0x30
mov dword [aux], eax 
mov eax, 4
mov ebx, 1
mov ecx, aux
mov edx, 4
int 0x80

; new line  
mov eax, 4
mov ebx, 1
mov ecx, newLine
mov edx, sizeNewLine
int 0x80

; imprime discipline.limit 
mov eax, discipline 
mov eax, dword [eax+limit] 
add eax, 0x30  
mov dword [aux], eax 

print aux, 4  
print  newLine, sizeNewLine


; imprime discpline.registered 
loadStruct aux, discipline, registered 
print aux, 4 
print newLine, sizeNewLine

; imprime discipline.room 
loadStruct aux, discipline, room 
print aux, 4
print newLine, sizeNewLine


; finaliza programa 
mov eax, 1
mov ebx, 0
int 0x80








