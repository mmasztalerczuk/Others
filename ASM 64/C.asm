BITS 64

SECTION .text

extern malloc   
extern memcpy
extern free

EXTERN _GLOBAL_OFFSET_TABLE_

GLOBAL sstatus:data 8 
GLOBAL push:function        
GLOBAL top_length:function  
GLOBAL pop:function  
GLOBAL count:function  


STATUS:      
      mov r9, _GLOBAL_OFFSET_TABLE_
      mov r9, [r9+sstatus wrt ..got]
      mov [r9], r10
      ret  
  
push:   
      mov r14, rdi
      mov r15, rsi
      mov [rel tmp],  r14
      mov [rel tmp2], r15

      test rdi, rdi
      js ERROR1
      mov rdi, r14
      test rdi, rdi
      je ERROR1
   
      add rdi, 16
      call malloc wrt ..plt
      test rax,rax
      jz ERROR4
   
      mov r8, [rel wskaznik]  
  
      mov r14, [rel tmp]
      mov [rax],   r8    ; z
      mov [rax+8], r14   ;
      mov r15, [rel tmp2]
      mov rdi, rax  
      add rdi, 16  
      mov rdx, r14
      mov rsi, r15  
      call memcpy wrt ..plt
      sub rax, 16
   
      mov [rel wskaznik], rax

      mov r10, [rel stos]
      inc r10
      mov [rel stos], r10
  
      mov r10, 0
      call STATUS
      mov rax, 0
      ret

  
top_length:
      mov r9, [rel stos]
      cmp r9, 0
      je ERROR2

      mov r10, 0
      call STATUS
             
      mov r8, [rel wskaznik]
      add r8, 8    ; tutaj nalezy to skasowac
      mov rax, [r8]
      ret
 
pop:
      mov r8, [rel stos]
      cmp r8, 0
      je ERROR3 ; blad error 3 !!!!!

      test rdi, rdi
      jz ERROR1 ; blad error 1 !!!!

      mov r8, [rel wskaznik]
      mov r10, [r8]
      mov [rel tmp], r10

      mov rdx, [r8+8]              
      add r8, 16   
      mov rsi, r8      
      call memcpy wrt ..plt
      mov rdi, [rel wskaznik]   
      call free wrt ..plt   
      ;sub r8, 16   
      mov r10, [rel tmp]
      mov [rel wskaznik], r10		
      mov rdi, rax

      mov r10, [rel stos]
      dec r10
      mov [rel stos], r10

      mov r10, 0
      call STATUS
      mov rax, 0
      ret

count:
      mov r10, 0
      call STATUS
      mov rax, [rel stos]
      ret


ERROR1:
      mov r10, 2
      call STATUS
      mov rax,-1
      ret
ERROR2:
      mov r10, 1
      call STATUS
      mov rax,-1
      ret
ERROR3:
      mov r10, 1
      call STATUS
      mov rax,-1
      ret
ERROR4:
      mov r10, 3
      call STATUS
      mov rax,-1
      ret


SECTION .bss

dlugosc:	 resq 1
sstatus: 	 resq 1
stos:            resq 1
wskaznik:        resq 1
tmp:	         resq 1
tmp2:            resq 1


