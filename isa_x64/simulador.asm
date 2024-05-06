; funcao em assembly que sera chamada pelo trabalho2.c 
; para implementar o simulador da linguagem inventada

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

%define nome_arquivo_objeto dword [ebp+8]
%define tamanho_arquivo_objeto 100
section .data  

newLine db 0xa, 0xd
newLineSize EQU $-newLine

nome_test db "arquivo_objeto.obj",0
nome_testSize EQU $-nome_test

space db " "
spaceSize EQU $-space

valor4 db "3",0x00


section .bss  

tamanho_arquivo_saida resd 1

aux resd 1
aux2 resb 100
aux3 resb 1

file resd 1

i resd 1
n resd 1
IP resd 1
opcode resd 1

vetor resd 3000
string resd 1000
string_final resd 1000
string_size resd 1

posicao_atual resd 1

section .text  

;global _start  
;_start:

global simulador   
extern le_arquivo
extern int_to_string
extern string_to_int
extern escreve_arquivo

simulador: 
   enter 40, 0  

   push ebx
   push esi
   push edi  

   mov eax, nome_arquivo_objeto

   ; trecho apenas para teste de leitura correta do nome do nome_arquivo_objeto
   ; que deve ser comentado
   ;print nome_arquivo_objeto, tamanho_arquivo_objeto
   ;print newLine, newLineSize


   push vetor ; endereco do array passado como referencia
   push n   ; n e passado por referencia e retornara o numero de inteiros lidos
   push nome_arquivo_objeto
   call le_arquivo
   add esp, 12 ; atualiza sp, 12 = 4*3

   ; testa tamanho do vetor
   ;mov eax, dword [n]
   ;add eax, 0x30
   ;mov dword [aux], eax 
   ;print aux, 1
   ;print newLine, newLineSize

   ; testa se escreveu direito no vetor 
   ;mov esi, 0
   ;for:
      ;mov eax, dword [vetor + esi*4]

      ;add eax, 0x30 ; converte int de 1 a 9 para codigo ascii
      ;mov dword [aux], eax 
      ;print aux, 1

      ; chava funcao int_to_string passa inteiro por valor
      ; e endereco de string por referencia
      ; retorna o tamanho da string gerada
      ;push eax
      ;push string  
      ;call int_to_string
      ;mov dword [string_size], eax 
      ;add esp, 8 
      ;mov eax, dword [string_size]
      ;mov ebx, 4
      ;mul ebx 
      ;mov edi, eax
      ;print string, edi
     

      ;print space, spaceSize

      ;inc esi 
      ;cmp esi, dword [n]
      ;jb for 

   ;mov eax, 32
   ;add eax, 0x30
   ;mov dword [aux], eax
   ;print aux, 1
   ;print newLine, newLineSize


   ; de posse do array vetor com os opcodes e enderecos  
   ; lidos do arquivo objeto iremos inicializar IP(instruction pointer)
   ; com 0 e iremos atualizando ele dependendo da instrucao
   ; ate chegarmos ao opcode stop(14), ou IP for maior que
   ; o tamanho do vetor, ou IP for 0(SPACE)
   ; a cada instrucao iremos realizar a operacao indicada
   ; pelo opcode, usando como acumulador edi

   mov dword [IP], 0 
   mov edi, 0 ; acumulador comeca com 0 
   while:
      ; testa acumulador  
      ;mov eax, edi 
      ;add eax, 0x30
      ;mov dword [aux], eax 
      ;print aux, 1
      ;print newLine, newLineSize


      ; testa valor de IP 
      ;mov eax, dword [IP]
      ;add eax, 0x30
      ;mov dword [aux], eax 
      ;print aux, 4
      ;print space, spaceSize

      mov eax, dword [IP]
      mov dword [posicao_atual], eax 
      mov esi, eax 
      mov eax, dword [vetor + esi*4]
      mov dword [opcode], eax

      mov eax, dword [opcode] ; eax := *opcode

      ; testa opcode deve ser comentado
      ;push eax 
      ;add eax, 0x30
      ;mov dword [aux], eax  
      ;print aux, 4 
      ;pop eax 
      ;print newLine, newLineSize
      
      ; atualiza IP ===========================================
      ; if opcode = 05(jmp) entao salta para OP
      cmp eax, 5
      jne opcodeNotJMP

         ; opcode é JMP(05)
         mov esi, dword [IP]
         inc esi
         mov eax, dword [vetor + esi*4]
         mov dword [IP], eax

         jmp endExecutaOpcode

      opcodeNotJMP:
         cmp eax, 6  
         jne opcodeNotJMPN

         ; opcode é JMPN(06)
         cmp edi, 0          ; ACC < 0 ?
         jae opcodeNotJMPFalse

         ; ACC < 0
         mov esi, dword [IP]
         inc esi    
         mov eax, dword [vetor + esi*4]
         mov dword [IP], eax

         jmp endExecutaOpcode

         opcodeNotJMPFalse: ; ACC >= 0
            mov eax, dword [IP]
            add eax, 2 
            mov dword [IP], eax 

            jmp endExecutaOpcode

      opcodeNotJMPN:
         cmp eax, 7
         jne opcodeNotJMPP

         ; o opcode é JMPP(07)
         cmp edi, 0            ; ACC > 0 ?
         jbe opcodeNotJMPNFalse

         ; ACC > 0
         mov esi, dword [IP]
         inc esi 
         mov eax, dword [vetor + esi*4]
         mov dword [IP], eax

         jmp endExecutaOpcode

         opcodeNotJMPNFalse: ; ACC <= 0
            mov eax, dword [IP]
            add eax, 2
            mov dword [IP], eax 

         jmp endExecutaOpcode

      opcodeNotJMPP:
         cmp eax, 8
         jne opcodeNotJMPs

         ; o opcode é JMPZ(08)
         cmp edi, 0            ; ACC == 0 ?
         jne opcodeNoTJMPPFalse

         ; ACC == 0
         mov esi, dword [IP]
         inc esi  
         mov eax, dword [vetor+esi*4]
         mov dword [IP], eax

         jmp endExecutaOpcode

         opcodeNoTJMPPFalse: ; ACC != 0
            mov eax, dword [IP]
            add eax, 2 
            mov dword [IP], eax 

         jmp endExecutaOpcode

      opcodeNotJMPs:
         cmp eax, 14
         jne opcodeNotStop  

         ; o opcode é stop(14)
         ; entao para o programa  
         jmp endProgram 

         ;jmp endAtualizaIP 

      opcodeNotStop:
         cmp eax, 9  
         jne opcodeNotCopy  

         ; opcode é copy(09)
         mov eax, dword [IP]
         add eax, 3 
         mov dword [IP], eax

         jmp endAtualizaIP

      opcodeNotCopy:
         cmp eax, 0 
         jne opcodeNotInvalid

         ; opcode 0 é invalido entao termina o programa simulado
         jmp endProgram  

         ;jmp endAtualizaIP 

      opcodeNotInvalid:
         ; entao e um dos outros opcodes validos
         ; que nao sao copy, stop, jmp, jmpn, jmpp, jmpz
         mov eax, dword [IP]
         add eax, 2 
         mov dword [IP], eax 

      endAtualizaIP:

      ; executa opcode =========================
      mov eax, dword [opcode] ; eax := *opcode
      mov esi, dword [posicao_atual] ; esi := *posicao_atual

      cmp eax, 1
      jne notOpcodeADD

         ; opcode é ADD(01)
         inc esi 
         mov eax, dword [vetor+esi*4] ; eax = OP
         mov eax, dword [vetor+eax*4] ; eax = mem(OP)
         add edi, eax ; ACC = ACC + mem(OP)

         jmp endExecutaOpcode
      notOpcodeADD:
         cmp eax, 2
         jne notOpcodeSUB

         ; o opcode é SUB(02)
         inc esi 
         mov eax, dword [vetor + esi*4] ; eax = OP 
         mov eax, dword [vetor + eax*4] ; eax = mem(OP)
         sub edi, eax ; ACC = ACC - memp(OP)

         jmp endExecutaOpcode

      notOpcodeSUB:
         cmp eax, 3 
         jne notOpcodeMUL

         ; o opcode é MUL(03)
         inc esi 
         mov ebx, dword [vetor + esi*4] ; ebx = OP 
         mov eax, dword [vetor + ebx*4] ; eax = mem(OP)

         push eax
         ;mov dword [aux], eax 
         ;print aux, 1 
         pop eax 
         mov edx, 0
         mul edi 
         mov edi, eax ; ACC = ACC * mem(OP)     

         jmp endExecutaOpcode

      notOpcodeMUL:
         cmp eax, 4
         jne notOpcodeDIV

         ; o opcode é DIV(04)
         inc esi 
         mov ebx, dword [vetor + esi*4]; ebx = OP 
         mov ebx, dword [vetor + ebx*4] ; ebx = mem(OP)
         mov edx, 0
         mov eax, edi 
         div ebx
         mov edi, eax ; ACC = ACC / mem(OP)
         
         jmp endExecutaOpcode

      notOpcodeDIV:
         cmp eax, 9
         jne notOpcodeCOPY

         ; o opcode é COPY(09)
         inc esi 
         mov eax, dword [vetor + esi*4] ; eax := OP1 
         mov eax, dword [vetor + eax*4] ; eax = mem(OP1)
         inc esi 
         mov ecx, dword [vetor + esi*4] ; ecx := OP2 
         mov ebx, dword [vetor + ebx*4] ; ebx = mem(OP2)

         mov dword [vetor + ecx*4], eax ; mem(OP2) <- mem(OP1)

         jmp endExecutaOpcode

      notOpcodeCOPY:
         cmp eax, 10  
         jne notOpcodeLOAD

         ; o opcode é LOAD(10)
         inc esi 
         mov esi, dword [vetor+esi*4] ; esi = OP  
         mov edi, dword [vetor+esi*4] ; ACC <- mem(OP) 

         jmp endExecutaOpcode

      notOpcodeLOAD:
         cmp eax, 11
         jne notOpcodeSTORE

         ; o opcode é STORE(11)
         inc esi 
         mov esi, dword [vetor + esi*4] ; esi <- OP  
         mov dword [vetor +esi*4], edi ; mem(OP) <- ACC

         jmp endExecutaOpcode

      notOpcodeSTORE:
         cmp eax, 12
         jne notOpcodeINPUT

         ; o opcode é INPUT(12)
         inc esi 
         mov esi, dword [vetor + esi*4]
         mov dword [aux], esi 
         kernel 3,0, aux2,1000 ; le quatro bytes; muda eax, ebx, ecx e edx

         ;print aux2, 4
         ;print newLine, newLineSize

         push esi
         
         ;mov al, byte [aux2 + 0]
         ;mov byte [aux3], al
         ;print aux3, 1

         ;mov al, byte [aux2 + 1]
         ;mov byte [aux3], al 
         ;print aux3, 1

         ;mov al, byte [aux2 + 2]
         ;mov byte [aux3], al 
         ;print aux3, 1

         mov esi, 0 

         forInput:
            mov al, byte [aux2 + esi]
            cmp al, 0x0a
            je endForInput
            mov dword [string_final + esi*4], eax
            inc esi 
            jmp forInput 

         endForInput:
            mov ebx,  esi 

         pop esi 

         ;mov dword [string_final + 0], 0x32
         ;mov dword [string_final + 4], 0x37
         ;mov dword [string_final + 8], 0x00
         ;mov ebx, 2
         push ebx 
         push string_final
         call string_to_int
         add esp, 8

         mov esi, dword [aux]
         mov dword [vetor + esi*4], eax
        
         jmp endExecutaOpcode

      notOpcodeINPUT:
         cmp eax, 13
         jne notOpcodeOUTPUT

         ; o opcode é OUTPUT(13)
         inc esi 
         mov eax, dword [vetor + esi*4] 
         mov eax, dword [vetor + eax*4] ; eax := mem(OP)

         ; testa output antes da conversao
         ;push eax  
         ;add eax, 0x30
         ;mov dword [aux], eax 
         ;print aux, 40
         ;print newLine, newLineSize
         ;pop eax 

         push eax
         push string  
         call int_to_string
         mov dword [string_size], eax 
         add esp, 8 
         mov ebx, 4
         mul ebx 
         mov esi, eax
         print string, esi ; saida <- mem(OP)
         print newLine, newLineSize

         jmp endExecutaOpcode

      notOpcodeOUTPUT:
         cmp eax, 14

         jne endProgram ; opcode invalido

         ; opcode é STOP(14)
         jmp endProgram ; termina o programa 


      endExecutaOpcode:

      mov eax, dword [IP]
      mov ebx, dword [n]
      cmp eax, ebx 
      jb while

      endProgram: ; finalizou o programa 

   ; chama funcao que escreve no arquivo o disassembler
   ; do codigo e retorna o numero de bytes do arquivo  

   push dword [n]
   push vetor 
   push nome_arquivo_objeto
   call escreve_arquivo
   add esp, 12         ; restaura esp 

   print newLine, newLineSize   
   ; essa linha é apenas para testes e deve ser comentada
   ;mov dword [tamanho_arquivo_saida], 200

   ; retorna a quantidade de bytes do arquivo que foi criado
   mov dword [tamanho_arquivo_saida], eax 
   mov eax, dword [tamanho_arquivo_saida]

   ; fim da funcao 
   pop edi 
   pop esi 
   pop ebx 

   leave 
   ; O programa em C sera encarregado de atualizar a pilha : add esp,4
   ret 0 