#line 1 "C:/Users/eugom/OneDrive/Documentos/MICROCONTROLADORES/SEL0614/Projeto_2/Projeto_2.c"
unsigned char TMR0H_preset = 0xB;
unsigned char TMR0L_preset = 0xDC;

void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO {








 if(INTCON.TMR0IF == 1)
 {
 PORTC.RC2 = ~LATC.RC2;

 TMR0H += TMR0H_preset;
 TMR0L += TMR0L_preset;
 INTCON.TMR0IF = 0;
 }
}

void configInterrupt(){


 INTCON.GIE = 1;

 RCON.IPEN = 1;



 INTCON.TMR0IE = 1;
}

void configMCU()
{

 ADCON1 |= 0x0F;

 TRISC = 0;
 PORTC = 0;
}

void configTimer(){

 T0CON.TMR0ON = 1;
 T0CON.T08BIT = 0;
 T0CON.T0CS = 0;
 T0CON.T0SE = 0;
 T0CON.PSA = 0;
 T0CON.T0PS2 = 1;
 T0CON.T0PS1 = 0;
 T0CON.T0PS0 = 0;
 TMR0H = TMR0H_preset;
 TMR0L = TMR0L_preset;
}

void main() {

 configMCU();
 configTIMER();
 configInterrupt();

 while(1);
}
