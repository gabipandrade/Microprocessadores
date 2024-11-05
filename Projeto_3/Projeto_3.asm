
_main:

;Projeto_3.c,17 :: 		void main(){
;Projeto_3.c,19 :: 		unsigned int Valor_ADC = 0;  // var. para leitura
;Projeto_3.c,23 :: 		TRISA.RA3 = 1;
	BSF         TRISA+0, 3 
;Projeto_3.c,27 :: 		Lcd_Init();                 // Inicializa a lib. Lcd
	CALL        _Lcd_Init+0, 0
;Projeto_3.c,28 :: 		Lcd_Cmd(_LCD_CLEAR);       // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Projeto_3.c,29 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);  // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Projeto_3.c,30 :: 		Lcd_Out(1,1,"ADC0:");   //Escreve na Linha x Coluna do LCD o texto(valor do ADC)
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_Projeto_3+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_Projeto_3+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Projeto_3.c,32 :: 		ADC_Init_Advanced(_ADC_EXTERNAL_VREFH);  // uso da função da biblioteca ADC do próprio compilador
	MOVLW       16
	MOVWF       FARG_ADC_Init_Advanced_reference+0 
	CALL        _ADC_Init_Advanced+0, 0
;Projeto_3.c,34 :: 		while(TRUE)
L_main0:
;Projeto_3.c,36 :: 		Valor_ADC = ADC_Get_Sample(0); // função da biblioteca ADC para leitura
	CLRF        FARG_ADC_Get_Sample_channel+0 
	CALL        _ADC_Get_Sample+0, 0
;Projeto_3.c,38 :: 		Valor_ADC = Valor_ADC * (1000/1023.); // formata o valor de entrada (neste caso o valor de exemplo '1234')
	CALL        _word2double+0, 0
	MOVLW       144
	MOVWF       R4 
	MOVLW       62
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
;Projeto_3.c,42 :: 		Tensao[0] = (Valor_ADC/1000) + '0';
	MOVLW       48
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       main_Tensao_L0+0 
;Projeto_3.c,43 :: 		Tensao[1] = (Valor_ADC/100)%10 + '0';
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_Tensao_L0+1 
;Projeto_3.c,44 :: 		Tensao[2] = (Valor_ADC/10)%10 + '0';
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_Tensao_L0+2 
;Projeto_3.c,45 :: 		Tensao[3] = '.';
	MOVLW       46
	MOVWF       main_Tensao_L0+3 
;Projeto_3.c,46 :: 		Tensao[4] = (Valor_ADC/1)%10 + '0';
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       main_Tensao_L0+4 
;Projeto_3.c,47 :: 		Tensao[5] = 'º';
	MOVLW       186
	MOVWF       main_Tensao_L0+5 
;Projeto_3.c,48 :: 		Tensao[6] = 'C';
	MOVLW       67
	MOVWF       main_Tensao_L0+6 
;Projeto_3.c,49 :: 		Tensao[7] = 0;
	CLRF        main_Tensao_L0+7 
;Projeto_3.c,53 :: 		Lcd_Out(1,6,Tensao); // Mostra os valores no display
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_Tensao_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_Tensao_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Projeto_3.c,54 :: 		Delay_ms(20);   // atualizar display
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
	NOP
	NOP
;Projeto_3.c,55 :: 		}
	GOTO        L_main0
;Projeto_3.c,56 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
