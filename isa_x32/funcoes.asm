; arquivo com as funcoes a serem usadas por simulador.asm 

; macro usada para auxiliar na impressa
%macro print 2 
pusha
mov eax, 4 
mov ebx, 1
mov ecx, %1 ; pointer to output buffer
mov edx, %2
int 0x80
popa
%endmacro

; macro usada pra chamar o kernel do Linux  
%macro kernel 4 

mov eax, %1
mov ebx, %2
mov ecx, %3
mov edx, %4
int 0x80

%endmacro

global le_arquivo
global int_to_string
global string_to_int
global escreve_arquivo

; defines da funcao le_arquivo
%define vetor dword [ebp + 16]
%define size dword [ebp + 12]
%define nome_arquivo_objeto dword [ebp + 8]

; defines da funcao escreve_arquivo
%define tamanho_vetor dword [ebp + 16]
%define vetor_entrada dword [ebp + 12]
%define nome_arquivo_entrada dword [ebp + 8]


; defines da funcao string_to_int
%define tamanho dword [ebp + 12]  
%define string dword [ebp + 8]

; defines da funcao int_to_string
%define inteiro_recebido dword [ebp+12]
%define string_desejada dword [ebp+8]

section .data 
myfile1 db "myfile1.txt",0

PC dd 1 
newLine db 0xa, 0xd
newLineSize EQU $-newLine

pulou db "pulou! "
pulouSize EQU $-pulou

space db " "
spaceSize EQU $-space

test_file db "myfile1.txt",0

labelADD db "ADD",0xa,0xd
labelSUB db "SUB",0xa,0xd
labelMULT db "MULT",0xa,0xd
labelDIV db "DIV",0xa,0xd
labelJMP db "JMP",0xa,0xd
labelJMPN db "JMPN",0xa,0xd
labelJMPP db "JMPP",0xa,0xd
labelJMPZ db "JMPZ",0xa,0xd
labelCOPY db "COPY",0xa,0xd
labelLOAD db "LOAD",0xa,0xd
labelSTORE db "STORE",0xa,0xd
labelINPUT db "INPUT",0xa,0xd
labelOUTPUT db "OUTPUT",0xa,0xd
labelSTOP db "STOP",0xa,0xd

section .bss  

aux resd 1 
file resd 1 
i resd 1 
j resd 1 
k resd 1
w resd 1
n resd 1 
p resd 1
vetor_char resd 3000
vetor_string resd 1000
string_size resd 1

aux2 resd 1

quociente resd 1
resto resd 1
string_final resd 1000
tamanho_string_final resd 1

nome_arquivo resb 100

sum resd 1

quantidade_bytes resd 1

section .text 

;global _start  
;_start:


