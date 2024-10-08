org 0h

jmp main

org 0Bh

jmp handle_timer0_int

org 32h

main:
	; rodar timer 0 em modo 1
	MOV TMOD, #00000001b
	; iniciar timer 0
	MOV TCON, #00010000b
	; habilitar interrupsores
	; e habilitar interrupsor timer 0
	MOV IE, #10000010b

	MOV R0, #0
	MOV R1, #4
	MOV R7, #3	
	MOV R6, #0

main_loop:
	LJMP main_loop

increment_and_print:
	INC R0

	CJNE R0, #0Ah, not_exceded
	MOV R0, #0
	not_exceded:


	ACALL out_7seg
	
	RET

pulse_accordingly:
	;if P2.0 on
	JB P2.0, else_if
	
	ACALL increment_and_print

	RET
	else_if:
	;else if P2.1 on
	JB P2.1, else
	;only increment and print if r1 = 0
	DJNZ R1, r1_not_0
	
	MOV R1, #4
	ACALL increment_and_print
	
	r1_not_0:
	RET
	else:
	;else

	RET

handle_timer0_int:
	DJNZ R7, r7_not_0
	;bellow executes if R7 = 0	

	PUSH ACC ;save ACC to stack
	MOV A, R6
	JNZ remainder_handled

	MOV TH0, #02Fh
	MOV TL0, #07Eh
	MOV R7, #1
	MOV R6, #1

	POP ACC

	RETI

remainder_handled:
	MOV R6, #0
	MOV R7, #3

	; do some actual stuff here!!
	ACALL pulse_accordingly

	POP ACC
	RETI

	
r7_not_0:
	RETI

; aceita numero de 0 a 9 a ser impresso
; no registrador R0
out_7seg:
	CJNE R0, #0, out_7seg_1
	MOV P1, #11000000b
	RET
out_7seg_1:
	CJNE R0, #1, out_7seg_2
	MOV P1, #11111001b
	RET
out_7seg_2:
	CJNE R0, #2, out_7seg_3
	MOV P1, #10100100b
	RET
out_7seg_3:
	CJNE R0, #3, out_7seg_4
	MOV P1, #10110000b
	RET
out_7seg_4:
	CJNE R0, #4, out_7seg_5
	MOV P1, #10011001b
	RET
out_7seg_5:
	CJNE R0, #5, out_7seg_6
	MOV P1, #10010010b
	RET
out_7seg_6:
	CJNE R0, #6, out_7seg_7
	MOV P1, #10000010b
	RET
out_7seg_7:
	CJNE R0, #7, out_7seg_8
	MOV P1, #11111000b
	RET
out_7seg_8:
	CJNE R0, #8, out_7seg_9
	MOV P1, #10000000b
	RET
out_7seg_9:
	CJNE R0, #9, out_7seg_big
	MOV P1, #10010000b
	RET
out_7seg_big:
	MOV P1, #11111111b
	RET
