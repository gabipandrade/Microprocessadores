#define TRUE  1
// config. dos pinos para o LCD
sbit LCD_RS at LATB4_bit; // pino 4 do PORTB interligado ao RS do display
sbit LCD_EN at LATB5_bit; // pino 5 do PORTB " " ao EN do display
sbit LCD_D4 at LATB0_bit; // pino 0 do PORTB ao D4
sbit LCD_D5 at LATB1_bit;  // " "
sbit LCD_D6 at LATB2_bit;  // " "
sbit LCD_D7 at LATB3_bit;  // " "
// direção do fluxo de dados nos pinos selecionados
sbit LCD_RS_Direction at TRISB4_bit;  // direção do fluxo de dados do pino RB4
sbit LCD_EN_Direction at TRISB5_bit;  // " "
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

void main(){

  unsigned int Valor_ADC = 0;  // var. para leitura
  unsigned char Tensao[10];    // arranjo textual para exibir no display

  //lembrando que os pinos agora devem ser configurados como analógicos
  TRISA.RA3 = 1;


  // Configuração do módulo LCD
  Lcd_Init();                 // Inicializa a lib. Lcd
  Lcd_Cmd(_LCD_CLEAR);       // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);  // Cursor off
  Lcd_Out(1,1,"ADC0:");   //Escreve na Linha x Coluna do LCD o texto(valor do ADC)

  ADC_Init_Advanced(_ADC_EXTERNAL_VREFH);  // uso da função da biblioteca ADC do próprio compilador
  
  while(TRUE)
  {
    Valor_ADC = ADC_Get_Sample(0); // função da biblioteca ADC para leitura

    Valor_ADC = Valor_ADC * (1000/1023.); // formata o valor de entrada (neste caso o valor de exemplo '1234')
    // para 0 a 1023 -> com ponto no final para n° float,i.e.,o display mostrará: '12.34'

    // Formatando cada valor a ser exibido no display como "99.9ºC"
    Tensao[0] = (Valor_ADC/1000) + '0';
    Tensao[1] = (Valor_ADC/100)%10 + '0';
    Tensao[2] = (Valor_ADC/10)%10 + '0';
    Tensao[3] = '.';
    Tensao[4] = (Valor_ADC/1)%10 + '0';
    Tensao[5] = ' ';
    Tensao[6] = 'C';
    Tensao[7] = 0;


    // Exibir os valores na config. acima no display LCD:
    Lcd_Out(1,6,Tensao); // Mostra os valores no display
    Delay_ms(20);   // atualizar display
  }
}