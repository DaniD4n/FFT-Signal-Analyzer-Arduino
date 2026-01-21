# 🎛️ Arduino Signal Spectrometer

Projeto desenvolvido na disciplina **Introdução à Engenharia Elétrica (2025.1)** – UFCG.

Sistema capaz de **captar, amplificar, filtrar e analisar sinais analógicos**, exibindo
o sinal no tempo e seu espectro de frequências por meio da **Transformada de Fourier (FFT)**.

---

## 🔧 Tecnologias Utilizadas
- Arduino Uno
- Processing (Java)
- FFT (biblioteca Minim)
- Amplificadores operacionais (LM324)
- Filtro RC analógico

---

## 📐 Funcionalidades
- Aquisição de sinais analógicos via Arduino
- Comunicação serial em tempo real
- Visualização do sinal no domínio do tempo
- Análise espectral via FFT
- Interface gráfica interativa
- Ajuste de ganho e janelas de frequência

---

## 🧠 Aplicações
- Análise de instrumentos musicais
- Identificação de ruído elétrico (60 Hz)
- Estudo de harmônicos
- Introdução ao processamento de sinais

---

## ⚠️ Limitações
- Taxa de amostragem limitada (~4 kHz)
- Arduino Uno não captura tensões negativas
- Presença de ruído interno do microcontrolador

---

## 🚀 Possíveis Melhorias
- Uso de ESP32 ou Arduino Giga
- Migração para C/C++
- Aumento da taxa de amostragem
- Circuito com offset DC

---

## 👥 Autores
- Raylson Gabriel Morais da Silva
- Guilherme Araújo Ferreira
- Pedro Daniel Chaves Monteiro de Almeida Seixas
- Maria Isabel de Barros Azevedo

---

## 📄 Relatório
O relatório completo do projeto está disponível na pasta `/report`.

