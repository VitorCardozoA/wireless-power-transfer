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

## O que está nesta pasta

- `article/transferencia-energia-sem-fio-serie-serie.pdf`: versão final do artigo
- `paper.tex`: fonte LaTeX do artigo
- `references.bib`: bibliografia utilizada
- `matlab/`: scripts de cálculo, varredura e validação
- `simulink/ss_topology.slx`: modelo usado na simulação
- `figures/` e `assets/figures/`: figuras do trabalho
- `docs/`: arquivos auxiliares de validação numérica

## Como reproduzir

No MATLAB:

```matlab
addpath(fullfile(pwd, 'matlab'))
validate_project
```

Esse script faz a checagem dos arquivos principais, gera as figuras, atualiza o modelo no Simulink e recalcula os resultados usados na análise.

Para recompilar o artigo em LaTeX:

```powershell
pdflatex -interaction=nonstopmode paper.tex
bibtex paper
pdflatex -interaction=nonstopmode paper.tex
pdflatex -interaction=nonstopmode paper.tex
```

## Observação

O arquivo principal para leitura do trabalho é o PDF em `article/transferencia-energia-sem-fio-serie-serie.pdf`. Os demais arquivos foram mantidos no repositório para deixar claro como o projeto foi calculado, simulado e documentado.
