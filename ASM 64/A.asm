BITS 64
SECTION .text

GLOBAL sort

sort:
; wskaznik do tablicy w rdi
; dlugosc w rsi
	
	dec rsi
	mov r9, 0
	mov r10, rsi
	; r9 - left, r10 - right
QuickSort:
	cmp r9, r10
	JNL Quit
	mov r14, r9 ; m
	mov r11, r9 ; i
For:
	inc r11
	cmp r11, r10 ; i<=prawego
	JG QuitFor
	mov r12, [rdi+r11*8]; if(tab[i]<tab[lewy])
	cmp r12, [rdi+r9*8]
	JNB For
		inc r14
		mov r12, [rdi+r11*8];
		mov r13, [rdi+r14*8]

		mov [rdi+r11*8], r13		
		mov [rdi+r14*8], r12
		JMP For 	
QuitFor:
		mov r12, [rdi+r9*8];
		mov r13, [rdi+r14*8]

		mov [rdi+r9*8], r13		
		mov [rdi+r14*8], r12
		push r9
		push r10
		push r14
		mov r10, r14
		dec r10
		call QuickSort
		pop r14
		pop r10
		pop r9
		mov r9, r14
		inc r9
		call QuickSort 			
Quit:
	ret