escreve_arquivo:
   enter 0,0

   push ebx
   push ecx
   push edx
   push esi 
   push edi 

   ; modifica extensao do arquivo para .diss
   ; o arquivo deve necessariamente ter uma extensao 

   ;kernel 8, myfile1 , 01, 0777 
   ;mov dword [file], eax 

   ;kernel 4, dword [file], nome_arquivo_entrada, 40

   ;kernel 6, dword [file], 0, 0 

   mov esi, 0 
   forAlteraExtensao:
      mov ebx, nome_arquivo_entrada
      mov al, byte [ebx + esi]
      cmp al, '.' ; compara o com o '.'  
      je endForAlteraExtensao

      mov byte [nome_arquivo + esi], al
      inc esi  
      jmp forAlteraExtensao

   endForAlteraExtensao:


   mov dword [nome_arquivo+ esi], '.'
   inc esi 
   mov dword [nome_arquivo+ esi], 'd'
   inc esi 
   mov dword [nome_arquivo+ esi], 'i'
   inc esi 
   mov dword [nome_arquivo+ esi], 's'
   inc esi 
   mov dword [nome_arquivo+ esi], 's'
   inc esi  
   mov dword [nome_arquivo+ esi], 0x00

   ;kernel 8, myfile1 , 0777,0
   ;mov dword [file], eax 

   ;kernel 4, dword [file], nome_arquivo, 40

   ;kernel 6, dword [file], 0, 0

   ; cria arquivo para escrita
   ;kernel 8, test_file, 0455,0

   kernel 8, nome_arquivo, 0455,0

   ; descritor do arquivo  
   mov dword [file], eax 

   kernel 6, dword [file], 0,0

   kernel 5, nome_arquivo, 01, 0777
   mov dword [file],eax

   mov dword [quantidade_bytes], 0

   ; verifica os opcodes, salva no arquivo 
   ; e conta no numero de bytes 
   mov dword [PC], 0 ; program counter
   forEscreveArquivo:
      mov esi, dword [PC]
      mov ebx, vetor_entrada
      mov eax, dword [ebx + esi*4]

      ;push eax

      ;push eax
      ;push vetor_string  
      ;call int_to_string
      ;mov dword [string_size], eax 
      ;add esp, 8 
      ;mov eax, dword [string_size]
      ;mov ebx, 4
      ;mul ebx 
      ;mov edi, eax
      ;print vetor_string, edi
      ;print space, spaceSize

      ;pop eax

      cmp eax, 1 
      jne notADD  

      ; o opcode é ADD(01)
      add dword [quantidade_bytes], 4
      kernel 4, dword [file], labelADD,4
      add dword [PC], 2

      jmp continue

      notADD:
      cmp eax, 2
      jne notSUB

      ; o opcode é SUB(02)
      add dword [quantidade_bytes], 4
      kernel 4, dword [file], labelSUB, 4
      add dword [PC], 2

      jmp continue 
      
      notSUB:
      cmp eax, 3
      jne notMULT

      ; o opcode é MULT(03)
      add dword [quantidade_bytes], 5
      kernel 4, dword [file], labelMULT, 5
      add dword [PC], 2
      
      jmp continue 

      notMULT:
      cmp eax, 4
      jne notDIV

      ; o opcode é DIV(04)
      add dword [quantidade_bytes], 4
      kernel 4, dword [file], labelDIV, 4
      add dword [PC], 2
      
      jmp continue 

      notDIV:
      cmp eax, 5
      jne notJMP

      ; o opcode é JMP(05)
      add dword [quantidade_bytes], 4
      kernel 4, dword [file], labelJMP, 4
      add dword [PC], 2
      
      jmp continue 

      notJMP:
      cmp eax, 6
      jne notJMPN

      ; o opcode é JMPN(06)
      add dword [quantidade_bytes], 5
      kernel 4, dword [file], labelJMPN, 5
      add dword [PC], 2
      
      jmp continue 

      notJMPN:
      cmp eax, 7
      jne notJMPP

      ; o opcode é JMPP(07)
      add dword [quantidade_bytes], 5
      kernel 4, dword [file], labelJMPP, 5
      add dword [PC], 2
      
      jmp continue 

      notJMPP:
      cmp eax, 8
      jne notJMPZ

      ; o opcode é JMPZ(08)
      add dword [quantidade_bytes], 5
      kernel 4, dword [file], labelJMPZ, 5
      add dword [PC], 2
      
      jmp continue 

      notJMPZ:
      cmp eax, 9
      jne notCOPY

      ; o opcode é COPY(09)
      add dword [quantidade_bytes], 5
      kernel 4, dword [file], labelCOPY, 5
      add dword [PC], 3
      
      jmp continue 

      notCOPY:
      cmp eax, 10
      jne notLOAD

      ; o opcode é LOAD(10)
      add dword [quantidade_bytes], 5
      kernel 4, dword [file], labelLOAD, 5
      add dword [PC], 2
      
      jmp continue 

      notLOAD:
      cmp eax, 11
      jne notSTORE

      ; o opcode é STORE(11)
      add dword [quantidade_bytes], 6
      kernel 4, dword [file], labelSTORE, 6
      add dword [PC], 2
      
      jmp continue 

      notSTORE:
      cmp eax, 12
      jne notINPUT

      ; o opcode é INPUT(12)
      add dword [quantidade_bytes], 6
      kernel 4, dword [file], labelINPUT, 6
      add dword [PC], 2
      
      jmp continue 

      notINPUT:
      cmp eax, 13
      jne notOUTPUT

      ; o opcode é OUTPUT(13)
      add dword [quantidade_bytes], 7
      kernel 4, dword [file], labelOUTPUT, 7
      add dword [PC], 2
      
      jmp continue 

      notOUTPUT:
      cmp eax, 14
      jne continue

      ; o opcode é STOP(14)
      add dword [quantidade_bytes], 5
      kernel 4, dword [file], labelSTOP, 5
      
      jmp endForEscreveArquivo
     
      continue:

      mov eax, dword [PC]
      cmp eax, tamanho_vetor
      jb forEscreveArquivo

   endForEscreveArquivo:

   ; fecha arquivo 
   kernel 6, dword [file], 0, 0

   pop edi 
   pop esi 
   pop edx 
   pop ecx 
   pop ebx 

   mov eax, dword [quantidade_bytes]

   leave 
   ret 0 ; programa que chamou deve restaurar a pilha

