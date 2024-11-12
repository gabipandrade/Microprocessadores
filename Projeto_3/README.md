# Projeto 3 - Termômetro Digital com LM35 e Conversor A/D

## Termômetro utilizando PIC18F4550 e linguagem C

### Integrantes

|                          Nome | Nº USP   |
|------------------------------:|----------|
|    Gabriela Passos de Andrade | 12625142 |
|              João Pedro Gomes | 13839069 |
| Luana Hartmann Franco da Cruz | 13676350 |
|     Rafael Cunha Bejes Learth | 13676367 |

## Estrutura do Projeto
Este repositório inclui:
- O arquivo `.c` com o código em C para o microcontrolador PIC18F4550, focado na leitura de um sensor de temperatura LM35 e exibição dos valores no display LCD.
- Documento PDF com especificação e requisitos do projeto.
- Este arquivo README com descrição do projeto, funcionamento e instruções de execução.

## Execução do Programa
O programa foi desenvolvido no compilador **MikroC PRO for PIC** e simulado no **SimulIDE**. O circuito inclui o PIC18F4550, um potenciômetro que simula o sensor de temperatura e um display LCD. Ao compilar e simular o circuito no SimulIDE, o potenciômetro exibe a variação de temperatura de 0 a 100 °C no display LCD.

## Funcionamento do Programa
O projeto utiliza o módulo ADC para converter a tensão lida no pino conectado ao potenciômetro, que simula o sensor LM35, em uma faixa de temperatura de 0 a 100 °C.

### Lógica de Conversão e Exibição
- **Sensor de Temperatura (Simulação)**: Utiliza um potenciômetro para variar a tensão e simular a temperatura de 0 a 100 °C. O Vref foi ajustado para 0 a 1V, adequado à sensibilidade de 10 mV/°C do LM35.
- **Display LCD**: A temperatura lida é exibida no formato "XX.X °C" no display, utilizando as funções da biblioteca LCD do MikroC.

## Implementação do Código

### Configuração Inicial
O código configura as portas de entrada e saída e inicializa o módulo ADC, ajustando Vref externamente nos pinos AN2 e AN3 para ler tensões de 0 a 1V.

### Funções Utilizadas
- **ADC_Get_Sample(canal)**: Lê o valor analógico do canal e converte para temperatura em °C.
- **Lcd_Out**: Exibe a temperatura formatada no display LCD.

### Procedimentos de Teste
1. **Compilação**: Compile o código no **MikroC PRO for PIC**.
2. **Simulação**: No **SimulIDE**, monte o circuito conforme o manual e ajuste o potenciômetro para observar a variação no display.

![Diagrama do Circuito no SimulIDE](circuito_simulide.jpeg)

## Formato de Entrega
Os arquivos a serem entregues são:
1. Documento com explicação textual dos conceitos (conversor A/D, registradores, Vref e display LCD).
2. Imagem do circuito no SimulIDE.
3. Arquivo de simulação `.simu` do SimulIDE.
4. Arquivos `.hex` e `.c` compilados no MikroC PRO for PIC.

## Notas Finais
Este projeto explora o uso de conversor A/D e exibição em LCD, oferecendo prática em configuração de Vref, leitura de dados analógicos e manipulação de displays em sistemas embarcados.
