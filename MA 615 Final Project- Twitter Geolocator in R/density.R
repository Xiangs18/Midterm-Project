
# common kernels
kepa <- function (x) .75 / sqrt(5) * (abs(x) < sqrt(5)) * (1 - x ^ 2 / 5)
kboxcar <- function (x) .5 * (abs(x) < 1)
kpower <- function (k) {
  c <- .5 * (k + 1) / k
  if (k == 0) return(kboxcar)
  function (x) c * (abs(x) < 1) * (1 - abs(x) ^ k)
}
kgaussian <- dnorm

kdensity <- function (x, K) {
  function (t, h) # f^_h(t)
    mean(K((t - x) / h)) / h
}


plot.density <- function (x, h, K = dnorm, ns = 100) {
  n <- length(x)
  f <- kdensity(x, K)
  t <- seq(min(x) - sd(x), max(x) + sd(x), length = ns)
  y <- sapply(t, f, h)
  plot(t, y, ylim = c(0, max(y)), type = 'l',
       main = paste0('h = ', sprintf('%.2f', h)),
       lwd = 2, xlab = 'x', ylab = expression(hat(f)[h]))
  for (xi in x)
    lines(t, K((t - xi) / h) / (n * h), lty = 2)
  rug(x)
}

# unbiased CV: `h` is bandwidth, `x` is data, `K` is kernel,
# `w` is kernel width in bandwidth units (e.g., w = 3 for Gaussian kernel),
# and `n` is integral grid resolution (#subdivisions)
ucv <- function (h, x, K = dnorm, w = 3, n = 100) {
  fhat2 <- function (t) (mean(K((t - x) / h)) / h) ^ 2
  fhat2vec <- function (xs) sapply(xs, fhat2)
  from <- min(x) - w * h; to <- max(x) + w * h
  J <- integrate(fhat2vec, from, to, subdivisions = n)$value # R(fhat)
  J - 2 * mean(sapply(seq_along(x),
                      function (i) mean(K((x[i] - x[-i]) / h)) / h))
}

density.ci.student <- function (x, h, alpha = .05, K = dnorm, w = 3, n = 100) {
  xs <- seq(min(x) - sd(x), max(x) + sd(x), length = n) # interval of interest
  m <- diff(range(xs)) / (w * h) # independent of n, used to define q:
  q <- qnorm(.5 * (1 + (1 - alpha) ^ (1 / m)))
  fhat <- l <- u <- numeric(n)
  for (i in seq_along(xs)) {
    y <- K((xs[i] - x) / h) / h
    se <- sd(y) / sqrt(length(x))
    fhat[i] <- fx <- mean(y)
    l[i] <- max(fx - q * se, 0); u[i] <- fx + q * se
  }

  plot(xs, fhat, type = 'n', ylim = range(l, u), xlab = 'x')
  polygon(c(xs, rev(xs)), c(l, rev(u)), col = 'gray', border = F)
  lines(xs, fhat, lwd=2)
  rug(x)
}


# Example:
p <- .4; mu <- c(1, 5); sigma <- c(1, 2) # normal mixture
n <- 10
x <- rbinom(n, 1, 1 - p) + 1; x <- rnorm(n, mu[x], sigma[x])
# try plot.density

hs <- 10 ^ seq(-1, 1, length = 100)
uh <- sapply(hs, ucv, x)
plot(hs, uh, type = 'l', xlab='h', ylab='UCV(h)')
h.star <- hs[which.min(uh)]
plot.density(x, bw.nrd(x))
plot.density(x, bw.ucv(x))
plot.density(x, h.star)

density.ci.student(x, h.star)

