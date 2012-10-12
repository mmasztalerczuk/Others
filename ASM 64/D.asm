      BITS 64

GLOBAL _ZN7NaturalC1Ev ; konstruktor bez argumentowy
GLOBAL _ZN7NaturalC1EPKc ; konstruktor z const char*
GLOBAL _ZN7NaturalC1ERKS_ ; konstruktor kopiujacy :)
GLOBAL _ZN7NaturalC1Em ; konstruktor unsigned long int

GLOBAL _ZNK7Natural4SizeEv ; Size()
GLOBAL _ZNK7Natural5PrintEv ; Wypisywanie
GLOBAL _ZN7NaturalD1Ev ; destruktor
GLOBAL _ZNK7NaturaleqERKS_ ; porownanie
GLOBAL _ZN7NaturalaSERKS_ ; przypisanie
GLOBAL _ZNK7NaturalltERKS_ ; <

GLOBAL _ZN7NaturalppEv
GLOBAL _ZN7NaturalmLERKS_
GLOBAL _ZN7NaturalpLERKS_

SECTION .text

extern malloc
extern printf
extern free
extern realloc
%macro save 0
  pushf
  push    rbp
  ;mov     rbp, rsp
  push    r12
  push    rbx
  push    rcx
  push    rdx
  push    r13
  push    r14
  push    r15
%endmacro

%macro load 0
  pop     r15
  pop     r14
  pop     r13
  pop     rdx
  pop     rcx
  pop     rbx
  pop     r12
  pop     rbp
  popf
%endmacro


_ZNK7NaturalltERKS_:
      save
errno:
      mov [structure], rdi
      mov [structure2], rsi

      mov r10, [rdi]
      mov r11, [rsi]

      cmp r10, r11
      JA qchange
      cmp r10, r11
      JB wquit

      mov r9, r10
      mov r10, [rdi+8]
      mov r11, [rsi+8]

      dec r9

      eeq:
      cmp r9, 0
      JE tqchange

      mov r12, [r10+r9*8]
      mov r13, [r11+r9*8]
      cmp r12, r13
      JA qchange
      cmp r12, r13
      JB wquit
      dec r9
      jmp eeq
tqchange:
      mov r12, [r10+r9*8]
      mov r13, [r11+r9*8]
      cmp r12, r13
      JAE qchange

      wquit:
      mov rax, 1
      load
      ret

_ZN7NaturalC1Ev:                ; konstruktor bez argumentowy
      save
Zero:
      mov [structure], rdi
      mov r10, 1
      mov [rdi], r10          ; jeden blok

      mov rdi, 8
      call malloc             ; allokacja 8 bitow

      mov r10, 0
      mov [rax], r10          ; przypisanie 0
      mov rdi, [structure]
      mov [rdi+8], rax        ; podpiecie zalokowanej pamieci

      load
      ret
IsZero:
      mov rdi, [structure]
      jmp Zero ; konstruktor bez argumentowy

qchange:
      mov rax, 0
      load
      ret

_ZNK7NaturaleqERKS_:
      save
      mov [structure], rdi
      mov [structure2], rsi

      mov r10, [rdi]
      mov r11, [rsi]

      cmp r10, r11
      JNE qchange
      mov r9, r10


      mov r10, [rdi+8]
      mov r11, [rsi+8]

      dec r9

      eq:
      cmp r9, -1
      JE qquit

      mov r12, [r10+r9*8]
      mov r13, [r11+r9*8]
      cmp r12, r13
      JNE qchange
      dec r9
      jmp eq

      qquit:
      mov rax, 1
      load
      ret

_ZN7NaturalC1EPKc:            ; konstruktor z const char*
      save
      mov [structure], rdi

      lea r9, [rsi]
      mov rsi, r9
        mov rax, rsi
        dec rax
        deleteZero:
        inc rax
        mov rcx, [rax]
        cmp cl, 48
        JE deleteZero
