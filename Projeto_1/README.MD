# Projeto de Aplicação de Microprocessadores - Projeto 1: Controlador de Display de 7 Segmentos

Este projeto demonstra a implementação de um controlador para display de 7 segmentos utilizando o microcontrolador 8051. O programa é escrito em Assembly e foi desenvolvido para exibir os números de 0 a 9 em um display de 7 segmentos, alternando dinamicamente o intervalo de exibição (0,25s ou 1s) com o uso de dois switches.

---
### Integrantes:
|                          Nome | Nº USP   |
|------------------------------:|----------|
|    Gabriela Passos de Andrade | 12625142 |
|     Rafael Cunha Bejes Learth | 13676367 |

## Visão Geral

O objetivo principal deste projeto é controlar um display de 7 segmentos através de:
- **Contagem de 0 a 9:** O display exibe os dígitos em sequência.
- **Controle Dinâmico do Tempo:** Dois switches (SW0 e SW1) conectados à porta P2 do microcontrolador permitem selecionar o intervalo de tempo entre as exibições. Ao pressionar o SW0, o atraso é de 0,25 segundos; ao pressionar o SW1, o atraso é de 1 segundo.
- **Tratamento de Rebote (Debounce):** Uma sub-rotina de debounce é implementada para evitar leituras incorretas devido ao efeito de "rebote" dos switches.

O microcontrolador monitora continuamente o estado dos switches, possibilitando a alteração do intervalo de tempo de exibição sem interromper a contagem.

---

## Descrição do Sistema

### Interfaces de Hardware
- **Display de 7 Segmentos:** Conectado à porta P1 do 8051, responsável pela exibição dos números.
- **Switches:** SW0 e SW1 estão conectados à porta P2 (pinos P2.0 e P2.1) para a seleção do intervalo de tempo.

### Variáveis e Flags
- **DELAY_FLAG:** Armazena o valor do atraso atual (0 para 0,25s e 1 para 1s).
- **COUNTING_FLAG:** Indica se a contagem foi iniciada (0 = não iniciada, 1 = iniciada).

### Controle de Tempo
- **Atraso Base:** Uma rotina de atraso gera uma base de 5ms. Essa base é repetida:
  - 50 vezes para um atraso de 0,25s.
  - 200 vezes para um atraso de 1s.

---
