# Data Manipulation - Dragon data Challenge
# 13th Oct 2020
# Alison Stewart

# Aims
# 1. Make the data tidy (long format) 
# 2. Create a boxplot for each species showing the effect of the spices on plume size, 
# 3. Answer the questions: Which spice triggers the most fiery reaction? And the least?

# Also 

# 1.The fourth treatment wasn’t paprika at all, it was turmeric.
# 2.There was a calibration error with the measuring device for the tabasco trial, but only for the Hungarian Horntail species. All measurements are 30 cm higher than they should be.
# 3.The lengths are given in centimeters, but really it would make sense to convert them to meters.

# Install packages
install.packages("tidyr") 
library(tidyr) 
install.packages("dplyr") 
library(dplyr)  

# Set working directory
setwd("~/Desktop/CC-3-DataManip-master")

# Load the elongation data
dragons <- read.csv(file = "~/Desktop/CC-3-DataManip-master/dragons.csv", header = TRUE)   

# Change ID to a factor
dragons$dragon.ID <- as.factor(dragons$dragon.ID)
# Change Paprika to Tumeric
names(dragons)[3] <- "tumeric" 

# calibrate tumeric by 30cm lower for hungarian species
elongation[elongation$Zone == 2 & elongation$Indiv %in% c(300:400), ] 
dragons[dragons$species == hungarian_horntail & dragons$tumeric]




# Change data so it is better for R
dragons_plume <- gather(dragons, spices, plume_size, c(tabasco, jalapeno, wasabi, paprika))



# box plot for species 


boxplot(spices ~ plume_size, data = dragons_plume, xlab = "spices", ylab = "plume_size", main = "Dragon's Plume Size from spices")

