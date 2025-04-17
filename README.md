# Distribuição Weibull Unitária Complementar (CUW)

Este repositório contém um estudo completo sobre a distribuição Weibull Unitária Complementar (CUW), incluindo:

- Equações explícitas da PDF, CDF e função quantílica;
- Geração de números aleatórios via função inversa;
- Estimação dos parâmetros μ (mediana) e γ (forma) por máxima verossimilhança;
- Implementação completa em R;
- Visualização gráfica do ajuste da densidade teórica aos dados simulados.

## 📈 Gráfico: Ajuste da densidade CUW aos dados simulados

A figura abaixo mostra a densidade CUW estimada sobreposta ao histograma de uma amostra simulada de tamanho n = 1000, com parâmetros verdadeiros μ = 0.8 e γ = 2.5.
Os valores estimados via máxima verossimilhança (MLE) foram:

- μ̂ = 0,8148  
- γ̂ = 3,3076

![image](https://github.com/user-attachments/assets/d7a0908a-b66f-4306-8456-2fa3371001e1)

## 📄 Estrutura

- `cuw_documento.tex`: Documento teórico com todas as equações formatadas em LaTeX.
- `cuw_codigo.R`: Script completo em R com simulação, funções, estimação e visualização.
- `README.md`: Apresentação geral do projeto.
