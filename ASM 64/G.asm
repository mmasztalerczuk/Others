BITS 64

SECTION .text

GLOBAL filter

%macro load 0
    pop r10
    pop r11
    pop r8
    pop r9
    pop rbx
    pop r12
    pop r13
    pop rcx
    pop r14
    pop r15
    pop rax
%endmacro

%macro save 0
    push rax
    push r15
    push r14
    push rcx
    push r13
    push r12
    push rbx
    push r9
    push r8
    push r11
    push r10
    Clear
%endmacro

%macro next 0
    movzx ecx, byte [rbx+r13]
%endmacro
%macro Milky 1

%assign i 0
%rep 3

    temp

%if %1 != 0 && %1 != 1 && %1 != 2
    next
    pinsrw xmm4, ecx, 0
%endif
    add r13, 3
%if %1 != 0 && %1 != 1
    next
    pinsrw xmm4, ecx, 2
%endif
    add r13, 3
%if %1 != 0 && %1 != 1 || %1 != 3
    next
    pinsrw xmm4, ecx, 4
%endif
    lea r13, [rax+i]

    sub r13, 3
%if %1 != 0 && %1 != 2
    next
    pinsrw xmm4, ecx, 6
%endif
    add r13, 3
    next
    pinsrw xmm3, ecx, 0

    add r13, 3
%if %1 != 1 && %1 != 3
    next
    pinsrw xmm3, ecx, 2
%endif
    lea r13, [rax+i]
    add r13, r9
    sub r13, 3
%if %1 != 0 && %1 != 2 && %1 != 3
    next
    pinsrw xmm3, ecx, 4
%endif
    add r13, 3

%if %1 != 2 && %1 != 3
    next
    pinsrw xmm3, ecx, 6
%endif
    add r13, 3
%if %1 != 1 && %1 != 2 && %1 != 3
    next
    pinsrw xmm5, ecx, 0
%endif
    tmp
    %assign i i+1
    %endrep

%endmacro

%macro temp 0
    subpd xmm4, xmm4
    subpd xmm3, xmm3
    subpd xmm5, xmm5
    lea r13, [rax+i]
    sub r13, r9
    sub rcx,rcx
    sub r13, 3
%endmacro


%macro Spoky 1
%assign i 0
%rep 3
    temp
%if %1 != 0 && %1 != 2
    next
    pinsrw xmm4, ecx, 0
%endif

    add r13, 3

%if %1 != 0
    next
    pinsrw xmm4, ecx, 2
%endif

    add r13, 3

%if %1 != 0 && %1 != 3
    next
    pinsrw xmm4, ecx, 4
%endif

    lea r13, [rax+i]

    sub r13, 3
%if %1 != 2
    next
    pinsrw xmm4, ecx, 6
%endif

    add r13, 3
    next
    pinsrw xmm3, ecx, 0

    add r13, 3
%if %1 != 3
    next
    pinsrw xmm3, ecx, 2
%endif
   lea r13, [rax+i]

    add r13, r9
    sub r13, 3
%if %1 != 1 && %1 != 2
    next
    pinsrw xmm3, ecx, 4
%endif
    add r13, 3
%if %1 != 1
    next
    pinsrw xmm3, ecx, 6
%endif
    add r13, 3
%if %1 != 1 && %1 != 3
    next
    pinsrw xmm5, ecx, 0
%endif
    tmp
    %assign i i+1
    %endrep

%endmacro

%macro prepare 0
    movups xmm0, [rdx]
    movups xmm2, [rdx+16]
    movups xmm1, [rdx+32]

    mov r9d, [rsi+8]
    mov r14, r9
    dec r14
    mov rax, 3
    mul r9
    mov r9, rax

    mov r8d, [rsi+12]
    dec r8
    mov rbx, [rsi]
    mov r12, [rdi]
    mov r11, 1
    mov r10, 1
    sub rcx,rcx
%endmacro

%macro insert 3
    movzx cx, byte [rbx+r13+%3]
    pinsrw %1, cx, %2
%endmacro

%macro MassInsert 0
    add rax,3

    lea r13, [rax]

    sub r13, r9
    sub rcx,rcx
    sub r13, 3

    insert xmm4, 0, 0
    insert xmm7, 0, 1
    insert xmm10, 0, 2

    add r13, 3

    insert xmm4, 2, 0
    insert xmm7, 2, 1
    insert xmm10, 2, 2

    add r13, 3

    insert xmm4, 4, 0
    insert xmm7, 4, 1
    insert xmm10, 4, 2

    lea r13, [rax]
    sub r13, 3

    insert xmm4, 6, 0
    insert xmm7, 6, 1
    insert xmm10, 6, 2

    add r13, 3
    insert xmm3,  0, 0
    insert xmm6,  0, 1
    insert xmm9, 0, 2

    add r13, 3
    insert xmm3,  2, 0
    insert xmm6,  2, 1
    insert xmm9, 2, 2

    lea r13, [rax]
    add r13, r9
    sub r13, 3

    insert xmm3,  4, 0
    insert xmm6,  4, 1
    insert xmm9, 4, 2

    add r13, 3
    insert xmm3,  6, 0
    insert xmm6,  6, 1
    insert xmm9, 6, 2

    add r13, 3
    insert xmm5,  0, 0
    insert xmm8,  0, 1
    insert xmm11, 0, 2

