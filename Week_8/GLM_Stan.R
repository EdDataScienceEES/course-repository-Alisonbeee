# GENERALISED LINEAR MODELS IN STAN
  # USING THE RSTANARM AND BRMS PACKAGES TO RUN STAN MODELS
# By coding club 
# Alison Stewart
# 12th Oct 2020
# alisondianastewart@gmail.com


# Load libraries ----
library(rstanarm)
library(brms)  # for models
library(bayesplot)
library(ggplot2)
library(dplyr)
library(tidybayes)
library(modelr)

# Load data ----
# Remember to set your working directory to the folder
# where you saved the workshop files
toolik_richness <- read.csv("toolik_richness.csv")

# Inspect data
head(toolik_richness)

# Change plot no. to a categorical variable
toolik_richness$Plot <- as.factor(as.character(toolik_richness$Plot))

# Histogram ----
(hist <- ggplot(toolik_richness, aes(x = Richness)) +
    geom_histogram() +
    theme_classic())

# Data is right skewed
# a Poisson distribution might be suitable for our model.
#  In Stan, we usually run two or more chains 
  # - different iterations of our model which we can then compare

# One disadvantage to Stan models:
# is that the code can take a while to finish running, even if we use all of our computer cores,


# Today we will:
# focus on species richness change within just one of the plots. 
# In that case, the model does not need to include random effects, because on the plot level, there is no replication.


# Model for species richness change:
# Note - this code could take hours to run!
# We are running the model using the default weakly informative priors.
# More about priors coming later in the tutorial!
# stan_lm <- stan_glmer(Richness ~ I(Year-2007) + (1|Site/Block/Plot),
#                     data = toolik_richness, family = poisson,
#                     chains = 4, cores = 4)

# Assess converge by looking at the trace plots
# plot(stan_lm, plotfun = "trace")

# Explore the summary output
# summary(stan_lm)



# Run simplified model ----
unique(toolik_richness$Year)

# There are four years of data from 2008 to 2012. 
# transform the year variable into a continuous variable where the first year is year one, i.e., 2008 is 1, 2009 is 2
# That way, the model won’t have to estimate richness in the year 500, the year 501, etc., it will start straight from our first monitoring year.

# Note how now we are using stan_glm because
# there are no random effects
stan_glm1 <- stan_glm(Richness ~ I(Year-2007),
                      data = toolik_richness, family = poisson,
                      chains = 4, cores = 4)


# 3. Assessing model convergence
# One way to assess model convergence is by visually examining the trace plots. They should be fuzzy with no big gaps, breaks or gigantic spikes.
plot(stan_glm1, plotfun = "trace")
summary(stan_glm1)






