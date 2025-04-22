dCUW_internal <- function(y, mu, sigma, log = FALSE) {
  log2_val <- log(2)
  mu <- pmin(pmax(mu, 1e-6), 1 - 1e-6)
  sigma <- pmax(sigma, 1e-6)
  
  logf <- log(sigma * log2_val) - log(1 - y) - sigma * log(-log(1 - mu)) +
    (sigma - 1) * log(-log(1 - y)) -
    (log2_val * (-log(1 - y) / log(1 - mu))^sigma)
  
  out <- if (log) logf else exp(logf)
  out[!is.finite(out)] <- -1e6  # penaliza NaN/Inf
  return(out)
}

dldm_CUW <- function(y, mu, sigma) {
  eps <- 1e-5
  mu1 <- pmin(pmax(mu + eps, 1e-6), 1 - 1e-6)
  mu2 <- pmin(pmax(mu - eps, 1e-6), 1 - 1e-6)
  d1 <- log(dCUW_internal(y, mu1, sigma))
  d2 <- log(dCUW_internal(y, mu2, sigma))
  score <- (d1 - d2) / (2 * eps)
  score[!is.finite(score)] <- 0
  score
}

dldd_CUW <- function(y, mu, sigma) {
  eps <- 1e-5
  sigma1 <- pmax(sigma + eps, 1e-6)
  sigma2 <- pmax(sigma - eps, 1e-6)
  d1 <- log(dCUW_internal(y, mu, sigma1))
  d2 <- log(dCUW_internal(y, mu, sigma2))
  score <- (d1 - d2) / (2 * eps)
  score[!is.finite(score)] <- 0
  score
}

d2ldm2_CUW <- function(y, mu, sigma) {
  eps <- 1e-5
  s1 <- dldm_CUW(y, mu + eps, sigma)
  s2 <- dldm_CUW(y, mu - eps, sigma)
  deriv <- (s1 - s2) / (2 * eps)
  deriv[!is.finite(deriv)] <- 0
  deriv
}

d2ldd2_CUW <- function(y, mu, sigma) {
  eps <- 1e-5
  s1 <- dldd_CUW(y, mu, sigma + eps)
  s2 <- dldd_CUW(y, mu, sigma - eps)
  deriv <- (s1 - s2) / (2 * eps)
  deriv[!is.finite(deriv)] <- 0
  deriv
}

d2ldmdd_CUW <- function(y, mu, sigma) {
  eps <- 1e-5
  s1 <- dldm_CUW(y, mu, sigma + eps)
  s2 <- dldm_CUW(y, mu, sigma - eps)
  deriv <- (s1 - s2) / (2 * eps)
  deriv[!is.finite(deriv)] <- 0
  deriv
}

CUW <- function(mu.link = "logit", sigma.link = "log") {
  mstats <- checklink("mu.link", "CUW", substitute(mu.link), c("logit", "probit"))
  dstats <- checklink("sigma.link", "CUW", substitute(sigma.link), c("log", "identity"))
  
  structure(
    list(
      family = "CUW",
      parameters = list(mu = TRUE, sigma = TRUE),
      nopar = 2,
      type = "Continuous",
      
      mu.link = as.character(substitute(mu.link)),
      sigma.link = as.character(substitute(sigma.link)),
      mu.linkfun = mstats$linkfun,
      sigma.linkfun = dstats$linkfun,
      mu.linkinv = mstats$linkinv,
      sigma.linkinv = dstats$linkinv,
      mu.dr = mstats$mu.eta,
      sigma.dr = dstats$mu.eta,
      
      d = dCUW_internal,
      r = function(n, mu, sigma) {
        mu <- pmin(pmax(mu, 1e-6), 1 - 1e-6)
        sigma <- pmax(sigma, 1e-6)
        u <- runif(n)
        1 - (1 - mu) * ((-log(u) / log(2))^(1 / sigma))
      },
      
      mu.initial = expression(mu <- rep(0.5, length(y))),
      sigma.initial = expression(sigma <- rep(2, length(y))),
      mu.valid = function(mu) all(mu > 0 & mu < 1),
      sigma.valid = function(sigma) all(sigma > 0),
      y.valid = function(y) all(y > 0 & y < 1),
      
      dldm = dldm_CUW,
      dldd = dldd_CUW,
      d2ldm2 = d2ldm2_CUW,
      d2ldd2 = d2ldd2_CUW,
      d2ldmdd = d2ldmdd_CUW
    ),
    class = c("gamlss.family", "family")
  )
}
