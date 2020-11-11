# INTRODUCTION TO LINEAR MIXED MODELS
# 4th Nov 2020
# Alison Stewart - alisondianastewart@gmail.com
# Created by Gabriela K Hajduk - last updated 10th September 2019 by Sandra

# Explore the data ----
setwd("~/Desktop/Github/course-repository-Alisonbeee/Week_7")
write_csv(dragons, "dragons.csv")
dragons <- read_csv("dragons.csv")


# Our aim is to train dragons so we are collecting evidence of dragon intelligence
# Testing body size, site and mountain range
head(dragons)
hist(dragons$testScore)  # seems close to a normal distribution - good!


# It is good practice to standardise your explanatory variables before proceeding 
# so that they have a mean of zero (“centering”) and standard deviation of one (“scaling”)
dragons$bodyLength2 <- scale(dragons$bodyLength, center = TRUE, scale = TRUE)
# scale() centers the data
# It ensures that the estimated coefficients are all on the same scale, making it easier to compare effect sizes



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3. Fit all data in one analysis ----
# One way to analyse this data would be to fit a linear model to all our data, ignoring the sites and the mountain ranges for now.

basic.lm <- lm(testScore ~ bodyLength2, data = dragons)
summary(basic.lm)
# results suggest that there is a significant interaction between body lenght and testscore


# Plotting data
library(ggplot2)  # load the package

(prelim_plot <- ggplot(dragons, aes(x = bodyLength, y = testScore)) +
    geom_point() +
    geom_smooth(method = "lm"))
# Suggests as body length increases so does test score


# Check residuals plot to see if model fits 
plot(basic.lm, which = 1)  # not perfect... 
## but since this is a fictional example we will go with it
## for your own data be careful:
## the bigger the sample size, the less of a trend you'd expect to see

#Plot Q-Q 
plot(basic.lm, which = 2)  # a bit off at the extremes, but that's often the case; again doesn't look too bad
# However, what about observation independence? Are our data independent?

# Check is data is similar within mountain ranges  
boxplot(testScore ~ mountainRange, data = dragons)  # certainly looks like something is going on here

# plot it and colour points by mountain range:
(colour_plot <- ggplot(dragons, aes(x = bodyLength, y = testScore, colour = mountainRange)) +
    geom_point(size = 2) +
    theme_classic() +
    theme(legend.position = "none"))


# Now it appears that moutain range effects testscore and body lenght 
# This means that data within is not indepdendent of which mountain range 
# Possible pseudoreplication 


# Rum multiple analysis ----
# We could run many separate analyses and fit a regression for each of the mountain ranges.
# We use the facet_wrap to do that:
(split_plot <- ggplot(aes(bodyLength, testScore), data = dragons) + 
   geom_point() + 
   facet_wrap(~ mountainRange) + # create a facet for each mountain range
   xlab("length") + 
   ylab("test score"))

# We can see all sites converge in different clusters 
# There are different sites in each mountain ranges so we could:
# run an analysis for each site in each range separately. 

# To do the above, we would have to estimate a slope and intercept parameter for each regression. 
# That’s two parameters, three sites and eight mountain ranges, which means 48 parameter estimates (2 x 3 x 8 = 48)! 
# Moreover, the sample size for each analysis would be only 20 (dragons per site).

# ABOVE basically states that we cannot run each site separately due to limited sample size 


# 5. Modify the current model ----
# So, we want to use all the data, but account for the data coming from different mountain ranges
mountain.lm <- lm(testScore ~ bodyLength2 + mountainRange, data = dragons)
summary(mountain.lm) # All ranges are signifcant but not body lenght 

# we just want to know whether body length affects test scores and we want to simply control for the variation coming from mountain ranges.
# Above adding mountatinrange: This is what we refer to as “random factors” and so we arrive at mixed effects models. Ta-daa!


# 6. Mixed effects models ----
library(lme4)
# A mixed model is a good choice here: it will allow us to use all the data we have
# Fixed and random effects


# We are not really interested in the effect of each specific mountain range on the 
# test score: we hope our model would also be generalisable to dragons from other mountain ranges! 
# However, we know that the test scores from within the ranges might be correlated so we want to control for that.

# If we specifically chose eight particular mountain ranges a priori and 
# we were interested in those ranges and wanted to make predictions about them, then mountain range would be fitted as a fixed effect.

# We have a response variable, the test score and we are attempting to explain part of the variation in test score through fitting body length as a fixed effect.
mixed.lmer <- lmer(testScore ~ bodyLength2 + (1|mountainRange), data = dragons)
summary(mixed.lmer)
# Body length doesnt have an effect on scores because:
# Take a look at the summary output: (fixed effects) notice how the model estimate is smaller than its associated error? That means that the effect, or slope, cannot be distinguised from zero.

# We can see the variance for mountainRange = 339.7. 
# Mountain ranges are clearly important: they explain a lot of variation.
339.7/(339.7 + 223.8)  # ~60 %
#  mountain ranges explain ~60% of the variance that’s “left over”

plot(mixed.lmer)  # looks alright, no patterns evident
qqnorm(resid(mixed.lmer))
qqline(resid(mixed.lmer))  # points fall nicely onto the line - good!qqline(resid(mixed.lmer))  # points fall nicely onto the line - good!



# Types of random effects ----
# Above, we used (1|mountainRange) to fit our random effect. 
# Whatever is on the right side of the | operator is a factor and referred to as a “grouping factor” for the term.
# random effects (factors) can be crossed or nested - it depends on the relationship between the variables. Let’s have a look.


# Crossed random effects

