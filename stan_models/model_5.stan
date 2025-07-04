
data {
  int<lower=0> N;   // number of data items/observations
  vector[N] wnd;           // first predictor
  vector[N] rh;           // second predictor
  vector[N] ros;      // outcome vector
}
parameters {
  real alpha;           // intercept - could define weakly informative priors in model block
  real beta_wnd;       // coefficients for predictors
  real beta_rh;       // coefficients for predictors
  real<lower=0> sigma;  // error scale
}
model {
    ros ~ normal(alpha + beta_wnd * wnd + beta_rh * rh, sigma);  // likelihood
}
