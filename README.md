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

## ⚙️ Distribuição CUW no GAMLSS

Este repositório também inclui a implementação da distribuição CUW como uma família personalizada para o pacote `gamlss` em R. A definição foi realizada por meio da criação de um objeto da classe `gamlss.family`, com as seguintes funções:

- Função de densidade (`d`)
- Geração de números aleatórios (`r`)
- Derivadas numéricas da log-verossimilhança (`dldm`, `dldd`, `d2ldm2`, `d2ldd2`, `d2ldmdd`)
- Inicializações e validações necessárias para o GAMLSS

### 📈 Ajuste com e sem regressores

A família CUW foi testada com dados simulados em dois cenários:

- **Sem regressão**: distribuição gerada com valores fixos de `μ = 0.7` e `σ = 2`.
- **Com regressão**: valores de `μ` simulados a partir da função `plogis(-1 + 2 * x)`.

O gráfico abaixo mostra o resultado do ajuste com regressão, comparando os valores previstos de `μ` com os valores reais utilizados na simulação:

![image](https://github.com/user-attachments/assets/029b5483-7912-4680-8aa1-ae9ea57c715e)


Como é possível observar, há uma tendência crescente, o que confirma que a implementação da CUW no GAMLSS está funcionando corretamente para capturar a relação entre a variável explicativa `x` e o parâmetro `μ`.

---

### 🧩 Arquivo relevante:

- `CUW-FOR-GAMLSS.R`: definição da distribuição CUW como família `gamlss.family`, pronta para ser utilizada com `gamlss()`.
