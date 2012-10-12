BITS 64

GLOBAL _start

%define IFMT  170000q
%define IFLNK 120000q
%define IFREG 100000q
%define IFDIR  40000q
%define IRUSR 400q
%define IWUSR 200q
%define IXUSR 100q
%define IRGRP 40q
%define IWGRP 20q
%define IXGRP 10q
%define IROTH 4q
%define IWOTH 2q
%define IXOTH 1q

SECTION .text
print:
	mov rax, 1
	mov rdi, 1
	mov rsi, r8
	mov rdx, r9
	syscall
	ret
Quit:
	mov rax, 60
	mov rdi, 0
	syscall
	ret
InCorrectValue:
	mov r8, msg1
	mov r9, lenmsg1
	call print
	jmp Quit
	ret
getdents:
	mov r13, 0

	mov rax, 78
	mov rdi, [des]
	mov rsi, buffor
	mov rdx, 4096
	syscall

	mov r15, rax
	test rax, rax
	js NoDir

	cmp rax,0
	jz Quit

	loop:
	cmp r13, r15
	jae getdents
	call printfiles

        mov r14, [buffor+16+r13]
	and r14, 0x0000FFFF
	add r13, r14
	jmp loop


	ret

printC:
	call print
	ret

printAccess:
	mov rcx, [stat+24]
	and rcx, r10
	cmp rcx, 0
	ja printC
	mov r8, k
	call printC
	ret


FirstAccess:
	mov r8, d

	mov rcx, [stat+24]
	and rcx, IFMT
	cmp rcx, IFDIR
	je printC

	mov r8, k

	mov rcx, [stat+24]
	and rcx, IFMT
	cmp rcx, IFREG
	je printC

	mov r8, n
	call print
	ret

printfiles:
	; najpierw stat
	lea r11, [buffor+18+r13]
	mov rax, 6
	mov rdi, r11 ; long+long+short
	mov rsi, stat
	syscall
	mov r9, 1
	call FirstAccess

	mov r9, 1

	mov r10, IRUSR
	mov r8, r
	call printAccess
	mov r10, IWUSR
	mov r8, w
	call printAccess
	mov r10, IXUSR
	mov r8, x
	call printAccess

	mov r10, IRGRP
	mov r8, r
	call printAccess
	mov r10, IWGRP
	mov r8, w
	call printAccess
	mov r10, IXGRP
	mov r8, x
	call printAccess

	mov r10, IROTH
	mov r8, r
	call printAccess
	mov r10, IWOTH
	mov r8, w
	call printAccess
	mov r10, IXOTH
	mov r8, x
	call printAccess

	mov r8, spacja
	mov r9, 1
	call print

	lea r11, [buffor+18+r13]

	mov r8, r11
	jmp getsize
tmp:

	call print

	mov r8, enter
	mov r9, enterlen
	call print
	ret

getsize:
	lea rbx, [r8+r9]
	cmp byte [rbx], 0x0
	je tmp
	inc r9
	jmp getsize
NoDir:
	mov r8, msg2
	mov r9, lenmsg2
	call print
	jmp Quit
	ret
_start:
	mov rax, 2
	mov rdi, [rsp+16]
	mov rsi, 0
	mov rdx, 0
	syscall

        test rax, rax
        js InCorrectValue

	mov [des], rax
	mov rdi, [des]
	mov rax, 81
	syscall

	call getdents

	jmp Quit


SECTION .data
msg1:
	db "No such file or directory.",10
lenmsg1: equ $-msg1
msg2:
	db "Not a directory.",10
lenmsg2: equ $-msg2
test:
	db "test",10
testlen: equ $-test

d:
	db "d"
r:
	db "r"
w:
	db "w"
k:
	db "-"
n:
	db "?"
x:
	db "x"
spacja:
	db " "
enter:
	db 10
enterlen: equ $-enter
SECTION .bss
buffor: resb 4096
des: resb 8
stat: resb 144
