# Transferência de Energia Sem Fio

Este repositório reúne o material do meu trabalho sobre um sistema de transferência de energia sem fio com compensação série-série (SS), desenvolvido com apoio de MATLAB e Simulink.

O objetivo do estudo foi dimensionar o circuito para operação em `50 kHz`, com potência de saída próxima de `500 W`, e depois validar o comportamento do sistema por meio de cálculo, varredura paramétrica e simulação.

## Dados do projeto

- Topologia analisada: série-série (SS)
- Frequência nominal: `50 kHz`
- Potência de saída desejada: `500 W`
- Tensão de saída: `400 V`
- Fator de acoplamento adotado: `k = 0.4`
- Ponto selecionado: `Lp = Ls = 2211 µH`
- Eficiência obtida: aproximadamente `98,4%`

## Organização da pasta

- `article/transferencia-energia-sem-fio-serie-serie.pdf`: versão final do artigo
- `paper.tex`: arquivo-fonte do artigo em LaTeX
- `references.bib`: bibliografia utilizada
- `matlab/`: scripts usados nos cálculos e na varredura paramétrica
- `simulink/ss_topology.slx`: modelo utilizado na simulação
- `figures/` e `assets/figures/`: figuras e resultados gráficos
- `docs/`: arquivos auxiliares de validação numérica

## Leitura do material

Para entender o trabalho de forma direta, o arquivo principal é o PDF em `article/transferencia-energia-sem-fio-serie-serie.pdf`.

Para verificar os cálculos, basta abrir os arquivos da pasta `matlab/` no MATLAB.

Para analisar o modelo de simulação, basta abrir `simulink/ss_topology.slx` no Simulink.

Os demais arquivos foram mantidos no repositório para mostrar de forma completa como o projeto foi calculado, simulado e documentado.
