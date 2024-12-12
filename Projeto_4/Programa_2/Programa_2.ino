// Definições dos pinos GPIO para as cores do LED RGB (cátodo comum)
#define LED_PIN_R 5  // Pino do Red
#define LED_PIN_G 16  // Pino do Green
#define LED_PIN_B 17  // Pino do Blue

void setup() {
  // Inicialização da comunicação serial
  Serial.begin(115200);
  
  // Configuração dos pinos de saída
  pinMode(LED_PIN_R, OUTPUT);
  pinMode(LED_PIN_G, OUTPUT);
  pinMode(LED_PIN_B, OUTPUT);
}

void loop() {
  static uint8_t incremento = 0;

  // Calcular o duty cycle para cada cor do LED
  uint32_t duty_r = incremento * 2; // Red
  uint32_t duty_g = incremento;     // Green
  uint32_t duty_b = incremento * 3; // Blue

  // Atualizar os valores de PWM (controlando o brilho das cores)
  analogWrite(LED_PIN_R, duty_r); 
  analogWrite(LED_PIN_G, duty_g); 
  analogWrite(LED_PIN_B, duty_b); 

  // Exibir no Monitor Serial os valores
  Serial.print("Incremento: ");
  Serial.println(incremento);
  Serial.print("Duty cycle - R: ");
  Serial.print(duty_r * 100 / 255);
  Serial.print("%, G: ");
  Serial.print(duty_g * 100 / 255);
  Serial.print("%, B: ");
  Serial.print(duty_b * 100 / 255);
  Serial.println("%");

  // Incrementar o valor de incremento
  incremento += 5;
  if (incremento > 255) {
    incremento = 0; 
  }

  delay(100); // Atraso de 100ms
}