le_arquivo:
   enter 0, 0

   push ebx
   push ecx  
   push edx 
   push esi  
   push edi  

   ; le do arquivo e imprime tudo nele
   kernel 5, nome_arquivo_objeto, 00, 0777
   
   mov dword [file], eax  ; salva descritor do arquivo em file

   ; le todo o arquivo ate EOF
   mov dword [i], 0
   for:
      ; le do arquivo 
      kernel 3, dword [file], aux, 1

      ; verifica se chegou ao final do arquivo
      cmp eax, 0 
      je endFor

      ; salve aux no vetor_char   
      mov esi, dword [i]
      mov eax, dword [aux]
      mov dword [vetor_char + esi*4], eax

      ; usado para testar se escreve em vetor passado por referencia
      ; deve ser comentado
      ;mov eax, dword [vetor_char + esi*4]
      ;mov dword [aux], eax 
      ;print aux, 1
      ;mov ebx, vetor
      ;mov dword [ebx + esi*4], eax

      ; testa valor de i 
      ;mov eax, dword [i]
      ;add eax, 0x30
      ;mov dword [aux], eax 
      ;print aux, 1


      inc dword [i]
      jmp for

      
   endFor:
   mov eax, dword [i]
   mov dword [n], eax 

   ; testa valor de n usado para testes deve ser comentado
   ;mov eax, dword [n]
   ;add eax, 0x30
   ;mov dword [aux], eax
   ;print aux, 1 

   ;print newLine, newLineSize


   ; fecha arquivo  
   kernel 6, dword [file], 0,0

   ; usado para testes, deve ser comentado
   ;print newLine, newLineSize


   ; percorre todo o vetor_char
   mov dword [i], 0 ; sera usado pelo vetor_char 
   mov dword [j], 0 ; sera usado pelo vetor_string
   mov dword [k], 0 ; sera usado pelo vetor  
   fori:
      ; acessa elemento vetor_char[i]
      mov esi, dword [i]
      mov eax, dword [vetor_char + esi*4]

      ; usado para teste deve ser comentado
      ;mov dword [aux], eax 
      ;print aux, 1

      ;print space, spaceSize

      ;mov ebx, dword [i]
      ;add ebx, 0x30
      ;mov dword [aux], ebx 
      ;print aux, 1

      ; se for espaco entao converte o vetor_string para inteiro
      ; e passa para o proxima iteracao
      cmp eax, 32
      je converte

      ; caso contrario e um numero entao adiciona ele no
      ; vetor_string ate chegar proximo espaco 
      ; ou final do arquivo, entao passa essa string para a 
      ; a funcao string_to_int e adiciona o inteiro retornado
      ; no vetor passado como referencia para le_arquivo
      mov esi, dword [j]
      mov dword [vetor_string + esi*4], eax

      inc dword [j]
      mov eax, dword [j]
      mov dword [string_size], eax ; salva tamanho da string
      jmp continueFori

      converte:
         ; usa para testes
         ;print pulou, pulouSize

         ; adiciona 0 no final da string
         mov esi, dword [j]
         mov dword [vetor_string + esi*4], 0x00 ; concatena o \0

         ; passa vetor_char para string_to_int  
         push dword [string_size] ; tamanho da string 
         push vetor_string ; endereco da string 
         call string_to_int 
         add esp, 8 ; atualiza esp, 8 = 4*2

         ; testa se string_to_int retorna valor adequado  
         ; deve ser comentado
         ;mov ebx, eax
         ;add ebx, 0x30 
         ;mov dword [aux], ebx
         ;print aux, 1
         ;print space, spaceSize

         ; salva inteiro(eax) retornado em vetor[k]
         mov esi, dword [k]
         mov ebx, vetor  
         mov dword [ebx + esi*4], eax 
         mov dword [j], 0 ; reseta j para 0
         inc dword [k] ; atualiza k

      continueFori:
         inc dword [i]
         mov eax, dword [i]
         cmp eax, dword [n]
         jb fori

   ; ==================================

   cmp dword [j], 0 ; se o arquivo nao terminar em espaco
   je endLeArquivo
      ; usa para testes
      ;print pulou, pulouSize

      ; adiciona 0 no final da string
      mov esi, dword [j]
      mov dword [vetor_string + esi*4], 0x00 ; concatena o \0

      ; passa vetor_char para string_to_int  
      push dword [string_size] ; tamanho da string 
      push vetor_string ; endereco da string 
      call string_to_int 
      add esp, 8 ; atualiza esp, 8 = 4*2

      ; testa se string_to_int retorna valor adequado  
      ; deve ser comentado
      ;mov ebx, eax
      ;add ebx, 0x30 
      ;mov dword [aux], ebx
      ;print aux, 1
      ;print space, spaceSize

      ; salva inteiro(eax) retornado em vetor[k]
      mov esi, dword [k]
      mov ebx, vetor  
      mov dword [ebx + esi*4], eax 
      mov dword [j], 0 ; reseta j para 0
      inc dword [k] ; atualiza k

   endLeArquivo:
   ;======================================

   ;print newLine, newLineSize
   ; salva tamanho do vetor por referencia em size
   ; size := k
   mov eax, size  
   mov ebx, dword [k]
   mov [eax], ebx

   push edi 
   push esi 
   push edx 
   push ecx
   push ebx 

   mov eax, 1

   leave  
   ret 0 