er:
      mov     rsi, rax
      mov     [string], rsi    ; string bez 0 wiodacych
      mov     rdi, rsi
        sub     rcx, rcx
        not     rcx
        sub     al, al
        cld
        repne   scasb
        not     rcx
        dec     rcx           ; w rcx mam dlugosc string'a
      mov     [size], rcx

      cmp     rcx, 0
      JE      IsZero
      dec     rcx             ; obnizamy o 1 do malloka
      shr     rcx, 4

      inc     rcx             ; bo liczymy od 0
      mov     [block], rcx    ; zapisz sobie ile masz blokow
      shl     rcx, 3          ; zaokragalmy do pelnej wielokrotnosci  8

      mov     rdi, rcx        ; alokacja !
      call    malloc
tmt:
      mov     [memory], rax
      mov     rdi, [structure]
      mov     r10, [block]
      mov     [rdi], r10      ; wpisanie ile blokow w nowej strukturze jest

      mov     r10, [size]
      sub     r9, r9
      mov     rsi, [string]

      dec r10

      loopBlock:
      mov     r11, 0
      mov     r12, 0
      mov     r13, 0
      loopASCII:
      cmp     r10,    -1
      JE      saveblockANDquit
      cmp     r11,    16
      JE      saveblock
      mov     rdi, [rsi+r10]
      sub     rax, rax
      mov     al, dil
      jmp     convert
      back:
      mov rdi, 0
        mov rcx, r13
        shl rax, cl
        add r13, 4
        add r12, rax
        inc r11
        dec r10
      jmp loopASCII
saveblock:
        mov rax, [memory]
        mov [rax+r9*8], r12
        inc r9
        jmp loopBlock
saveblockANDquit:
        mov rax, [memory]
        mov [rax+r9*8], r12
        mov rdi, [structure]
qtmp:
        mov [rdi+8], rax

      load
      ret
_ZN7NaturalC1ERKS_:           ; konstruktor kopiujacy
      save
      mov [structure], rdi
      mov [structure2], rsi

      mov rdi, [rsi]          ; ilosc blokow w rsi
      shl rdi, 3              ; pomnozenie razy 8
      call malloc             ; alokacja

      mov rdi, [structure]
      mov rsi, [structure2]
      mov r10, [rsi]          ; ilosc blokow jeszcze raz

      mov [rdi+8], rax        ; podpiecie pamieci
      mov [rdi], r10          ; ilosc blokow

      mov r9, 0
      mov rsi, [rsi+8]        ; przekopiowanie wskanizka do blokow


      loop2:
      cmp r9, r10
      JE quit2
      mov r11, [rsi+r9*8]
      mov [rax+r9*8], r11
      inc r9
      jmp loop2

      quit2:
      load
      ret


_ZN7NaturalC1Em:              ; konstrukor u long int
      save
      mov [structure], rdi
      mov [block],     rsi

      mov r10, 1              ; wielkosc blokow
      mov [rdi], r10

      mov rdi, 8              ; zalokowanie pamieci
      call malloc

      mov rdi, [structure]    ; wpisanie liczby do pamieci
      mov r10, [block]
      mov [rax], r10
      mov [rdi+8], rax

      load
      ret


ZeroAns:
        mov rax, 0
        load
        ret


_ZNK7Natural4SizeEv:
      save
      mov [structure], rdi
      mov r10, [rdi]          ; ilosc blokow 64 bitowych

      dec r10                 ; zmiejszamy o jeden, numeracja od 0.

      mov r11, [rdi+8]
      mov r11, [r11]
      cmp r11, 0
      JE ZeroAns
      mov rcx, r10
      mov r11, [rdi+8]
      mov r13, [r11+r10*8]
      bsr rax, r13
      inc rax
      shl rcx, 6       	
      add rax, rcx
      load
      ret

_ZNK7Natural5PrintEv:
      save
tmp:
      mov [structure], rdi    ;
      mov r10, [rdi]          ; ilosc blokow
      mov r11, [rdi+8]
      dec r10                 ; klasyk


      mov rsi, [r11+r10*8]
      xor rax, rax
      mov rdi, formatB
      dec r10
      push r10
      push r11
      call printf
tmp2:
      pop r11
      pop r10
      loop5:
      cmp r10, -1
      JE quit5
      mov rsi, [r11+r10*8]
      xor rax, rax
      mov rdi, formatA
      dec r10
      push r10
      push r11
      call printf

      pop r11
      pop r10
      jmp loop5
quit5:

;     xor rax, rax
;     mov rdi, enter
;     call printf

      load
      ret

