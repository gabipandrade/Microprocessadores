#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <ESP32Servo.h>

// Configuração do display OLED
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// Configuração do Servo
Servo servoMotor;
#define SERVO_PIN 26

// Configuração dos botões
#define BUTTON_LOOP 12
#define BUTTON_MANUAL 14
#define BUTTON_STOP 23
bool loopActive = false;
bool manualActive = false;
bool systemActive = true;

#define POT_PIN 34

void setup() {
  Serial.begin(115200);

  // Inicializa o display OLED
  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("Falha ao inicializar o display OLED"));
    for (;;); // Se falhar, entra em loop infinito
  }

  // Inicializa o servo motor
  servoMotor.attach(SERVO_PIN);

  // Configuração dos botões
  pinMode(BUTTON_LOOP, INPUT_PULLUP);
  pinMode(BUTTON_MANUAL, INPUT_PULLUP);
  pinMode(BUTTON_STOP, INPUT_PULLUP);

  display.display();
  delay(2000);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0, 0);
  display.println(F("Hello World!"));
  display.display();
}

void loop() {
  // Verifica se o botão STOP foi pressionado
  if (digitalRead(BUTTON_STOP) == LOW) {
    systemActive = false;
    loopActive = false;
    manualActive = false;
    servoMotor.write(0); // Reseta o servo
    updateDisplayAndSerial("Sistema desligado", 0, "OFF");
    delay(300);
  }

  if (!systemActive) return; // Sai se o sistema estiver desligado

  // Modo automático
  if (digitalRead(BUTTON_LOOP) == LOW) {
    loopActive = true;
    manualActive = false;
    delay(300);
  }

  // Modo manual
  if (digitalRead(BUTTON_MANUAL) == LOW) {
    manualActive = true;
    loopActive = false;
    delay(300);
  }

  if (loopActive) automaticMode();
  if (manualActive) manualMode();
}

// Função para o movimento automático do servo
void automaticMode() {
  for (int angle = 0; angle <= 180; angle += 1) {
    if (!loopActive) return;
    servoMotor.write(angle);
    updateDisplayAndSerial("Automatico", angle, "->");
    delay(100);
  }

  delay(1000);

  for (int angle = 180; angle >= 0; angle -= 1) {
    if (!loopActive) return;
    servoMotor.write(angle);
    updateDisplayAndSerial("Automatico", angle, "<-");
    delay(200);
  }
}

// Função para o controle manual do servo com potenciômetro
void manualMode() {
  int potValue = analogRead(POT_PIN);
  int angle = map(potValue, 0, 4095, 0, 180);
  servoMotor.write(angle);
  updateDisplayAndSerial("Manual", angle, "Pot");
  delay(100);
}

// Função para atualizar o display OLED e a comunicação serial
void updateDisplayAndSerial(const char *mode, int angle, const char *direction) {
  Serial.print("Modo: ");
  Serial.println(mode);
  Serial.print("Angulo: ");
  Serial.println(angle);
  Serial.print("Sentido: ");
  Serial.println(direction);

  display.clearDisplay();
  display.setCursor(0, 0);
  display.println(F("Modo: "));
  display.println(mode);
  display.println(F("Angulo: "));
  display.println(angle);
  display.println(F("Sentido: "));
  display.println(direction);
  display.display();
}