; converte uma string para inteiro
; recebe numero de elementos da string e o endereco da 
; primeira posicao

string_to_int:
   enter 0,0  

   push ebx 
   push ecx 
   push edx
   push esi 
   push edi 

   ;print string, 80

   ;mov eax, tamanho 
   ;add eax, 0x30
   ;mov dword [aux], eax 
   ;print aux, 40

   mov dword [sum], 0 

   ; percorre a string
   mov dword [w], 0  
   forStringToInt:
      ; obtem o elemento de string 
      mov ebx, string  
      mov esi, dword [w]
      mov eax, dword [ebx + esi*4]

      ; converte para inteiro o caractere de 0 a 9  
      sub eax, 0x30  
      mov edi, eax

      ; multiplica sum por 10  
      mov eax, 10 
      mov ebx, dword [sum]
      mul ebx 
      mov dword [sum], eax

      ; adiciona a sum  
      add dword [sum], edi

      inc dword [w]
      mov eax, dword [w]
      mov ebx, tamanho
      cmp eax, ebx
      jb forStringToInt

   mov eax, dword [sum] ; retorna o inteiro obtido

   pop edi 
   pop esi 
   pop edx 
   pop ecx 
   pop ebx 

   leave 
   ret 0 ; funcao que chamou deve restaurar esp 

; converte um numero inteiro para uma string, isso e, 
; um vetor de caracteres
; recebe o numero inteiro e o endereco da string 
; retorna o tamanho da string apos conversao  

int_to_string:
   enter 0, 0 

   push ebx 
   push ecx 
   push edx
   push esi 
   push edi 

   mov eax, inteiro_recebido ; inteiro recebido  

   ; testa valor recebido
   ;push eax
   ;add eax, 0x30 
   ;mov dword [aux], eax
   ;print aux, 80
   ;pop eax
   ;print space, spaceSize

   ;print space, spaceSize

   ; armazena na forma inversa 
   mov dword [aux], eax ; inteiro recebido
   mov dword [w], 0 
   forIntToString:
      mov edx, 0x00
      mov eax, dword [aux]
      mov ebx, 10
      div ebx 

      mov dword [quociente], eax
      mov dword [resto], edx
      mov dword [aux], eax

      ;add eax, 0x30 
      ;mov dword [aux2], eax
      ;print aux2, 20
      ;print space, spaceSize
      ;add edx, 0x30 
      ;mov dword [aux2], edx
      ;print aux2, 20
      ;print space, spaceSize


      mov eax, dword [resto]
      add eax, 0x30
      mov esi, dword [w]
      mov dword [string_final + esi*4], eax

      ;mov eax, dword [string_final+esi*4]
      ;mov dword [aux2], eax
      ;print aux2, 1

      inc dword [w]
      mov eax, dword [quociente]
      cmp eax, 0 
      jne forIntToString

   ;print newLine, newLineSize


   mov eax, dword [w]
   mov dword [tamanho_string_final], eax 

   ; testa inteiro retornado corresponde ao numero de caracteres
   ;add eax, 0x30
   ;mov dword [aux2], eax
   ;print aux2, 20
   ;print newLine, newLineSize 
   ;mov eax, dword [tamanho_string_final]

   mov esi, eax
   mov dword [string_final + esi*4], 0x00
   ; testa string_final
   ;print string_final, eax 

   ; inverte string_final e salva em string_desejada
   ; que foi passada como referencia para a funcao
   mov eax, dword [tamanho_string_final]
   dec eax
   mov dword [w], eax ; w = tamanho-1
   mov dword [p], 0
   forInverte:
      mov esi, dword [w]
      mov eax, dword [string_final + esi*4]

      mov esi, dword [p]
      mov ebx, string_desejada
      mov dword [ebx + esi*4], eax


      dec dword [w]
      inc dword [p]
      mov eax, dword [p]
      mov ebx, dword [tamanho_string_final]
      cmp eax, ebx 
      jne forInverte


   mov ebx, string_desejada 
   mov esi, dword [p]
   mov dword [ebx + esi*4], 0x00 ; adciona \0 no final
   mov eax, dword [tamanho_string_final]


   pop edi 
   pop esi 
   pop edx 
   pop ecx
   pop ebx

   leave
   ret 0; O programa que chamou tera que atualizar o esp 