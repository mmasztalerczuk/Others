BITS 64
; DO SPRAWDZENIA 32k cykli
GLOBAL ctor ; konstruktor bez argumentowy
%macro save 0
  pushf
  push    r15
  push    r14
  push    r13
  push    rbp
  push    r12
  push    rax
  push    rbx
  push    rcx
  push    rdx
%endmacro

%macro load 0
  pop     rdx
  pop   rcx
  pop     rbx
  pop     rax
  pop     r12
  pop     rbp
  pop     r13
  pop     r14
  pop     r15
  popf
%endmacro

SECTION .text



ctor:
      save
        ;;;;;;;;;;;;;    - usuniecie zer.
      push rdi

      mov r9, 0x3030303030303030
      movq xmm3, r9
      mov r9, 0x2727272727272727
      movq xmm4, r9
      pxor xmm5, xmm5
      mov r10, 0
      mov r11, [rdi+8]
      mov r12, rdi
      mov r15, rsi
FromAsciiToHex:
tmp:
      movq xmm1, [rsi]

      pcmpeqb xmm1,xmm5
      pmovmskb eax, xmm1
      mov r13, rax
      movq xmm1, [rsi]

      psubusb xmm1, xmm3      ;
      movq    xmm2, xmm1
      psubusb xmm2, xmm4      ;   a-f 0x0 gdzie byly liczby

      movq    xmm6, xmm2
      pcmpeqb xmm2, xmm5
      pand    xmm1, xmm2
      pmaxub  xmm1, xmm6

      movq    rax, xmm1
      mov     rdi, 0
      mov     rdx, 0

      mov     dl, al
        shl   rdx, 4
      mov     dil, dl
      shl     rdi, 4
      shr     rax, 8
      mov     dl, al
        shl   rdx, 4
      mov     dil, dl
      shl     rdi, 4
      shr     rax, 8
      mov     dl, al
        shl   rdx, 4
      mov     dil, dl
      shl     rdi, 4
      shr     rax, 8
      mov     dl, al
        shl   rdx, 4
      mov     dil, dl
      shl     rdi, 4
      shr     rax, 8
      mov     dl, al
        shl   rdx, 4
      mov     dil, dl
      shl     rdi, 4
      shr     rax, 8
      mov     dl, al
        shl   rdx, 4
      mov     dil, dl
      shl     rdi, 4
      shr     rax, 8
      mov     dl, al
        shl   rdx, 4
      mov     dil, dl
      shl     rdi, 4
      shr     rax, 8
      mov     dl, al
        shl   rdx, 4
      mov     dil, dl
      shl     rdi, 4
      shr     rax, 8

      shr     rdi, 8  ; wynik

      mov     [rsi], rdi

      mov rax, r13
      test    al,    al
      jnz End

      add     rsi,    8
      add     r11,    8
      add     r10,    8
      jmp FromAsciiToHex
End:
      mov rdi, r12
      bsf     rax,    rax
      add     r10,    rax
      mov     r14,    r10
      mov     rdi, r12
      cmp     r10, 0
      JE     Zero
      mov rsi, r15
      mov r15, r10
      shr r15, 3
      mov r14, r15
      shl r15, 3
      mov r12, r10
      sub r12, r15    ; ile brakuje

      shr r10, 4

      cmp r12, 0
      JNE add
roll:
      mov [rdi], r10
      mov rdi, [rdi+8]

      mov r15, 0


      mov rcx, 8
      sub rcx, r12

      mov rdx, r12


      mov r8, 16
      sub r8, rcx

      shl rcx, 2
      shl rdx, 2
      shl r8,  2
      mov r9, rcx
takesomeCrime:
      mov rcx, r9
      mov r12, [rsi+r14*8]
      shr r12, cl
      mov [rdi+r15*8], r12
      dec r14                         ; rcx
                                      ; rdx
                                      ; r8
      cmp r14, -1
      JE spoky

      mov rcx, rdx


      mov r12,         [rsi+r14*8]
      shl r12,         cl
      add [rdi+r15*8], r12

      mov rcx, r8


      dec r14

      cmp r14, -1
      JE spoky

      mov r12,         [rsi+r14*8]
      shl r12,         cl
      add [rdi+r15*8], r12


      mov r13, [rdi+r15*8]
      inc r15
      jmp takesomeCrime
spoky:
      


;     mov r13, [rdi+r15*8]
      pop rdi
      push rdi
      mov r13, [rdi]
      mov rdi, [rdi+8]
      mov r13, [rdi+253*8]
      mov r13, [rdi+252*8]
      mov r13, [rdi+251*8]
      mov r13, [rdi+250*8]

dz:
      cmp QWORD [rdi+r15*8], 0
      jne okk
      dec r15
      jmp dz

okk:
      mov r13, [rdi+r15*8]
      pop rdi
      inc r15
      mov [rdi], r15
      

      load
      ret

Zero:
      mov QWORD [rdi], 0
;     mov r11, [rdi+8]
;     mov QWORD [r11], 0

      pop   rdi
      load
      ret
add:
      inc r10
      jmp roll
SECTION .data
SECTION .bss
