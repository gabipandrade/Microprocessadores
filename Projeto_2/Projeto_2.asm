
_INTERRUPCAO_HIGH:

;Projeto_2.c,4 :: 		void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO {
;Projeto_2.c,13 :: 		if(INTCON.TMR0IF == 1)    //Foi o TIMER0 que gerou a interrupção ?
	BTFSS       INTCON+0, 2 
	GOTO        L_INTERRUPCAO_HIGH0
;Projeto_2.c,15 :: 		PORTC.RC2 = ~LATC.RC2; //PISCA O LED no PORTC
	BTFSC       LATC+0, 2 
	GOTO        L__INTERRUPCAO_HIGH5
	BSF         PORTC+0, 2 
	GOTO        L__INTERRUPCAO_HIGH6
L__INTERRUPCAO_HIGH5:
	BCF         PORTC+0, 2 
L__INTERRUPCAO_HIGH6:
;Projeto_2.c,17 :: 		TMR0H += TMR0H_preset;
	MOVF        _TMR0H_preset+0, 0 
	ADDWF       TMR0H+0, 1 
;Projeto_2.c,18 :: 		TMR0L += TMR0L_preset;
	MOVF        _TMR0L_preset+0, 0 
	ADDWF       TMR0L+0, 1 
;Projeto_2.c,19 :: 		INTCON.TMR0IF = 0;   //Não esquecer de zerar a Flag
	BCF         INTCON+0, 2 
;Projeto_2.c,20 :: 		}
L_INTERRUPCAO_HIGH0:
;Projeto_2.c,21 :: 		}
L_end_INTERRUPCAO_HIGH:
L__INTERRUPCAO_HIGH4:
	RETFIE      1
; end of _INTERRUPCAO_HIGH

_configInterrupt:

;Projeto_2.c,23 :: 		void configInterrupt(){
;Projeto_2.c,26 :: 		INTCON.GIE = 1; // Alta prioridade   - usar somente SE RCON.IPEN =1;
	BSF         INTCON+0, 7 
;Projeto_2.c,28 :: 		RCON.IPEN = 1; //habilita níveis de prioridade - permite que uma interrupção
	BSF         RCON+0, 7 
;Projeto_2.c,32 :: 		INTCON.TMR0IE = 1;   //Habilita a interrupção individual do TIMER0
	BSF         INTCON+0, 5 
;Projeto_2.c,33 :: 		}
L_end_configInterrupt:
	RETURN      0
; end of _configInterrupt

_configMCU:

;Projeto_2.c,35 :: 		void configMCU()
;Projeto_2.c,38 :: 		ADCON1 |= 0x0F;
	MOVLW       15
	IORWF       ADCON1+0, 1 
;Projeto_2.c,40 :: 		TRISC = 0;    // PORTD como saída  (usar LED)
	CLRF        TRISC+0 
;Projeto_2.c,41 :: 		PORTC = 0;    // LED inicialmente OFF
	CLRF        PORTC+0 
;Projeto_2.c,42 :: 		}
L_end_configMCU:
	RETURN      0
; end of _configMCU

_configTimer:

;Projeto_2.c,44 :: 		void configTimer(){
;Projeto_2.c,46 :: 		T0CON.TMR0ON = 1;// Timer0 On/Off Control bit:1=Enables Timer0 / 0=Stops Timer0
	BSF         T0CON+0, 7 
;Projeto_2.c,47 :: 		T0CON.T08BIT = 0;// Timer0 8-bit/16-bit Control bit: 1=8-bit timer/counter / 0=16-bit timer/counter
	BCF         T0CON+0, 6 
;Projeto_2.c,48 :: 		T0CON.T0CS   = 0;// TMR0 Clock Source Select bit: 0=Internal Clock (CLKO) / 1=Transition on T0CKI pin
	BCF         T0CON+0, 5 
;Projeto_2.c,49 :: 		T0CON.T0SE   = 0;// TMR0 Source Edge Select bit: 0=low/high / 1=high/low
	BCF         T0CON+0, 4 
;Projeto_2.c,50 :: 		T0CON.PSA    = 0;// Prescaler Assignment bit: 0=Prescaler is assigned; 1=NOT assigned/bypassed
	BCF         T0CON+0, 3 
;Projeto_2.c,51 :: 		T0CON.T0PS2  = 1;// bits 2-0  PS2:PS0: Prescaler Select bits
	BSF         T0CON+0, 2 
;Projeto_2.c,52 :: 		T0CON.T0PS1  = 0;
	BCF         T0CON+0, 1 
;Projeto_2.c,53 :: 		T0CON.T0PS0  = 0;
	BCF         T0CON+0, 0 
;Projeto_2.c,54 :: 		TMR0H = TMR0H_preset;    // preset for Timer0 MSB register
	MOVF        _TMR0H_preset+0, 0 
	MOVWF       TMR0H+0 
;Projeto_2.c,55 :: 		TMR0L = TMR0L_preset;    // preset for Timer0 LSB register
	MOVF        _TMR0L_preset+0, 0 
	MOVWF       TMR0L+0 
;Projeto_2.c,56 :: 		}
L_end_configTimer:
	RETURN      0
; end of _configTimer

_main:

;Projeto_2.c,58 :: 		void main() {
;Projeto_2.c,60 :: 		configMCU();
	CALL        _configMCU+0, 0
;Projeto_2.c,61 :: 		configTIMER();
	CALL        _configTimer+0, 0
;Projeto_2.c,62 :: 		configInterrupt();
	CALL        _configInterrupt+0, 0
;Projeto_2.c,64 :: 		while(1);
L_main1:
	GOTO        L_main1
;Projeto_2.c,65 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
