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


# Crossed random effects and nesting effects
#You could therefore add a random effect structure that accounts for this nesting:
leafLength ~ treatment + (1|Bed/Plant/Leaf)

# What about the crossed effects we mentioned earlier?
leafLength ~ treatment + (1|Bed/Plant/Leaf) + (1|Season)



# Implicit vs. explicit nesting ---- 
  #  avoid implicit nesting
  #  we collected the data on dragons not only across multiple mountain ranges, but also across several sites within those mountain ranges.

head(dragons)  # we have site and mountainRange
str(dragons)  # we took samples from three sites per mountain range and eight mountain ranges in total




# include sites as an additional random effect in our model.
# Our site variable is a three-level factor, with sites called a, b and c.
  # there is nothing linking site b of the Bavarian mountain range with site b of the Central mountain range. 
  # To avoid future confusion we should create a new variable that is explicitly nested. Let’s call it sample:

dragons$mountainRange <- as.factor(dragons$mountainRange)
dragons$site <- as.factor(dragons$site) # need to change to factors for below to work

dragons <- within(dragons, sample <- factor(mountainRange:site))



# Second mixed model ----
mixed.WRONG <- lmer(testScore ~ bodyLength2 + (1|mountainRange) + (1|site), data = dragons)  # treats the two random effects as if they are crossed
summary(mixed.WRONG)
# Shows only 3 sites used when actually 24

# improved one asking:
  # Is there an association between body length and intelligence in dragons after controlling for variation in mountain ranges and sites within mountain ranges? 
mixed.lmer2 <- lmer(testScore ~ bodyLength2 + (1|mountainRange) + (1|sample), data = dragons)  # the syntax stays the same, but now the nesting is taken into account
summary(mixed.lmer2)

# plot this 
(mm_plot <- ggplot(dragons, aes(x = bodyLength, y = testScore, colour = site)) +
    facet_wrap(~mountainRange, nrow=2) +   # a panel for each mountain range
    geom_point(alpha = 0.5) +
    theme_classic() +
    geom_line(data = cbind(dragons, pred = predict(mixed.lmer2)), aes(y = pred), size = 1) +  # adding predicted line from mixed model 
    theme(legend.position = "none",
          panel.spacing = unit(2, "lines"))  # adding space between panels
)





# Introducing random slopes ----

# we often want to fit a random-slope and random-intercept model. 
# We only need to make one change to our model to allow for random slopes as well as intercept, 
# That’s adding the fixed variable into the random effect brackets:

mixed.ranslope <- lmer(testScore ~ bodyLength2 + (1 + bodyLength2|mountainRange/site), data = dragons) 
summary(mixed.ranslope)

### plot
# Notice how the slopes for the different sites and mountain ranges are not parallel anymore?
(mm_plot <- ggplot(dragons, aes(x = bodyLength, y = testScore, colour = site)) +
    facet_wrap(~mountainRange, nrow=2) +   # a panel for each mountain range
    geom_point(alpha = 0.5) +
    theme_classic() +
    geom_line(data = cbind(dragons, pred = predict(mixed.ranslope)), aes(y = pred), size = 1) +  # adding predicted line from mixed model 
    theme(legend.position = "none",
          panel.spacing = unit(2, "lines"))  # adding space between panels
)




# Plotting model predictions ----

library(ggeffects)  # install the package first if you haven't already, then load it

# Extract the prediction data frame
pred.mm <- ggpredict(mixed.lmer2, terms = c("bodyLength2"))  # this gives overall predictions for the model

# Plot the predictions 

(ggplot(pred.mm) + 
    geom_line(aes(x = x, y = predicted)) +          # slope
    geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
                fill = "lightgrey", alpha = 0.5) +  # error band
    geom_point(data = dragons,                      # adding the raw data (scaled values)
               aes(x = bodyLength2, y = testScore, colour = mountainRange)) + 
    labs(x = "Body Length (indexed)", y = "Test Score", 
         title = "Body length does not affect intelligence in dragons") + 
    theme_minimal()
)



# What if you want to visualise how the relationships vary according to different levels of random effects? 
# You can specify type = "re" (for “random effects”) in the ggpredict() function, and add the random effect name to the terms argument.
ggpredict(mixed.lmer2, terms = c("bodyLength2", "mountainRange"), type = "re") %>% 
  plot() +
  labs(x = "Body Length", y = "Test Score", title = "Effect of body size on intelligence in dragons") + 
  theme_minimal()


# Another way to visualise mixed model results
library(sjPlot)

# Visualise random effects 
(re.effects <- plot_model(mixed.ranslope, type = "re", show.values = TRUE))

# show summary
summary(mixed.ranslope)



# To create a table
library(stargazer)
stargazer(mixed.lmer2, type = "text",
          digits = 3,
          star.cutoffs = c(0.05, 0.01, 0.001),
          digit.separator = "")



# Fit the models, a full model and a reduced model in which we dropped our fixed effect (bodyLength2):
full.lmer <- lmer(testScore ~ bodyLength2 + (1|mountainRange) + (1|sample), 
                  data = dragons, REML = FALSE)
reduced.lmer <- lmer(testScore ~ 1 + (1|mountainRange) + (1|sample), 
                     data = dragons, REML = FALSE)

# compare them:
anova(reduced.lmer, full.lmer)  # the two models are not significantly different
