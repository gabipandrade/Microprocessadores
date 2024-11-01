unsigned char TMR0H_preset = 0xB;
unsigned char TMR0L_preset = 0xDC;

void INTERRUPCAO_HIGH() iv 0x0008 ics ICS_AUTO {
  // vetor de tratamento da interrupção (endereço fixo 0x0008)
  // Definir em Tools > Interrupt Assistant
  // HIGH = interrupção de alta prioridade
  // LOW = interrupção de baixa prioridade (endereço 0x0018)
  // ics = serviço de acionamento/tratamento da interrupção


  // tratamento - acionar LED
  if(INTCON.TMR0IF == 1)    //Foi o TIMER0 que gerou a interrupção ?
  {
    PORTC.RC2 = ~LATC.RC2; //PISCA O LED no PORTC

    TMR0H += TMR0H_preset;
    TMR0L += TMR0L_preset;
    INTCON.TMR0IF = 0;   //Não esquecer de zerar a Flag
  }
}

void configInterrupt(){
  //Configuração Global das interrupções GIE   - chave geral que sinaliza que o
  //programa usará interrupções
  INTCON.GIE = 1; // Alta prioridade   - usar somente SE RCON.IPEN =1;

  RCON.IPEN = 1; //habilita níveis de prioridade - permite que uma interrupção
  //tenha prioridade no tratamento caso ocorra ao mesmo tempo que outro tipo de
  // interrupção ou que interrompa uma interrupção de baixa priordade em atendimento

  INTCON.TMR0IE = 1;   //Habilita a interrupção individual do TIMER0
}

void configMCU()
{
  // Configurando os pinos como digitais
  ADCON1 |= 0x0F;
  // Config. das portas
  TRISC = 0;    // PORTD como saída  (usar LED)
  PORTC = 0;    // LED inicialmente OFF
}

void configTimer(){
  // Timer0 Registers:// 16-Bit Mode; Prescaler=1:32; TMRH Preset=B; TMRL Preset=DC; Freq=1,00Hz; Period=1,00 s
  T0CON.TMR0ON = 1;// Timer0 On/Off Control bit:1=Enables Timer0 / 0=Stops Timer0
  T0CON.T08BIT = 0;// Timer0 8-bit/16-bit Control bit: 1=8-bit timer/counter / 0=16-bit timer/counter
  T0CON.T0CS   = 0;// TMR0 Clock Source Select bit: 0=Internal Clock (CLKO) / 1=Transition on T0CKI pin
  T0CON.T0SE   = 0;// TMR0 Source Edge Select bit: 0=low/high / 1=high/low
  T0CON.PSA    = 0;// Prescaler Assignment bit: 0=Prescaler is assigned; 1=NOT assigned/bypassed
  T0CON.T0PS2  = 1;// bits 2-0  PS2:PS0: Prescaler Select bits
  T0CON.T0PS1  = 0;
  T0CON.T0PS0  = 0;
  TMR0H = TMR0H_preset;    // preset for Timer0 MSB register
  TMR0L = TMR0L_preset;    // preset for Timer0 LSB register
}

void main() {
  // Configuração inicial do MCU
  configMCU();
  configTIMER();
  configInterrupt();
  
  while(1);
}