
data {
  int N;  // number of observations
  array[N] real<lower=0> y;  // observed values
}
parameters {
  // Unknown average value of windspeed. i.e unknown real value of mean windspeed (we could get the mean of our observed data, but that would just be the mean of a small sample. We want to estimate the population mean)
  real avg_windspeed;
  
  // Unknown standard deviation of the (assumed) normal distribution
  real<lower=0> sigma;
}
model {
  // Relate the observed values to the unknown (to be estimated)
  // average windspeed
  // Each value of y is assumed to come from this distribution. 
  sigma ~ exponential(1); // weakly informative prior. ie believe that sd of our normal is from this distribution
  y ~ normal(avg_windspeed, sigma); // our likelihood. We assume observed data generated from normal distribution
}

