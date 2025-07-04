
data {
  int<lower=0> N;   // number observations
  vector[N] wnd;           // first predictor - wind
  vector[N] rh;           // second predictor - relative humidity
  vector[N] ros;      // outcome - rate of spread
}
parameters {
  real alpha;           // intercept - No specific priors defined but I could define weakly informative priors in model block
  real beta_wnd;       // coefficients for predictors
  real beta_rh;       // coefficients for predictors
  real<lower=0> sigma;  // error scale
}
model {
    ros ~ normal(alpha + beta_wnd * wnd + beta_rh * rh, sigma);  // likelihood. Assuming normal distrubtion for now, but this will need to change
}
