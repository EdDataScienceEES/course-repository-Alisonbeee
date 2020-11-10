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
setwd("~/Desktop/Github/course-repository-Alisonbeee/ProffSkill/untitled folder")

# Install data
Inga_traits <- read_csv(file = "Inga_traits.csv")


# Part 1:
# Histogram
LAI <- Inga_traits$Leaf_Area
hist(LAI, col = "#66CD00")

# hello
log(LAI), col = "#66CDAA")


Log <- log(LAI)


New_data <- log(Inga_traits$P_Leaf)      
Log_new <- aov(New_data ~ Habitat, data = Inga_traits)
summary(Log_new)
AIC(Log_new)

hello <- glm(P_Leaf~Habitat,data=Inga_traits,family=poisson)
summary(hello)   
AIC(hello)
#col = "#66CDAA"))


# Part 2:

# Box plot
Phos_box <- boxplot(P_Leaf ~ Habitat, data = Inga_traits, 
                    xlab = 'Habitat', ylab = 'Phospherous concentration', 
                    main = 'Leaf phosphorous concentration versus habitat')
            
# Statistical significance 
Aov_Phos_box <- aov(P_Leaf ~ Habitat, data = Inga_traits)

habitat_box <- ggplot(Inga_traits, aes(Habitat, P_Leaf)) + geom_boxplot(fill=c("#00FA9A", "#00EEEE", "#009ACD")) + 
    
    scale_fill_manual(values = c("#00FA9A", "#00EEEE", "#009ACD")) +               # Adding custom colours          # Adding custom colours
    ylab("Phospherous concentration") +                             
    xlab("Habitat")  +
    ggtitle("Leaf phosphorous concentration versus habitat") +
    theme(axis.text = element_text(size = 12),
          axis.title = element_text(size = 12, face = "plain"), 
          plot.title = element_text(size=12),
          
                                    # Removing the background grid lines               
          plot.margin = unit(c(1,1,1,1), units = , "cm"),               # Adding a margin
          legend.position = "none")                                  # Removing legend - not needed with only 2 factors




summary(Aov_Phos_box )

AIC(Aov_Phos_box) # -118.7751

TukeyHSD(Aov_Phos_box, conf.level = 0.99)
plot(TukeyHSD(Aov_Phos_box, conf.level = 0.99),las=1, col = "red") # not really sure

par(mfrow=c(2,2)) # Diagnositic checking
plot(Aov_Phos_box)

# Null model
Aov_Phos_box_null <- aov(P_Leaf ~ 1, data = Inga_traits)

AIC(Aov_Phos_box_null) # -107.9913


# how to make first aov better

# Make a plot of leaf Phos (yaxis) vs leaf carbon 
# Make a symbol for each different species
# colour for habitat 




PC_plot <- ggplot(Inga_traits, aes(x = C_Leaf, y = P_Leaf, colour = Habitat)) +
    geom_point() + 
    geom_smooth(method = "lm", aes(fill = Habitat)) + 
    ylab("Phospherous concentration (mg/g)") +                             
    xlab("Carbon concentration (mg/g)")  +
    ggtitle("Leaf P concentration versus Leaf C concentration") +
    theme(axis.text = element_text(size = 12),
          axis.title = element_text(size = 12, face = "plain"), 
          plot.title = element_text(size=12))


# Create a new column with generalist and upland together and floodplain its own 

mutate(flights_sml, gain = dep_delay - arr_delay, hours = air_time / 60, gain_per_hour = gain / hours)

new_col <- mutate(Inga_traits, mixed = Habitat$generalist + Habitat$upland)

new_col <- rbind(Inga_traits, generalist, upland)


x <- as.numeric(paste(x$pgrp, x$fos, sep = ""))

new_col <- as.numeric(paste(Inga_traits$pgrp, x$fos, sep = ""))



inga_new <- Inga_traits %>% mutate(New_Habitat = str_replace_all(Habitat, c("floodplain" = "floodplain", 
                                                                        "upland" = "non_floodplain",
                                                                        " generalist" = "non_floodplain")))

new_lm <- lm(P_Leaf ~ C_Leaf * New_Habitat, data = inga_new)
new_glm <- glm(P_Leaf ~ C_Leaf * New_Habitat, data = inga_new, family = poisson)

summary(new_glm)
summary(new_lm)
summary(ano)
AIC(new_lm)
v## 

ano <- anova(new_lm)

par(mfrow=c(2,2)) # Diagnositic checking
plot(new_lm)

TukeyHSD(ano, conf.level = 0.99)
plot(TukeyHSD(Aov_Phos_box, conf.level = 0.99),las=1, col = "red")



## glmms


glm(thibaudiana~Habitat,data=combo,family=poisson)
#null
glm(thibaudiana~1,data=combo,family=poisson)

# these work 
mod1 <- glm(Mevalonic_Acid~Expansion, data = Inga_traits, family = poisson)
mod2 <- glm(Mevalonic_Acid~Trichome_Density, data = Inga_traits, family = poisson)   
    
summary(mod1)
summary(mod2)
## adding together
mod3 <- glm(thibaudiana~Habitat + Soil_pH,data=combo,family=poisson)
mod4 <- glm(thibaudiana~Habitat * Soil_pH,data=combo,family=poisson)

mod3 <- glm(Mevalonic_Acid~Expansion * Trichome_Density, data = Inga_traits, family = poisson)
summary(mod3)

mod3 <- glm(Mevalonic_Acid~Trichome_Density + Expansion, data = Inga_traits, family = poisson)




# plotting results
combo1 <- Inga_traits[Inga_traits$Mevalonic_Acid=="1",]
combo0 <- Inga_traits[Inga_traits$Mevalonic_Acid=="0",]
plot <- plot(Inga_traits$Trichome_Density,Inga_traits$Expansion,type="n")
points(combo1$Trichome_Density,combo1$Expansion,pch=21,bg="blue")
points(combo0$Trichome_Density,combo0$Expansion,pch=24,bg="red")
legend(40,40, legend=c("presence", "absence"),
       col=c("red", "blue"),lty=1:2, cex=0.8)
title(main="Presence or Absence of Mevalonic Acid")
     



combo_fp <- combo[combo$Habitat=="floodplain",]
combo_up <- combo[combo$Habitat=="upland",]
plot(combo$Soil_pH,combo$thibaudiana,type="n")
points(combo_fp$Soil_pH,combo_fp$thibaudiana,pch=21,bg="blue")
points(combo_up$Soil_pH,combo_up$thibaudiana,pch=24,bg="red")
points(combo$Soil_pH,fitted(mod3), col="grey")