_ZN7NaturalD1Ev:
      save
      mov rdi, [rdi+8]
      call free
      load
        ret

convert:              ; convertuje z ascii na normalne liczby
        sub al, 48
        cmp al, 10
        JB back
        sub al, 39
      jmp back

_ZN7NaturalaSERKS_:
      save
      mov [structure], rdi
      mov [structure2], rsi

      mov r10, [rsi+8]
      mov r11, [rdi+8]
      cmp r10, r11
      JE quit6

      mov rdi, [rdi+8]
      call free

      mov rdi, [structure]
      mov rsi, [structure2]

      mov rdi, [rsi]          ; ilosc blokow w rsi
      shl rdi, 3              ; pomnozenie razy 8
      call malloc             ; alokacja

      mov [memory], rax
      mov rdi, [structure]
      mov rsi, [structure2]

      mov r10, [rsi]
      mov [rdi], r10
      mov [rdi+8], rax

      dec r10

      mov rsi, [rsi+8]
      mov rdi, [rdi+8]
      loop6:
      cmp r10, -1
      JE quit6
      mov r11, [rsi+r10*8]
      mov [rdi+r10*8], r11
      dec r10
      jmp loop6
      quit6:
      mov rdi, [structure]
      load
      mov rax, rdi
      ret

change:
      mov rsi, rdi
      mov rdi, [structure2]
      jmp afterchange

alokuj:
      push r11
      inc r11
      mov [size], r11         ; jeden blok wiecej
      mov rdi, r11
      shl rdi, 3
      call malloc
b3:
      mov rdi, [memory]
      mov r13, 1
      pop r11
      mov [rax+r11*8], r13
      dec r11
      loopalokuj:
      cmp r11, -1
      JE poalokacji
      mov r13, [rdi+r11*8]
      mov [rax+r11*8], r13
      dec r11
      jmp loopalokuj
poalokacji:
      mov [memory], rax
      call free
b4:
      jmp rreturn


_ZN7NaturalpLERKS_:
      save
b1:
      mov [structure], rdi
      mov [structure2], rsi
      mov r10, [rdi]
      mov r11, [rsi]
      mov r9,  [rsi+8]
      mov r9,  [r9]
      cmp r10, r11            ; sprawdzanie co wieksze
      JA change
      afterchange:
      mov r11, [rsi]          ; w r11 mam wieksza liczbe
      mov [size], r11
      push rdi
      push rsi
      shl r11, 3
      mov rdi, r11
      call malloc
b2:
      mov [memory], rax       ; pamiec pod nowa liczbe
      pop rsi
      pop rdi                 ; przywrocenie rdi, i rsi
      mov r10, [rdi]
      mov r11, [rsi]          ; wieksza liczba

      mov r12, 0
      mov rdi, [rdi+8]
      mov rsi, [rsi+8]

      mov rax, [memory]
      mov r13, 0
      loopAdd1:
      cmp r12, r10
      JE breakloopAdd1
      add r13, [rsi+r12*8]
      mov r14, [rdi+r12*8]
      add r13, r14
      mov [rax+r12*8], r13
      mov r13, 0
      adc r13, 0
      inc r12
      jmp loopAdd1
      breakloopAdd1:
      loopAdd2:
      cmp r12, r11
      JE breakloopAdd2
      add r13, [rsi+r12*8]
      mov [rax+r12*8], r13
      mov r13, 0
      adc r13, 0
      inc r12
      jmp loopAdd2
      breakloopAdd2:
      cmp r13, 1
      JE alokuj
      rreturn:
      mov rdi, [structure]
      mov r13, [memory]
      mov rsi, [rdi+8]
      mov [rdi+8], r13
      mov r13, [size]
      mov [rdi], r13
      mov rdi, rsi
      call free
b5:
      mov rax, [structure]
      mov r13, [rax]
      mov r14, [rax+8]
      mov r13, [r14]
      mov r13, [r14+8]
      load
      mov rax, [structure]
      ret
_ZN7NaturalmLERKS_:
      save

      mov [structure], rdi
      mov [structure2], rsi
      mov r10, [rdi]
      mov r11, [rsi]

      mov r14, [rdi+8]
      mov r14, [r14]
      cmp r14, 0
      JE PrevZero
      mov r14, [rsi+8]
      mov r14, [r14]
      cmp r14, 0
      JE PrevZero




      mov rdi, r10
      add rdi, r11

      shl rdi, 3
      call malloc
