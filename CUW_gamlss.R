library(gamlss)

source("CUW-FOR-GAMLSS.R")
# Simulacao SEM regressor
set.seed(123)
y_sem <- CUW()$r(500, mu = 0.7, sigma = 2)

mod_sem <- gamlss(y_sem ~ 1, sigma.formula = ~1, family = CUW())
summary(mod_sem)

# Simulacao COM regressor
n <- 500
x <- runif(n)
mu_x <- plogis(-1 + 2 * x)  # funcao logistica ajustada
sigma0 <- 2

y_com <- CUW()$r(n, mu = mu_x, sigma = sigma0)
y_com <- pmin(pmax(y_com, 1e-6), 1 - 1e-6)

mod_com <- gamlss(y_com ~ x, sigma.formula = ~1, family = CUW())
summary(mod_com)

plot(mu_x, fitted(mod_com), main = "μ ajustado vs. μ verdadeiro", xlab = "μ verdadeiro", ylab = "μ ajustado")
abline(0, 1, col = "red")