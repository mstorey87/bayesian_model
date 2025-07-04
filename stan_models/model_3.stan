
data {
  int N;  // number of observations
  array[N] real<lower=0> y;  // observed values
}
parameters {
  // Unknown average value of windspeed
  real<lower=0.0001> avg_windspeed;
}
model {
  // Relate the observed values to the unknown (to be estimated)
  // average windspeed
  // Each value of y is assumed to come from this distribution
  y ~ exponential(1.0 / avg_windspeed);
}

