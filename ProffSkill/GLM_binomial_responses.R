# Exercise 3 
# Generalised Linear Models (GLMs) with a Binomial Response

# Let’s check out Inga auristellae, a species that would have shown exceptional overdispersion issues if you had tried to analyse it with poisson models above.
# look at the influence of soil pH on whether or not Inga auristellae is present. 
# We must first recode Inga auristellae as a presence/absence variable, which can be done with values of 1 and 0.


combo$auristellae_PA <- combo$auristellae
combo$auristellae_PA[combo$auristellae_PA>0] <- 1
mod1 <- glm(auristellae_PA~Soil_pH,data=combo,family=binomial)
summary(mod1)
# Questions, what does combo mean? what does PA mean? 
# basically what on the earth is going on above
# PA = predicted as present i think??


# Compare glm to the null model
mod_null <- glm(auristellae_PA~1,data=combo,family=binomial)
AIC(mod_null, mod1)
# mod1 smaller value = better fit
# so, soil pH does seem to affect Inga auristellae presence


# more models with habitat and other variables
mod2 <- glm(auristellae_PA~ Habitat,data=combo,family=binomial)
mod3 <- glm(auristellae_PA~Soil_pH + Habitat,data=combo,family=binomial)
mod4 <- glm(auristellae_PA~Soil_pH * Habitat,data=combo,family=binomial)
AIC(mod_null, mod1, mod2, mod3, mod4)
# We see that the model with just habitat is almost as good 
## at explaining presence vs. absence of Inga auristellae as soil pH. 
# The reason that soil and Habitat together dont have a better AIC value
## is because these two variables are communicating the same information and are redundant on each other. 


# Validating model 
plot(auristellae_PA~Soil_pH,data=combo,pch=16)
points(combo$Soil_pH,fitted(mod1), col="grey")

