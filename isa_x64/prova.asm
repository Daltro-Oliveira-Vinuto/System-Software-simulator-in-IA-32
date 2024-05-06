section .data 

%define n dword [ebp + 20] 
%define m dword [ebp + 16] 
%define m2 dword [ebp + 12]   
%define m1 dword [ebp + 8]   


section .bss 


section .text 


global _start  
_start: 

f1:
   enter 0, 0

   push ebx 
   push esi  
   push edi 

   mov ebx, 0 
   mov esi, 0
   mov ecx, m

   repeat:
      mov eax, dword [m1 + ebx + esi*4]
      mov edx, dword [m2 + ebx + esi*4] 
      sub eax, edx 
      mov dword [m1+ ebx + esi*4], eax

      inc esi 
      cmp esi, n
      jb repeat

      mov esi, 0
      
      mov edx, n
      mov eax, 4 
      mul edx
      add ebx, eax

      loop repeat

   mov eax, 1 
   
   pop edi 
   pop esi 
   pop ebx

   leave  
   ret 