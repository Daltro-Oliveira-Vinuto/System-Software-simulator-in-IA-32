; read from myfile1.txt and save in arrayX
; read from myfile2.txt and save in arrayY
; sum the two arrays and save in arrayZ
; save the arrayZ in myfile3.txt  

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

%define size 100

section .data  

newLine dd 0xa, 0xd  
newLineSize equ $-newLine  

space dd " "
spaceSize equ $-space

myfile1 db "myfile1.txt",0
myfile2 db "myfile2.txt",0
myfile3 db "myfile3.txt",0
myfile4 db "newFile.txt",0
;arrayX dd 1,1,1,1,1
;arrayY dd 2,2,2,2,2

section .bss  

arrayX resd 100
arrayY resd 100
arrayZ resd 100

string_aux resb 100
string resd 100

file1 resd 1  
file2 resd 1 
file3 resd 1

aux resd 1 

i resd 1
n resd 1

caracteres resb 40

section .text  


global _start
_start:

; open the files myfile1.txt and read inside

kernel 5, myfile1, 00, 0777

mov dword [file1], eax 

mov dword [i], 0
mov esi, 0

for1:
   
   ; read byte by byte including spaces in the ascii format
   kernel 3, dword [file1], aux, 1

   cmp eax, 0 
   je endFor1

   mov eax, dword [aux]
   sub eax, 0x30

   mov dword [arrayX+ esi*4], eax


   mov eax, dword [arrayX + esi*4]
   add eax, 0x30
   mov dword [aux], eax
   print aux, 1

   inc dword [i]

   inc esi
   cmp esi, size  
   jb for1
endFor1:

print newLine, newLineSize

mov eax, dword [i]
mov dword [n], eax   

mov ebx, dword [n]
add ebx, 0x30
mov dword [aux], ebx 
print aux, 1

print newLine, newLineSize


; close file2 
kernel 6, dword [file1], 0,0


; open the files myfile2.txt and read inside

kernel 5, myfile2, 00, 0777

mov dword [file2], eax 
mov esi, 0

for2:
   
   ; read byte by byte including spaces in the ascii format
   kernel 3, dword [file2], aux, 1

   cmp eax, 0 
   je endFor2

   mov eax, dword [aux]
   sub eax, 0x30

   mov dword [arrayY+ esi*4], eax


   mov eax, dword [arrayY + esi*4]
   add eax, 0x30
   mov dword [aux], eax
   print aux, 1


   inc esi
   cmp esi, size  
   jb for2
endFor2:

  
print newLine, newLineSize


; close file2 
kernel 6, dword [file2], 0,0


; sum array1 and array2  

mov esi, 0

forSum:
   mov eax, dword [arrayX + esi*4]
   mov ebx, dword [arrayY + esi*4]
   add eax, ebx
   mov dword [arrayZ + esi*4], eax

   mov eax, dword [arrayZ + esi*4]
   add eax, 0x30
   mov dword [aux], eax
   print aux, 1


   inc esi
   cmp esi, dword [n]
   jb forSum 

; create and open file3 and write inside

;kernel 5, myfile3, 01, 0777 ; it will overwrite the past content
kernel 8, myfile3, 0777,0

mov dword [file3], eax 

; save the contents of arrayZ in myfile3 as ascii values  

;kernel 3, 0, string, 4

;kernel 4, dword [file3], string, 4
kernel 4, dword [file3], myfile1, 40


mov eax, dword [string + 1]
mov dword [aux], eax 
print aux, 1


; close file3 
kernel 6, dword [file3], 0, 0 


print newLine, newLineSize

kernel 8, myfile4,  0455, 0
mov dword [file1], eax

mov ax, -1
;xor ax,ax
;mov ax, 1
mov byte [aux], eax
kernel 4, dword [file1], aux , 4

jg end
print newLine, newLineSize
   
print dword [aux], 8

end:

kernel 6, dword [file1], 0,0 
   
; end program  
kernel 1, 0, 0, 0


