
data {
  int N;  // total number of observations
  int M;  // number of spread lines
  array[N] real<lower=0> windspeed;  // observed values
  array[N] real<lower=0> rh;  // observed values
  array[N] int x;  // location index (from 1) for each observation
}
parameters {
  // Unknown average value of waiting time at each location
  array[M] real<lower=0> avg_windspeed;
  array[M] real<lower=0> avg_rh;
}
model {
  // Relate the observed values to the unknown (to be estimated)
  // average duration. 
  // Note how we don't need an explicit loop here although we could do that 
  // for clarity at the expense of slightly longer computation time.
  // Also note that if we did 1.0/avg_windspeed[x] this would provoke an error
  // from Stan which is very picky about vector lengths etc.
  //
  windspeed ~ exponential(avg_windspeed[x]^(-1));
  rh ~ exponential(avg_rh[x]^(-1));
}

