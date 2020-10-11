#Exericise 2

# write row.names and string factors 
# ask why do we do this??
inga <- read.csv(file="~/Desktop/rstudio/Inga_abundances.csv",row.names=1,stringsAsFactors=T)

# a function to bind together the rownames of the two dataframes 
# (which are essentially columns, thus cbind rather than rbind, which is for rows)
cbind(rownames(soils),rownames(inga))

# As we can see the rownames match up. Thus we can actually bind 
# these two dataframes together into a single one using the same function.
combo <- cbind(soils,inga)

# generalised linear models to assess how the abundance of different 
# species varies with soil characteristics and habitat type. 
# Let’s start with thibaudiana

# We added one argument ‘family’. This allows us to specify what 
# probability distribution we use to model the response variable. 
# As these are count data that cannot be negative, we will use a poisson
mod1 <- glm(thibaudiana~Habitat,data=combo,family=poisson)

# results of the glm
mod1
# we get a negative intercept because we are using a log link]
# it is the poisson thing that does the log link? i think

# value for intercept: this results the same value as below
exp(-1.946) 
mean(combo$thibaudiana[combo$Habitat=="floodplain"])

# You can also make sure this works for uplands
exp(-1.946+4.518)
mean(combo$thibaudiana[combo$Habitat=="upland"])


# If the variance is greater than the mean in your data/model, then 
# you have what is called overdispersion. This can quickly be checked
# here by dividing the residual deviance (also given) by the residual
# degrees of freedom. If this value is greater than one, then you have overdispersion

# there is over despersion because 48.67/23 > 1
## for now we are pretending things are ok and coming back to this

summary(mod1)

# some statistical tests have been run but it assumes dispersion
# ratio is < 1 meaning the results of these tests should not be trusted

# testing if a null model fits better than the possion with habitat fit
# the 1 doesnt mean anothing other than how "R" speaks
mod_null <- glm(thibaudiana~1,data=combo,family=poisson)
AIC(mod_null,mod1)

# AIC is smaller for habitat model compared to null so even though
# there are issues it is still a better fit
# rule of thumb is if the difference is 2 or less then they are same

# checking if soil pH variables explain the variation in abundance comapred to habitat
mod2 <- glm(thibaudiana~Soil_pH,data=combo,family=poisson)
summary(mod2)
AIC(mod_null,mod1,mod2)

# AIC is still smallest for habitat but pH is smaller than null
# Now construct multivariate models with both of them and to check how that performs.
mod3 <- glm(thibaudiana~Habitat + Soil_pH,data=combo,family=poisson)
mod4 <- glm(thibaudiana~Habitat * Soil_pH,data=combo,family=poisson)
AIC(mod_null,mod1,mod2,mod3,mod4)

# Using variables together results in an better model 
## mod 4 had slighter higher AIC because we included an interaction
## term (*) 
summary(mod3)

# going back there is still overdispersion
# means that the data are more variable than predicted by our model.
# need to simplify the data to presence/absence data

#Notice that I obtain the predicted values using the ‘fitted’ function 
#rather than the ‘predict’ function, because this quickly gives the 
#predicted values in units of the response variable (after the link 
#function has been applied).
plot(combo$thibaudiana,fitted(mod3),xlab="Observed",ylab="predicted")
abline(0,1)
# does not predict how abundant it can be at high abundances

# To further explore this, one could plot the residual values versus our explanatory variables.
par(mfrow=c(1,2))
plot(resid(mod3)~Habitat,data=combo)
plot(resid(mod3)~Soil_pH,data=combo)

# see here is a lot of variability around the predicted mean in uplands, but little in floodplain
# we can see that there is a lot of variability in abundance that is not explained by soil pH at low pH values 
# This gives us some insight into the observed overdispersion
# Basically, there is something else affecting the abundance of Inga thibaudiana in uplands sites, besides soil pH, that we have failed to account for in our model. 

# plot raw data
combo_fp <- combo[combo$Habitat=="floodplain",]
combo_up <- combo[combo$Habitat=="upland",]
plot(combo$Soil_pH,combo$thibaudiana,type="n")
points(combo_fp$Soil_pH,combo_fp$thibaudiana,pch=21,bg="blue")
points(combo_up$Soil_pH,combo_up$thibaudiana,pch=24,bg="red")
points(combo$Soil_pH,fitted(mod3), col="grey")

# this model is not the best but it is much better than a nullmodel

# Be sure to check for overdispersion though, as most species show overdispersion issues.

