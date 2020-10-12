# Exercise 4: Mixed Effects Models

# When you ‘mix’ together fixed and random effects, you have mixed effects models

# In the data that we have been working with, we might consider river basin to be 
# a random effect for which we wish to control when we are studying the effect of habitat or other variables on soils.

# Need to install
install.packages("lme4")
library(lme4)


# This helps evalutate mixed models
install.packages("MuMIn")
library(MuMIn)
# lmer() = lm  # glmer() = glm - these are the workhouse functions for this package

# adding river basin into the model greatly improves the model fit. 
# Allowing for interaction, i.e. allowing for different river basins to differ in how phosphorous varies between upland and floodplain habitats, appears to achieve a better fit
# log is skuqeued so we use log 
P_model1 <- lm(log(Phosphorus)~Habitat,data=soils)
P_model2 <- lm(log(Phosphorus)~Habitat+River_Basin,data=soils)
P_model3 <- lm(log(Phosphorus)~Habitat*River_Basin,data=soils)
# AICc as an information criterion, because it is considered better for datasets with small sample size
AICc(P_model1,P_model2,P_model3)
AIC(P_model1,P_model2,P_model3)

# using MuMIn package
# REML = FALSE it means that we can compare models that we fit (if it is TRUE your models are not comparable)
P_model4 <- lmer(log(Phosphorus)~Habitat+(1|River_Basin),data=soils,REML=FALSE)
P_model4
summary(P_model4)
# In the summary/random effects: the variance is not 0 which means
## (suggests) that this random effect is meaningful
### (i.e. the river basins do have pretty different values for soil phosphorous)
# Fixed effect table not that important

# Tables have no p values so to test for significance we are comparing AIC values
P_null <- lmer(log(Phosphorus)~1+(1|River_Basin),data=soils,REML=FALSE)
AICc(P_null, P_model4)
# we can infer that habitat has a significant effect on the phosphorus content of soils, even while accounting for the effect of different river basins. 

# compare this to models without random effects
P_null_lm <- lm(log(Phosphorus)~1,data=soils)
AIC(P_null_lm, P_model1,P_null,P_model4)
# random effect improves model 

#Visualise random effect
par(mfrow=c(1,2))
plot(log(soils$Phosphorus),fitted(P_model1))
abline(0,1)
plot(log(soils$Phosphorus),fitted(P_model4))
abline(0,1)
# plotting observed versus predicted values is one of the main ways in which we evaluate mixed effects models
# also plot residuals versus our predictors, to ensure that there are not biases in our predictions, heteroscedasticity issues and so forth. 

# the variance between habitat is dependent on river basin in model 5
# equivalent mixed effects model, which is allowing for random intercepts and random ‘slopes’
P_model5 <- lmer(log(Phosphorus)~Habitat+(Habitat|River_Basin),data=soils,REML=FALSE)
AICc(P_model1,P_model4,P_model5)
#allowing for different river basins to differ in how floodplain and upland soils vary does not really improve our model. 


# New fashionable way to see how good a mixed effect model is
# function from the MuMIn package to calculate these pseudo-R2 values and compare them across models.
r.squaredGLMM(P_model1)
r.squaredGLMM(P_model4)
r.squaredGLMM(P_model5)

# The function gives you a marginal (R2m) and 
# conditional (R2c) for each model. 
# full explanation of this in word doc

# difference between R squared (as a measure how strong the respose variable is)
# and pseudo R squared (math is different) (measuring strenght of the interations?)(you need to use this one for GLMM)
# Do not use pseudo R squared to chose between models better to use AIC, dont use because you could be over fitting
# in picture 1 (there are just two values for fitted because there is only one predictor)
# in picture 2 (there are are 9 levels of y axis( 5 and 4 riverbasins) x vaires with the river basin )

# its ok to be a bit confused as this is complex 

