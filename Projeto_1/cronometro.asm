; mudar origem para 00, executado quando o processador reinicia
org 0h
; pulo para funcao main
jmp main
; mudar origem para 08h, posicao do interrupsor de clock 0
org 0Bh
; pulo para funcao executada na interrupcao 
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

	;inicializar registradores
	MOV R0, #0
	MOV R1, #4
	MOV R7, #3	
	MOV R6, #0

	;rodar em loop
main_loop:
	LJMP main_loop

; funcao para incrementar r0 e imprimir seu valor no display de 7 segmentos
; automaticamente reinicia r0 para 0 quando seu valor atinge 10
increment_and_print:
	; incrementar r0 
	INC R0

	; comparar com o valor 10 para decidir se deve reiniciar
	CJNE R0, #0Ah, not_exceded
	; se r0 = 10, reiniciar para r0 = 0
	MOV R0, #0
	not_exceded:

	; imprimir para display de 7segmentos 
	ACALL out_7seg
	
	; encerrar funcao
	RET

; Incrementar e imprimir de acordo com a especificacao do trabalho. Esta funcao
; e chamada a cada 0,25 s, entao deve incrementar uma vez por chamada quando sw0
; esta ativado e uma vez a cada quatro chamadas quando sw1 esta ativado.
pulse_accordingly:
	;if P2.0 ativado
	JB P2.0, else_if
	
	;incrementar e imprimir se sw0
	ACALL increment_and_print

	;encerrar funcao
	RET
	else_if:
	;else if P2.1 ativado
	JB P2.1, else
	;incrementar apenas se r1 = 0
	;decrementar r1 e pular se nao 0
	DJNZ R1, r1_not_0
	; caso 0, reiniciar r1 para 4 e chamar increment_and_print
	MOV R1, #4
	ACALL increment_and_print
	
	r1_not_0:
	; apenas encerrar funcao 
	RET
	else:
	;else

	; encerrar funcao caso nenhuma chave esteja ativa
	RET

; Como ocorre interrupsor do valor de clock no overflow do valor 65535 para 0,
; ocorre delay de apenas 65,536 ms entre interrupcoes. A fim de esperar 0,25 s
; entre chamadas da funcao pulse_accordingly, e necessario esperar 250000 ciclos
; de maquina, o que significa 3 interrupcoes de clock + 53392 pulsos
handle_timer0_int:
	; decrementar r7 e encerrar caso nao seja 0 
	DJNZ R7, r7_not_0
	; codigo abaixo executa se R7 = 0 (ou seja, apenas apos 3 interrupcoes de
	; clock)

	PUSH ACC ;salvar ACC na stack
	MOV A, R6 ;mover R6 para ACC
	; reiniciar registradores e executar pulse_accordingly caso ja tenha
	; esperado o resto. caso contrario, carregar valores customizados para os
	; registradores de clock a fim de esperar o resto
	JNZ remainder_handled

	MOV TH0, #02Fh
	MOV TL0, #07Eh
	MOV R7, #1
	MOV R6, #1

	POP ACC

	RETI

remainder_handled:
	; reiniciar valores dos registradores
	MOV R6, #0
	MOV R7, #3

	; chamar a funcao que realmente faz o trabalho
	ACALL pulse_accordingly

	; recuperar ACC da pilha
	POP ACC
	; retornar da interrupcao
	RETI

	
r7_not_0:
	; apenas retornar da interrupcao
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
