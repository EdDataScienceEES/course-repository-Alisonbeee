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



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Answers Below


## Load data

dragons <- read.csv('dragons.csv', header = TRUE)


## Clean the dataset

# Change paprika to turmeric

dragons <- rename(dragons, turmeric = paprika)


# Fix the calibration error for tabasco by horntail

correct.values  <- dragons$tabasco[dragons$species == 'hungarian_horntail'] - 30   # create a vector of corrected values

dragons[dragons$species == 'hungarian_horntail', 'tabasco'] <- correct.values      # overwrite the values in the dragons object

dragons.2 <- mutate(dragons, tabasco = ifelse(species == 'hungarian_horntail', tabasco - 30, tabasco))

# This creates (overwrites) the column tabasco using the following logic: if the species is Hungarian Horntail, deduct 30 from the values in the (original) tabasco column; if the species is NOT horntail (i.e. all other species), write the original values.


# Reshape the data from wide to long format

dragons_long <- gather(dragons, key = 'spice', value = 'plume', c('tabasco', 'jalapeno', 'wasabi', 'turmeric'))


# Convert the data into meters

dragons_long <- mutate(dragons_long, plume.m = plume/100)    # Creating a new column turning cm into m


# Create a subset for each species to make boxplots

horntail <- filter(dragons_long, species == 'hungarian_horntail')            # the dplyr way of filtering
green <- filter(dragons_long, species == 'welsh_green')
shortsnout <- dragons_long[dragons_long$species == 'swedish_shortsnout', ]   # maybe you opted for a base R solution instead?


# Make the boxplots

par(mfrow=c(1, 3))      # you need not have used this, but it splits your plotting device into 3 columns where the plots will appear, so all the plots will be side by side.

boxplot(plume.m ~ spice, data = horntail,
        xlab = 'Spice', ylab = 'Length of fire plume (m)',
        main = 'Hungarian Horntail')


boxplot(plume.m ~ spice, data = green,
        xlab = 'Spice', ylab = 'Length of fire plume (m)',
        main = 'Welsh Green')


boxplot(plume.m ~ spice, data = shortsnout,
        xlab = 'Spice', ylab = 'Length of fire plume (m)',
        main = 'Swedish Shortsnout')


