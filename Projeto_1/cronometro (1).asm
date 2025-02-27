ORG 0000H ; Início do código

; Definições de pinos
SW0 EQU P2.0         ; Switch 0 - muda o atraso para 0,25s
SW1 EQU P2.1         ; Switch 1 - muda o atraso para 1s
DISPLAY EQU P1       ; Porta de exibição de 7 segmentos (conectada ao P1)

; Variáveis
DELAY_FLAG EQU 30H   ; Flag de controle de atraso (0,25s ou 1s)
COUNTING_FLAG EQU 31H ; Flag para indicar se a contagem começou (0: não começou, 1: começou)

; Inicializações
MAIN:
    MOV A, #0               ; Inicializa o contador para exibir (0 a 9)
    MOV COUNTING_FLAG, #0    ; Inicializa a flag de contagem como não iniciada

LOOP:
    ; Se a contagem não começou, aguarda até que SW0 ou SW1 seja pressionado
    MOV R3, COUNTING_FLAG
    CJNE R3, #0, COUNTING_STARTED ; Se a contagem já começou, pula para CONTAGEM_INICIADA

    ; Verifica SW0
    JNB P2.0, START_WITH_025S     ; Se SW0 for pressionado (bit 0), começa com atraso de 0,25s
    ; Verifica SW1
    JNB P2.1, START_WITH_1S       ; Se SW1 for pressionado (bit 0), começa com atraso de 1s
    SJMP LOOP                     ; Continua esperando

START_WITH_025S:
    CALL DEBOUNCE          ; Chama a rotina de debounce para evitar efeitos de rebote
    MOV DELAY_FLAG, #0      ; Define o atraso para 0,25s
    MOV COUNTING_FLAG, #1   ; Indica que a contagem começou
    SJMP LOOP

START_WITH_1S:
    CALL DEBOUNCE          ; Chama a rotina de debounce para evitar efeitos de rebote
    MOV DELAY_FLAG, #1      ; Define o atraso para 1s
    MOV COUNTING_FLAG, #1   ; Indica que a contagem começou
    SJMP LOOP

COUNTING_STARTED:
    ; Verifica se A >= 10 e redefine para 0, se necessário
    CJNE A, #10, UPDATE_DISPLAY
    MOV A, #0               ; Se A == 10, reinicia para 0

UPDATE_DISPLAY:
    ; Atualiza o display chamando a sub-rotina DISPLAY_7SEG para o valor de A
    MOV R0, A               ; Move o valor do contador para R0
    CALL DISPLAY_7SEG       ; Chama a rotina que atualiza o display

    ; Chama a rotina de atraso
    CALL DELAY_ROUTINE      ; Chama a sub-rotina de atraso para definir o tempo entre as mudanças

    ; Incrementa o contador
    INC A                   ; Incrementa o contador de 0 a 9

    SJMP LOOP               ; Retorna ao início do loop

; Sub-rotina de debounce para evitar leituras incorretas do botão
DEBOUNCE:
    MOV R1, #100            ; Ajuste o valor de acordo com o tempo de debounce desejado
DEBOUNCE_LOOP:
    DJNZ R1, DEBOUNCE_LOOP  ; Laço para esperar o tempo de debounce
    RET                     ; Retorna da sub-rotina

; Sub-rotina de atraso para ajustar o tempo de acordo com o botão pressionado
DELAY_ROUTINE:
    MOV R2, DELAY_FLAG      ; Carrega o valor da flag de atraso
    CJNE R2, #0, LONG_DELAY ; Se o valor for 1, usa o atraso longo de 1s

    ; Atraso curto (0,25s = 250ms)
    MOV R7, #50             ; 250ms / 5ms = 50 iterações
SHORT_DELAY_LOOP:
    CALL DELAY_5MS          ; Chama a rotina de atraso de 5ms
    ; Verifica os switches durante o atraso
    JNB P2.0, CHANGE_TO_025S ; Se SW0 for pressionado, altera para 0,25s
    JNB P2.1, CHANGE_TO_1S   ; Se SW1 for pressionado, altera para 1s
    DJNZ R7, SHORT_DELAY_LOOP ; Decrementa e repete até atingir 50 iterações
    RET

