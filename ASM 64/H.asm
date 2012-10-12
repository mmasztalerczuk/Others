BITS 64
; Mariusz Krzysztof Masztalerczuk mariusz.masztalerczuk@uj.edu.pl

GLOBAL run
GLOBAL th_getid
GLOBAL th_create
GLOBAL th_yield
GLOBAL th_exit

SECTION .text

Exit:
ret

th_getid:
    mov rax,    qword [aktalny_wate]
ret

th_yield:
    mov r10, qword [pier]
    mov rax, qword [memory_th+8*r10]
    inc r10
    and r10, 255
    mov qword [pier], r10
    dec qword [spoky]
    mov qword [stos_rbx+rax*8], rbx
    mov qword [stos_rbp+rax*8], rbp
    mov qword [stos_r12+rax*8], r12
    mov qword [stos_r13+rax*8], r13
    mov qword [stos_r14+rax*8], r14
    mov qword [stos_r15+rax*8], r15
    
    mov rcx, rsp
    mov rcx, [rcx]
    mov qword [stos+8*rax], rcx
    mov rdi, rax
    mov r8, qword [last]
    inc r8
    and r8, 255
    mov qword [last], r8
    mov qword [memory_th+r8*8], rdi
    inc qword [spoky]

    jmp run
ret

th_exit:
    mov r10, qword [aktalny_wate]
    mov qword [stos+8*r10],   0

    mov r8, qword  [pier]
    mov rax, qword [memory_th+8*r8]
    inc r8
    and r8, 255
    mov qword [pier], r8
    dec qword [spoky]
    dec qword [zarejstrowane_watki]
    cmp qword [spoky], 0
    cmove r15, qword [register]
    cmove r14, qword [register+8]
    cmove r13, qword [register+16]
    cmove r12, qword [register+24]
    cmove rbp, qword [register+32]
    cmove rax, qword [register+40]
    cmove rbx, qword [register+48]
    cmove rcx, qword [register+56]
    cmove rdx, qword [register+64]
    cmove rsp, qword [register+72]
    je Exit

    jmp run
ret
th_create:
    mov rax, -1
    cmp qword [zarejstrowane_watki], 256
    je Exit
    inc qword [zarejstrowane_watki]

    look_for_free_space:
	inc qword [ilosc_watkow]
	and qword [ilosc_watkow], 255
	mov r12, qword [ilosc_watkow]
	cmp qword [stos+8*r12], 0
    jne look_for_free_space
    inc qword [spoky]
    mov qword [stos+r12*8],     rdi
    mov qword [stos_rdi+r12*8], rsi
    mov qword [stos_rsi+r12*8], rdx
    mov qword [stos_rbx+r12*8], rbx
    mov qword [stos_rbp+r12*8], rbp
    mov qword [stos_r12+r12*8], r12
    mov qword [stos_r13+r12*8], r13
    mov qword [stos_r14+r12*8], r14
    mov qword [stos_r15+r12*8], r15
    mov r10, qword [ilosc_watkow]
    
    inc qword [last]
    mov r9,        qword [last]
    and r9, 255
    mov qword [memory_th+8*r9], r10
    mov qword [last], r9
    
    mov rax, qword [ilosc_watkow]
ret
                                  
Test:
    cmp qword [iterator], 0
    jne Correct
    Napraw:
    mov qword [iterator],       1
    mov qword [register],    r15
    mov qword [register+8],  r14
    mov qword [register+16], r13
    mov qword [register+24], r12
    mov qword [register+32], rbp                                                                   
    mov qword [register+40], rax
    mov qword [register+48], rbx
    mov qword [register+56], rcx
    mov qword [register+64], rdx
    mov qword [register+72], rsp
    jmp Correct

run:
    cmp qword [ilosc_watkow], -1
    je Exit
    jmp Test
Correct:
    mov r8   ,  0
    mov r10  ,      1
    cmp qword [spoky], 0
    cmove rax,     r10
    cmovne rax, r8
    cmp rax,      1
    je Exit
    mov r8,  qword [pier]
    mov rax, qword [memory_th+8*r8]

    mov rbx, qword [stos_rbx+rax*8]
    mov rbp, qword [stos_rbp+rax*8]
    mov r12, qword [stos_r12+rax*8]
    mov r13, qword [stos_r13+rax*8]
    mov r14, qword [stos_r14+rax*8]
    mov r15, qword [stos_r15+rax*8]

    mov rdi, qword [stos_rdi+rax*8]
    mov rsi, qword [stos_rsi+rax*8]
    push rax
    mov r8, 65536
    inc rax
    mul r8

    lea r8, [memory]
    add r8, rax
    pop rax

    mov rsp, r8
    mov qword [aktalny_wate], rax

    jmp [stos+8*rax]
SECTION .data
ilosc_watkow:        dq -1
aktalny_wate:        dq 0
pier:                dq 0
last:                dq 255
spoky:               dq 0
iterator:            dq 0
zarejstrowane_watki: dq 0
SECTION .bss
memory:              resb 16842752
stos:                resq 256
stos_rdi:            resq 256
stos_rsi:            resq 256
stos_rbx:            resq 256
stos_rbp:            resq 256
stos_r12:            resq 256
stos_r13:            resq 256
stos_r14:            resq 256
stos_r15:            resq 256
memory_th:           resq 256
register:            resq 16