mul1:
      mov [memory], rax

      mov rdi, [structure]
      mov rsi, [structure2]
tqr:
      mov r10, [rdi]
      mov r11, [rsi]

      mov rdi, r10
      add rdi, r11

      mov r12, 0
      loopmul3:
      cmp r12, rdi
      JE  quitloopmul3
      mov QWORD [rax+r12*8], 0
      inc r12
      jmp loopmul3
      quitloopmul3:
mul2:
      mov rdi, [structure]
      mov rsi, [structure2]
      mov r10, [rdi]
      mov r11, [rsi]



      mov r9, r10
      add r9, r11
      mov [rdi], r9           ; size

      mov rdi, [rdi+8]
      mov rsi, [rsi+8]
      mov r14, [memory]

      mov r8, 0
      mov r12, 0
      mov rdx, 0      ;       carry
      loopmul1:
      mov rdx, 0
      cmp r11, r8
      JE breakloop1
      mov r12, 0
      loopmul2:
      cmp r10, r12
      JE breakloop2

      mov rax, [rdi+r12*8]
      mov r15, [rsi+r8*8]

      mov r13, rdx
      mul r15
                      ; w rdx mam kolejne carry

      add rax, r13    ; carry dodaje

      adc rdx, 0      ; rdx = rdx + 0 + CF flag
      clc
      mov r9, r8
      add r9, r12
      clc
      add [r14+r9*8], rax     ; zapisuje
      adc rdx, 0
      clc

      inc r12
      jmp loopmul2
      breakloop2:
      inc r9
      add [r14+r9*8], rdx
      inc r8
      jmp loopmul1
      breakloop1:
mul3:
      ;cmp r13, 0
      ;JE withOutCarry
      ;mov r9, r10
      ;add r9, r11
      ;dec r9
      ;mov [r14+r9*8], r13
withOutCarry:
      mov rdi, [structure]
      mov r13, [memory]
      mov r12, [rdi]
      dec r12
      deletezeros:
      cmp r12, -1
      JE allzero
      mov r14, [r13+r12*8]
      cmp r14, 0
      JNE quitmulA
        dec r12
      jmp deletezeros
quitmulA:
      inc r12
      cmp r12, [rdi]
      JNE deMallok
quitmul:
mul4:
      mov rdi, [structure]
      mov [rdi], r12

      mov r14, [memory]
      mov r15, [rdi+8]                ; do skasowania pamiec
      mov [rdi+8], r14

      mov rdi, r15
      call free

      load
      mov rax, [structure]
      ret

allzero:
      mov r12, 1
      jmp quitmul

_ZN7NaturalppEv:
      save
      mov [structure], rdi

      mov rdi, 32
      call malloc
u:
      mov [block], rax
      mov [memory], rax
      add rax, 16

      mov [structure2], rax
      mov QWORD [rax], 1

      mov r9, [memory]
      mov [rax+8], r9
      mov rsi, rax
      mov rdi, [structure]
u1:
      mov r9, [rsi]
      mov r9, [rsi+8]
      mov QWORD [r9], 1

      call _ZN7NaturalpLERKS_
u2:
      mov [size], rax
      mov rdi, [block]
      call free
      load
      mov rax, [size]
      ret


deMallok:
      push r12
      ;inc r12
      mov rdi, [structure]
      mov rdi, [rdi]
      mov r13, [memory]
      mov rdi, r13
      mov rsi, r12
      shl rsi, 3
      call realloc
      pop r12
      jmp quitmul

PrevZero:
      mov rdi, [structure]
      mov rdi, [rdi+8]
      call free
      mov rdi, [structure]
      jmp Zero


SECTION .data
formatA:      db "%016lx",0
formatB:      db "%lx",0
SECTION .bss
structure:                  resb 8 ; tymczasowa zmienna do trzymania struktury
structure2:           resb 8 ; tymczasowa zmienna do trzymania struktury do skopiowania
string:               resb 8 ; wskaznik do const char*
block:                resb 8 ; liczba blokow 64 bitowuch
size:                 resb 8 ; dlugosc stringa
memory:               resb 8 ; wskaznik do pamieci
