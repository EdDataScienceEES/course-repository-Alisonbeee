# Professional Skills: Stats Assessment 2020
# Alison Stewart
# alisondianastewart@gmail.com
# 26th Oct 2020

# Set libraries
library(tidyverse)
library(dplyr)
library(lme4)
library(MuMIn)
library(ggplot2)

# Set working directory
setwd("~/Desktop/Github/course-repository-Alisonbeee")

# Install data
Inga_traits <- read_csv(file = "Inga_traits.cvs")


# Part 1:
# Histogram
LAI <- Inga_traits$Leaf_Area
hist(LAI)

# log transform histogram
hist(log(LAI)) 


# Part 2:

# Box plot
Phos_box <- boxplot(P_Leaf ~ Habitat, data = Inga_traits, 
                    xlab = 'Habitat', ylab = 'Phospherous concentration', 
                    main = 'Leaf phosphorous concentration versus habitat')
            
# Statistical significance 
Aov_Phos_box <- aov(P_Leaf ~ Habitat, data = Inga_traits)

summary(Aov_Phos_box)

AIC(Aov_Phos_box) # -118.7751

TukeyHSD(Aov_Phos_box, conf.level = 0.99)
plot(TukeyHSD(Aov_Phos_box, conf.level = 0.99),las=1, col = "red") # not really sure

par(mfrow=c(2,2)) # Diagnositic checking
plot(Aov_Phos_box)

# Null model
Aov_Phos_box_null <- aov(P_Leaf ~ 1, data = Inga_traits)

AIC(Aov_Phos_box_null) # -107.9913


# how to make first aov better
