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




