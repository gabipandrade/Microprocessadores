org 0h

main:
	MOV R0, #9
	
main_loop:
	LCALL out_7seg
	DJNZ R0, main_loop
	LCALL out_7seg
	LJMP main


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
