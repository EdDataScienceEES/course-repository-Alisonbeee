# INTRO TO STAN
# Alison Stewart
# 10th Nov 2020



# 1. Learn about Stan ----

setwd("~/Desktop/Github/course-repository-Alisonbeee/Week_8/CC-Stan-intro-master")
seaiceN <- read.csv("seaice.csv")

# Load data
seaice <- read.csv("seaice.csv", stringsAsFactors = F)
head(seaice)

# Rename columns 
colnames(seaice) <- c("year", "extent_north", "extent_south")

# Plot data
plot(extent_north ~ year, pch = 20, data = seaice) 

# Run lm
lm1 <- lm(extent_north ~ year, data = seaice)
summary(lm1)

# Add trend line from lm 
abline(lm1, col = 2, lty = 2, lw = 3)


# NOTE:
# In Stan you need to specify the equation that you are trying to model, so thinking about that model equation is key!
# y = α + β∗x + error <- equation for linear model


# We want to know if sea ice changing from the start of our dataset to the end of our dataset
# Preparing data
x <- I(seaice$year - 1978) # year data to index from 1 to 39 years
y <- seaice$extent_north
N <- length(seaice$year)

# LM with new data
lm1 <- lm(y ~ x)
summary(lm1)

# Extracting key summary statistics 
lm_alpha <- summary(lm1)$coeff[1]  # the intercept
lm_beta <- summary(lm1)$coeff[2]  # the slope
lm_sigma <- sigma(lm1)  # the residual error


# Change dataframe to one for a Stan model
  # Data passed to Stan needs to be a list of named objects
  # The names given here need to match the variable names used in the models 
stan_data <- list(N = N, x = x, y = y)


# Download libraries 
library(rstan)
library(gdata)
library(bayesplot)


# First Stan program ----
# This can be written in your R script, or saved seprately as a .stan file and called into R.

write("// Stan model for simple linear regression

data {
 int < lower = 1 > N; // Sample size
 vector[N] x; // Predictor
 vector[N] y; // Outcome
}

parameters {
 real alpha; // Intercept
 real beta; // Slope (regression coefficients)
 real < lower = 0 > sigma; // Error SD
}

model {
 y ~ normal(alpha + x * beta , sigma);
}

generated quantities {
} // The posterior predictive distribution",

"stan_model1.stan")

# check our Stan model to make sure we wrote a file.
stanc("stan_model1.stan")
stan_model1 <- "stan_model1.stan"


# 4. Running our Stan model ----
# the C++ code needs to be run before R can use the model
install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies = TRUE)
library(rstan)
example(stan_model,run.dontrun = TRUE)


# We fit our model by using the stan() function, 
  # providing it with the model, 
  # the data, and 
  # indicating the number of iterations for warmup 
fit <- stan(file = stan_model1, data = stan_data, warmup = 500, iter = 1000, chains = 4, cores = 2, thin = 1)


# Accessing the contents of a stanfit object
fit # summary of stats

# to assess the output we look at rHat values
# When these are at or near 1, the chains have converged

# look at the full posterior of our parameters
posterior <- extract(fit) # extract() puts the posterior estimates for each parameter into a list.
str(posterior)

# Let’s compare to our previous estimate with “lm”:
plot(y ~ x, pch = 20)

abline(lm1, col = 2, lty = 2, lw = 3)
abline( mean(posterior$alpha), mean(posterior$beta), col = 6, lw = 2)

# The result is identical to the lm output!!
# This is because we are using a simple model, and have put non-informative priors on our parameters.


# visualize the variability in our estimation of the regression line 
for (i in 1:500) {
  abline(posterior$alpha[i], posterior$beta[i], col = "gray", lty = 1)
}

plot(y ~ x, pch = 20)

for (i in 1:500) {
  abline(posterior$alpha[i], posterior$beta[i], col = "gray", lty = 1)
}

abline(mean(posterior$alpha), mean(posterior$beta), col = 6, lw = 2)


# 5. Changing our priors ----
# more informative priors for the relationship between sea ice and time
# If we were to use normal priors with very large standard deviations (say 1000, or 10,000), they would act very similarly to uniform priors.

write("// Stan model for simple linear regression

data {
 int < lower = 1 > N; // Sample size
 vector[N] x; // Predictor
 vector[N] y; // Outcome
}

parameters {
 real alpha; // Intercept
 real beta; // Slope (regression coefficients)
 real < lower = 0 > sigma; // Error SD
}

model {
 alpha ~ normal(10, 0.1);
 beta ~ normal(1, 0.1);
 y ~ normal(alpha + x * beta , sigma);
}

generated quantities {}",

"stan_model2.stan")

