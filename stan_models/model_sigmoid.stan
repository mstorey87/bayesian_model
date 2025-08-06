
data {
  int<lower=1> W;
  int<lower=1> L;

  array[W] int<lower=1> wline_id;
  vector<lower=0>[W] wind;
  vector<lower=0>[W] rh;
  vector<lower=0>[L] ros;
}
parameters {
  vector[L] avg_wind;
  real<lower=0> sigma_wind;

  vector<lower=0.01, upper=0.99>[L] avg_rh;
  real<lower=0, upper=50> phi_rh;

  real alpha;
  real beta_wind;
  real beta_rh;

  real<lower=0> shape_ros;
}
model {
  real max_ros = 15;
  vector[L] mu;
  vector[L] rate;

  for (i in 1:W) {
    wind[i] ~ normal(avg_wind[wline_id[i]], sigma_wind);
    rh[i] ~ beta_proportion(avg_rh[wline_id[i]], phi_rh + 1);
  }

  for (i in 1:L) {
    real linpred = alpha + beta_wind * avg_wind[i] + beta_rh * avg_rh[i];
    mu[i] = max_ros / (1 + exp(linpred));
    rate[i] = shape_ros / mu[i];
  }

  ros ~ gamma(shape_ros, rate);
}

