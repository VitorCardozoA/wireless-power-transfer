# Wireless Power Transfer

Projeto acadêmico de engenharia elétrica voltado ao dimensionamento e à validação, em MATLAB/Simulink, de um sistema de transferência de energia sem fio com compensação série-série (SS), operando na faixa de 500 W a 50 kHz.

## Visão Geral

O trabalho combina modelagem analítica, varredura paramétrica e validação por simulação para selecionar um ponto de operação viável para a topologia SS. O repositório foi organizado para funcionar tanto como entrega acadêmica quanto como peça de portfólio técnico.

## Dados Técnicos

- Topologia: compensação série-série (SS)
- Potência de saída alvo: `500 W`
- Frequência nominal: `50 kHz`
- Fator de acoplamento adotado: `k = 0.4`
- Ponto selecionado: `Lp = Ls = 2211 µH`
- Capacitores calculados: `Cp = Cs ≈ 4.583 nF`
- Eficiência nominal calculada: `≈ 98.4%`

## Estrutura

```text
.
├── article/
│   └── transferencia-energia-sem-fio-serie-serie.pdf
├── assets/
│   └── figures/
│       ├── selection-maps.png
│       └── valid-region-zoom.png
├── docs/
│   ├── article-validation.md
│   └── frequency-sweep-validation.csv
├── figures/
│   ├── a.png
│   ├── b.png
│   ├── c.png
│   ├── d.png
│   ├── selecao.png
│   ├── simc.png
│   └── topo.pdf
├── matlab/
│   ├── parametric_sweep.m
│   ├── simulink_parameters.m
│   └── validate_project.m
├── simulink/
│   └── ss_topology.slx
├── paper.tex
├── references.bib
└── IEEEtran.cls
```

## Arquivos Principais

- Artigo final: [`article/transferencia-energia-sem-fio-serie-serie.pdf`](article/transferencia-energia-sem-fio-serie-serie.pdf)
- Fonte LaTeX do artigo: [`paper.tex`](paper.tex)
- Bibliografia: [`references.bib`](references.bib)
- Script de varredura paramétrica: [`matlab/parametric_sweep.m`](matlab/parametric_sweep.m)
- Script de parâmetros do modelo: [`matlab/simulink_parameters.m`](matlab/simulink_parameters.m)
- Validação automatizada: [`matlab/validate_project.m`](matlab/validate_project.m)
- Modelo Simulink: [`simulink/ss_topology.slx`](simulink/ss_topology.slx)

## Como Reproduzir

### MATLAB / Simulink

No MATLAB:

```matlab
addpath(fullfile(pwd, 'matlab'))
validate_project
```

O fluxo executa:

- checagem dos scripts com o Code Analyzer;
- geração das figuras em `assets/figures/`;
- atualização e simulação do modelo Simulink;
- recálculo da tabela de variação de frequência;
- exportação dos resultados numéricos para `docs/frequency-sweep-validation.csv`.

### LaTeX

Para recompilar o artigo:

```powershell
pdflatex -interaction=nonstopmode paper.tex
bibtex paper
pdflatex -interaction=nonstopmode paper.tex
pdflatex -interaction=nonstopmode paper.tex
```

Depois da compilação, o PDF final consolidado do projeto fica em `article/transferencia-energia-sem-fio-serie-serie.pdf`.

## Validação

Os resultados numéricos revisados da variação de frequência estão documentados em [`docs/frequency-sweep-validation.csv`](docs/frequency-sweep-validation.csv), e a revisão técnica do artigo está em [`docs/article-validation.md`](docs/article-validation.md).

## Portfólio Técnico

Este repositório evidencia:

- modelagem analítica de sistemas ressonantes;
- automação de validação em MATLAB;
- integração entre cálculo, simulação e documentação técnica;
- organização de projeto com foco em reprodutibilidade e apresentação profissional.