stan_model2 <- "~/Desktop/Github/course-repository-Alisonbeee/Week_8/CC-Stan-intro-master/stan_model2.stan"


# We’ll fit this model and compare it to the mean estimate using the uniform priors.
fit2 <- stan(stan_model2, data = stan_data, warmup = 500, iter = 1000, chains = 4, cores = 2, thin = 1)
## This fit is not working??
posterior2 <- extract(fit2)

plot(y ~ x, pch = 20)

abline(alpha, beta, col = 4, lty = 2, lw = 2)
abline(mean(posterior2$alpha), mean(posterior2$beta), col = 3, lw = 2)
abline(mean(posterior$alpha), mean(posterior$beta), col = 36, lw = 3)


# 6. Convergence Diagnostics ----

# The Rhat values, the effective sample size (n_eff),
  # 'Anything over an `n_eff` of 100 is usually "fine"' - Bob Carpenter

# View traceplots 
plot(posterior$alpha, type = "l")
plot(posterior$beta, type = "l")
plot(posterior$sigma, type = "l")

# Poor convergence
# Try running a model for only 50 iterations and check the traceplots.
fit_bad <- stan(stan_model1, data = stan_data, warmup = 25, iter = 50, chains = 4, cores = 2, thin = 1)
posterior_bad <- extract(fit_bad)
# This also has some “divergent transitions” after warmup, indicating a mis-specified model,


plot(posterior_bad$alpha, type = "l")
plot(posterior_bad$beta, type = "l")
plot(posterior_bad$sigma, type = "l")

# Parameter summaries
# get summaries of the parameters through the posterior directly. 
# Let’s also plot the non-Bayesian linear model values to make sure our model is doing what we think it is…
par(mfrow = c(1,3))

plot(density(posterior$alpha), main = "Alpha")
abline(v = lm_alpha, col = 4, lty = 2)

plot(density(posterior$beta), main = "Beta")
abline(v = lm_beta, col = 4, lty = 2)

plot(density(posterior$sigma), main = "Sigma")
abline(v = lm_sigma, col = 4, lty = 2)


# From the posterior we can directly calculate the probability of any parameter being over or under a certain value of interest.

# Probablility that beta is >0:
sum(posterior$beta>0)/length(posterior$beta)
# 0

# Probablility that beta is >0.2:
sum(posterior$beta>0.2)/length(posterior$beta)
# 0


# Diagnostic plots in rstan ----
# this allows us to compare chains 
traceplot(fit)

# posterior desnities and histograms
stan_dens(fit)
stan_hist(fit)

# 95% credible intervals are very small for beta and sigma so will only see dots 
plot(fit, show_density = FALSE, ci_level = 0.5, outer_level = 0.95, fill_color = "salmon")


# Posterior Predictive Checks ----
# Generated Quantities block
write("// Stan model for simple linear regression

data {
 int < lower = 1 > N; // Sample size
 vector[N] x; // Predictor
 vector[N] y; // Outcome
}

parameters {
 real alpha; // Intercept
 real beta; // Slope (regression coefficients)
 real < lower = 0 > sigma; // Error SD
}

model {
 y ~ normal(x * beta + alpha, sigma);
}

generated quantities {
 real y_rep[N];

 for (n in 1:N) {
 y_rep[n] = normal_rng(x[n] * beta + alpha, sigma);
 }

}",

"stan_model2_GQ.stan")

stan_model2_GQ <- ("~/Desktop/Github/course-repository-Alisonbeee/Week_8/CC-Stan-intro-master/stan_model2_GQ.stan")

# vectorization is not supported in the GQ (generated quantities) block, so we have to put it in a loop

fit3 <- stan(stan_model2_GQ, data = stan_data, iter = 1000, chains = 4, cores = 2, thin = 1)


# Extracting the y_rep values from posterior.
y_rep <- as.matrix(fit3, pars = "y_rep")
dim(y_rep) # [1] 2000   39

# Comparing density of y with densities of y over 200 posterior draws.
ppc_dens_overlay(y, y_rep[1:200, ]) # Here we see data (dark blue) fit well with our posterior predictions.

# We can also use this to compare estimates of summary statistics.
ppc_stat(y = y, yrep = y_rep, stat = "mean")

# We can investigate mean posterior prediction per datapoint vs the observed value for each datapoint (default line is 1:1)
ppc_scatter_avg(y = y, yrep = y_rep)



# Result ----
# Sea ice on the decline??




# Bayesplot options ----
# to view all plots
available_ppc()
# View colour scheme 
color_scheme_view(c("blue", "gray", "green", "pink", "purple",
                    "red","teal","yellow"))
# Mix colours
color_scheme_view("mix-blue-red")

# Set colour scheme
color_scheme_set("blue")



