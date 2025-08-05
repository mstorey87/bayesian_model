
parameters {
  real<lower=0, upper=20> windspeed;
}
model {
  windspeed ~ normal(9, 2);
}