%endmacro
%macro pack 0
    cvtdq2ps xmm11, xmm11
    cvtdq2ps xmm10, xmm10
    cvtdq2ps xmm9, xmm9
    cvtdq2ps xmm8, xmm8
    cvtdq2ps xmm7, xmm7
    cvtdq2ps xmm6, xmm6
    cvtdq2ps xmm5, xmm5
    cvtdq2ps xmm4, xmm4
    cvtdq2ps xmm3, xmm3
%endmacro
%macro mull 0
    mulps xmm4,  xmm0
    mulps xmm7,  xmm0
    mulps xmm10, xmm0
    mulps xmm11, xmm1
    mulps xmm5,  xmm1
    mulps xmm8,  xmm1
    mulps xmm6,  xmm2
    mulps xmm9,  xmm2
    mulps xmm3,  xmm2
%endmacro

%macro adds 0
    addps xmm4, xmm3
    addps xmm4, xmm5
    haddps xmm4, xmm4
    haddps xmm4, xmm4

    addps xmm7, xmm6
    addps xmm7, xmm8
    haddps xmm7, xmm7
    haddps xmm7, xmm7

    addps xmm10, xmm9
    addps xmm10, xmm11
    haddps xmm10, xmm10
    haddps xmm10, xmm10
%endmacro

%macro write 0
    sub r13,r13
    sub rcx,rcx
    sub r15,r15

    cvttss2si ecx, xmm4
    mov r15d, 0
    cmp ecx, 0
    cmovl ecx, r15d

    mov r15d, 255
    cmp ecx, 255
    cmovnle ecx, r15d
    mov byte [r12+rax+0], cl

    sub r13,r13
    sub rcx,rcx
    sub r15,r15

    cvttss2si ecx, xmm7
    mov r15d, 0
    cmp ecx, 0
    cmovl ecx, r15d

    mov r15d, 255
    cmp ecx, 255
    cmovnle ecx, r15d
    mov byte [r12+rax+1], cl

    sub r13,r13
    sub rcx,rcx
    sub r15,r15

    cvttss2si ecx, xmm10
    mov r15d, 0
    cmp ecx, 0
    cmovl ecx, r15d

    mov r15d, 255
    cmp ecx, 255
    cmovnle ecx, r15d
    mov byte [r12+rax+2], cl
%endmacro

%macro border 0
    mov rax,   3
    mov r11,   r9
    sub r11,   5

    A:
    Spoky 0
    inc rax
    cmp rax,r11
    jb A

    mov rax, r8
    mul r9
    mov r11,rax
    add r11, r9
    sub r11,5

    add rax,3

    B:
    Spoky 1
    inc rax
    cmp rax,r11
    jb B

    mov rax, r8
    mul r9
    mov rax,r11

    mov rax,0
    add rax, r9

    C:

    Spoky 2
    add rax,r9
    cmp rax,r11
    jb C

    mov rax,0
    add rax, r9
    sub rax, 3

    D:
    Spoky 3
    add rax,r9
    cmp rax,r11
    jb D
%endmacro

%macro lastPoint 0
    mov rax,0
    Milky 0
    mov rax,r9
    sub rax,3
    Milky 1
    mov rax, r8
    mul r9
    Milky 2
    add rax, r9
    sub rax,3
    Milky 3
%endmacro

%macro Clear 0
    pxor xmm3, xmm3
    pxor xmm4, xmm4
    pxor xmm5, xmm5
    pxor xmm6, xmm6
    pxor xmm7, xmm7
    pxor xmm8, xmm8
    pxor xmm9, xmm9
    pxor xmm10, xmm10
    pxor xmm11, xmm11
%endmacro

%macro tmp 0
    cvtdq2ps xmm4, xmm4
    cvtdq2ps xmm3, xmm3
    cvtdq2ps xmm5, xmm5


    mulps xmm4, xmm0
    mulps xmm3, xmm2
    mulps xmm5, xmm1

    subpd xmm7, xmm7

    haddps xmm4, xmm3
    haddps xmm4, xmm5
    haddps xmm4, xmm7
    haddps xmm4, xmm7

    sub r13,r13
    sub rcx,rcx
    sub r15,r15

    cvttss2si ecx, xmm4

    mov r15d, 0
    cmp ecx, 0
    cmovl ecx, r15d

    mov r15d, 255
    cmp ecx, 255
    cmovnle ecx, r15d
    mov byte [r12+rax+i], cl

%endmacro
filter:
    save
    prepare

    Way:
    mov rax,r10
    mul r9
    Dance:
      Clear
      MassInsert
      pack
      mull
      adds
      write
      inc r11
    cmp r11,r14
    jb Dance
    mov r11,1
    inc r10
    cmp r10,r8
    jb Way
    border
    lastPoint

    load
    ret

