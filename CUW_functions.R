
# PDF
dCUW <- function(z, mu, gamma) {
  log2_val <- log(2)
  term1 <- gamma * log2_val / (1 - z)
  term2 <- (-log(1 - mu))^(-gamma)
  term3 <- (-log(1 - z))^(gamma - 1)
  term4 <- 2^(-(log(1 - z) / log(1 - mu))^gamma)
  return(term1 * term2 * term3 * term4)
}

# CDF
pCUW <- function(z, mu, gamma) {
  exponent <- (log(1 - z) / log(1 - mu))^gamma
  return(1 - 2^(-exponent))
}

# Funcao Quantilica
qCUW <- function(p, mu, gamma) {
  term <- (-log(1 - p) / log(2))^(1 / gamma)
  return(1 - (1 - mu) * term)
}

# Geração de numeros aleatorios
rCUW <- function(n, mu, gamma) {
  u <- runif(n)
  return(qCUW(u, mu, gamma))
}


# Estimacao via maxima verossimilhanca (MLE)


# Funcao de verossimilhanca perfilada
loglik_gamma_profile <- function(gamma, data) {
  if (gamma <= 0) return(Inf)
  
  n <- length(data)
  sum1 <- sum(-log(1 - data))
  sum2 <- sum(log(-log(1 - data)))
  sum3 <- sum((-log(1 - data))^gamma)
  sum4 <- sum(log(-log(1 - data)) * (-log(1 - data))^gamma)
  
  term1 <- n * log(gamma * n)
  term2 <- -n * log(sum3)
  term3 <- -sum1
  term4 <- (gamma - 1) * sum2
  
  loglik <- term1 + term2 + term3 + term4 - n
  return(-loglik)  # sinal negativo para minimizar
}

# Estimador da mediana (mu) em função de gamma
mu_hat_profile <- function(gamma, data) {
  n <- length(data)
  sum_gamma <- sum((-log(1 - data))^gamma)
  return(1 - exp(- (log(2) * sum_gamma / n)^(1 / gamma)))
}

# Função principal de estimacao
estimate_CUW <- function(data, gamma_init = 1) {
  opt <- optim(par = gamma_init,
               fn = loglik_gamma_profile,
               data = data,
               method = "L-BFGS-B",
               lower = 0.01,
               upper = 100)
  
  gamma_hat <- opt$par
  mu_hat <- mu_hat_profile(gamma_hat, data)
  return(list(mu = mu_hat, gamma = gamma_hat, logLik = -opt$value))
}


# Exemplo de uso


# Gerar amostra simulada
set.seed(123)
n <- 1000
mu_true <- 0.8
gamma_true <- 2.5
sample_data <- rCUW(n, mu_true, gamma_true)

# Estimar parametros
est <- estimate_CUW(sample_data)
print(est)


# Grafico: histograma + densidade estimada

z_vals <- seq(0.001, 0.999, length.out = 500)
dens_est <- dCUW(z_vals, est$mu, est$gamma)

hist(sample_data, probability = TRUE, breaks = 30, col = "lightgray",
     main = "Histograma da Amostra vs. Densidade CUW Ajustada",
     xlab = "z", ylim = c(0, max(dens_est) * 1.1))

lines(z_vals, dens_est, col = "blue", lwd = 2)
legend("topright",
       legend = sprintf("Densidade CUW\n(mu = %.3f, gamma = %.3f)", est$mu, est$gamma),
       col = "blue", lwd = 2, bty = "n")
