#Exercise 1: AIC

#First, we need to import the data again and create these statistical models.
soils <- read.csv(file="~/Desktop/rstudio/Peru_Soil_Data.csv", row.names=1, stringsAsFactors=T)
lm_Habitat <- lm(Soil_pH~Habitat,data=soils)
lm_TBS<- lm(Soil_pH~Total_Base_Saturation,data=soils)
lm_Habitat_TBS <- lm(Soil_pH~Habitat + Total_Base_Saturation,data=soils)
lm_Habitat_TBS_Interaction <-lm(Soil_pH~Habitat*Total_Base_Saturation, data=soils)

#Now let’s compare their AIC values
AIC(lm_Habitat, lm_TBS, lm_Habitat_TBS, lm_Habitat_TBS_Interaction)

# AIC smallest for lm_Habitat_TBS
# lower AIC values reflect better models. 
# Thus, the AIC for the model without interaction is the lowest, 
# suggesting it is the best model (similar to the result when consider R-squared values). 

# Calculating the AIC from scratch
# AIC = 2k - 2*log, where k is the number of parameters in the model
logLik(lm_Habitat_TBS) #gives a value of 3.59134
2*4 - 2*3.59134 # value = 0.81732