LONG_DELAY:
    ; Atraso longo (1s = 200 x 5ms)
    MOV R7, #200            ; 1s / 5ms = 200 iterações
LONG_DELAY_LOOP:
    CALL DELAY_5MS          ; Chama a rotina de atraso de 5ms
    ; Verifica os switches durante o atraso
    JNB P2.0, CHANGE_TO_025S ; Se SW0 for pressionado, altera para 0,25s
    JNB P2.1, CHANGE_TO_1S   ; Se SW1 for pressionado, altera para 1s
    DJNZ R7, LONG_DELAY_LOOP ; Decrementa e repete até atingir 200 iterações
    RET

CHANGE_TO_025S:
    CALL DEBOUNCE           ; Chama a rotina de debounce
    MOV DELAY_FLAG, #0      ; Define o atraso para 0,25s
    RET

CHANGE_TO_1S:
    CALL DEBOUNCE           ; Chama a rotina de debounce
    MOV DELAY_FLAG, #1      ; Define o atraso para 1s
    RET

; Rotina de atraso de 5ms
DELAY_5MS:
    MOV R1, #24             ; Ajuste estes valores de acordo com a frequência do clock para um atraso de 5ms
    MOV R0, #250
DELAY_5MS_LOOP:
    DJNZ R0, DELAY_5MS_LOOP ; Laço para criar o atraso de 5ms
    DJNZ R1, DELAY_5MS_LOOP ; Continua até esgotar o contador
    RET                     ; Retorna da rotina

; Sub-rotina para exibir números no display de 7 segmentos
DISPLAY_7SEG:
    CJNE R0, #0, DISPLAY_1  ; Compara R0 com 0, se for diferente, vai para DISPLAY_1
    MOV P1, #11000000b      ; Exibe 0 no display
    RET
DISPLAY_1:
    CJNE R0, #1, DISPLAY_2  ; Compara R0 com 1, se for diferente, vai para DISPLAY_2
    MOV P1, #11111001b      ; Exibe 1 no display
    RET
DISPLAY_2:
    CJNE R0, #2, DISPLAY_3  ; Compara R0 com 2, se for diferente, vai para DISPLAY_3
    MOV P1, #10100100b      ; Exibe 2 no display
    RET
DISPLAY_3:
    CJNE R0, #3, DISPLAY_4  ; Compara R0 com 3, se for diferente, vai para DISPLAY_4
    MOV P1, #10110000b      ; Exibe 3 no display
    RET
DISPLAY_4:
    CJNE R0, #4, DISPLAY_5  ; Compara R0 com 4, se for diferente, vai para DISPLAY_5
    MOV P1, #10011001b      ; Exibe 4 no display
    RET
DISPLAY_5:
    CJNE R0, #5, DISPLAY_6  ; Compara R0 com 5, se for diferente, vai para DISPLAY_6
    MOV P1, #10010010b      ; Exibe 5 no display
    RET
DISPLAY_6:
    CJNE R0, #6, DISPLAY_7  ; Compara R0 com 6, se for diferente, vai para DISPLAY_7
    MOV P1, #10000010b      ; Exibe 6 no display
    RET
DISPLAY_7:
    CJNE R0, #7, DISPLAY_8  ; Compara R0 com 7, se for diferente, vai para DISPLAY_8
    MOV P1, #11111000b      ; Exibe 7 no display
    RET
DISPLAY_8:
    CJNE R0, #8, DISPLAY_9  ; Compara R0 com 8, se for diferente, vai para DISPLAY_9
    MOV P1, #10000000b      ; Exibe 8 no display
    RET
DISPLAY_9:
    CJNE R0, #9, DISPLAY_OFF ; Compara R0 com 9, se for diferente, vai para DISPLAY_OFF
    MOV P1, #10010000b      ; Exibe 9 no display
    RET
DISPLAY_OFF:
    MOV P1, #11111111b      ; Desliga o display (todos os segmentos apagados)
    RET

