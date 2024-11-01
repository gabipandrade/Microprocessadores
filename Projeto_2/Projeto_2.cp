#line 1 "C:/Users/eugom/OneDrive/Documentos/MICROCONTROLADORES/SEL0614/Projeto_2/Projeto_2.c"
unsigned char TMR0H_preset = 0xB;
unsigned char TMR0L_preset = 0xDC;

unsigned char displayNum = 0;

void incrementUntil9(unsigned char *n){

 (*n) += 1;


 if(*n >= 10){
 (*n) = 0;
 }
}

void out7Seg(unsigned char n)
{
 switch (n)
 {
 case 0:{ latd = 0b00111111; break;}
 case 1:{ latd = 0b00000110; break;}
 case 2:{ latd = 0b01011011; break;}
 case 3:{ latd = 0b01001111; break;}
 case 4:{ latd = 0b01100110; break;}
 case 5:{ latd = 0b01101101; break;}
 case 6:{ latd = 0b01111101; break;}
 case 7:{ latd = 0b00000111; break;}
 case 8:{ latd = 0b01111111; break;}
 case 9:{ latd = 0b01101111; break;}
 default:{ latd = 0b00000000; ; break;}
 }

}

void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO {








 if(INTCON.TMR0IF == 1)
 {
 incrementUntil9(&displayNum);
 out7Seg(displayNum);

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

 TRISD = 0;
 PORTD = 0;
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
