# Basic Data Manipulation Tutorial
# 12th Oct 2020
# Alison Stewart

# Aims: 1. Learn base R syntax for data manipulation
      # 2. Turn messy data into tidy data with tidyr
      # 3. Use efficient tools from the dplyr package to manipulate data

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 1. Subset, extract and modify data with R operators

# Set your working directory to where the folder is saved on your computer
setwd("~/Desktop/CC-3-DataManip-master")

# Load the elongation data
elongation <- read.csv(file = "~/Desktop/CC-3-DataManip-master/EmpetrumElongation.csv", header = TRUE)   

# Check import and preview data
head(elongation)   # first few observations
str(elongation)    # types of variables

# Let's get some information out of this object!
elongation$Indiv   # prints out all the ID codes in the dataset
length(unique(elongation$Indiv))   # returns the number of distinct shrubs in the data

# Here's how we get the value in the second row and fifth column
elongation[2,5]

# Here's how we get all the info for row number 6
elongation[6, ]

# And of course you can mix it all together! 
elongation[6, ]$Indiv   # returns the value in the column Indiv for the sixth observation
# (much easier calling columns by their names than figuring out where they are!) 

## So far so good (I understand) 
## Using above can be tedious so not recommended

# So instead we use logical operations to access specific parts of data
# Let's access the values for Individual number 603
elongation[elongation$Indiv == 603, ]

# We are saying above
# Take the elongation data and subset it to keep the rows where the value in the column Indiv ($Indiv) is exactly (==) 603

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# There are different operators to manipulate data such as == != %in% (all in notes)

# Lets see how they are used:
# Subsetting with one condition

elongation[elongation$Zone < 4, ]    # returns only the data for zones 2-3
# less than 4
elongation[elongation$Zone <= 4, ]   # returns only the data for zones 2-3-4
# less than or == to 4

# This is completely equivalent to the last statement
elongation[!elongation$Zone >= 5, ]   # the ! means exclude
# exclude zones greater than or == to 5

# Subsetting with two conditions
elongation[elongation$Zone == 2 | elongation$Zone == 7, ]    # returns only data for zones 2 and 7
elongation[elongation$Zone == 2 & elongation$Indiv %in% c(300:400), ]    # returns data for shrubs in zone 2 whose ID numbers are between 300 and 400

# c() to concatenate elements in a vector, : count from one no. to another

# vector bilders
seq(300, 400, 10) # 300 to 400 in multiples of 10
rep(seq(0, 30, 10), 4) # 0 to 30 in multiples of 10 ~ 4 times 
rep(c(1,2), 3) # repetitions of 1 and 2 ~ 3 times


## CHANGING VARIABLE NAMES AND VALUES IN A DATA FRAME

# Let's create a working copy of our object
elong2 <- elongation

# Now suppose you want to change the name of a column: you can use the names() function
# Used on its own, it returns a vector of the names of the columns. Used on the left side of the assign arrow, it overwrites all or some of the names to value(s) of your choice. 

names(elong2)                 # returns the names of the columns

names(elong2)[1] <- "zone"    # Changing Zone to zone: we call the 1st element of the names vector using brackets, and assign it a new value
names(elong2)[2] <- "ID"      # Changing Indiv to ID: we call the 2nd element and assign it the desired value

# Now suppose there's a mistake in the data, and the value 5.1 for individual 373 in year 2008 should really be 5.7

## - option 1: you can use row and column number
elong2[1,4] <- 5.7

## - option 2: you can use logical conditions for more control
elong2[elong2$ID == 373, ]$X2008 <- 5.7   # completely equivalent to option 1

# think I'll stick to option 1 for now but 2 is good if the change is deeper in that data set


## CREATING A FACTOR

# Let's check the classes 
str(elong2)

# The zone column shows as integer data (whole numbers), but it's really a grouping factor (the zones could have been called A, B, C, etc.) Let's turn it into a factor:

elong2$zone <- as.factor(elong2$zone)        # converting and overwriting original class
str(elong2)                                  # now zone is a factor with 6 levels

## CHANGING A FACTOR'S LEVELS
  # to letters instead of numbers

levels(elong2$zone)  # shows the different factor levels

levels(elong2$zone) <- c("A", "B", "C", "D", "E", "F")   # you can overwrite the original levels with new names

# You must make sure that you have a vector the same length as the number of factors, and pay attention to the order in which they appear!

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. What is tidy data, and how do we achieve it?

# The enlong data is currently not in a "good & tidy" form so we need to adjust this for further analysis in R

install.packages("tidyr")  # install the package
library(tidyr)             # load the package


elongation_long <- gather(elongation, Year, Length,                           # in this order: data frame, key, value
                          c(X2007, X2008, X2009, X2010, X2011, X2012))        # we need to specify which columns to gather

# Here we want the lengths (value) to be gathered by year (key) 

# Let's reverse! spread() is the inverse function, allowing you to go from long to wide format
elongation_wide <- spread(elongation_long, Year, Length) 

# If I have a larger data set I want to gather e.g. 100 it would be better to state collums instead
elongation_long2 <- gather(elongation, Year, Length, c(3:8))


# If we want to find there is an inter-annual variation in the growth of Empetrum hermaphroditum, we can quickly make a boxplot: 
boxplot(Length ~ Year, data = elongation_long, 
        xlab = "Year", ylab = "Elongation (cm)", 
        main = "Annual growth of Empetrum hermaphroditum")

# No significant change due to heavy overlap in each year

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3. Explore the most common and useful functions of dplyr


# 3a. Rename Variables
install.packages("dplyr")  # install the package
library(dplyr)              # load the package

# Getting rid of captital letters
elongation_long <- rename(elongation_long, zone = Zone, indiv = Indiv, year = Year, length = Length)     # changes the names of the columns (getting rid of capital letters) and overwriting our data frame

# As we saw earlier, the base R equivalent would have been
names(elongation_long) <- c("zone", "indiv", "year", "length")


# 3b. filter() rows and select() columns

# FILTER OBSERVATIONS

# Let's keep observations from zones 2 and 3 only, and from years 2009 to 2011

elong_subset <- filter(elongation_long, zone %in% c(2, 3), year %in% c("X2009", "X2010", "X2011")) # you can use multiple different conditions separated by commas

# For comparison, the base R equivalent would be (not assigned to an object here):
elongation_long[elongation_long$zone %in% c(2,3) & elongation_long$year %in% c("X2009", "X2010", "X2011"), ]

#  we use %in% as a logical operator because we are looking to match a list of exact (character) values
 
# NOTES:
 # between() hack
# length > 4 & length <= 6.5 or you can use the convenient between() function, e.g. between(length, 4, 6.5).

# Need to put characters in "" but not integers (numbers)

# SELECT COLUMNS

# Let's ditch the zone column just as an example

elong_no.zone <- dplyr::select(elongation_long, indiv, year, length)   # or alternatively
elong_no.zone <- dplyr::select(elongation_long, -zone) # the minus sign removes the column

# For comparison, the base R equivalent would be (not assigned to an object here):
elongation_long[ , -1]  # removes first column

# A nice hack! select() lets you rename and reorder columns on the fly
elong_no.zone <- dplyr::select(elongation_long, Year = year, Shrub.ID = indiv, Growth = length)

# Neat, uh?

# 3c. mutate() your dataset by creating new columns
# CREATE A NEW COLUMN 
elong_total <- mutate(elongation, total.growth = X2007 + X2008 + X2009 + X2010 + X2011 + X2012)


# 3d. group_by() certain factors to perform operations on chunks of data
# GROUP DATA

# I can't see a change in data but it creates an internal grouping structure, 
# which means that every subsequent function you run on it will use these groups, and not the whole dataset, as an input.
elong_grouped <- group_by(elongation_long, indiv)   # grouping our dataset by individual


# 3e. summarise() data with a range of summary statistics
# SUMMARISING OUR DATA

summary1 <- summarise(elongation_long, total.growth = sum(length))
summary2 <- summarise(elong_grouped, total.growth = sum(length))

summary3 <- summarise(elong_grouped, total.growth = sum(length),
                      mean.growth = mean(length),
                      sd.growth = sd(length))

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4. ..._join() datasets based on shared attributes
# Merging data sets

# Load the treatments associated with each individual

treatments <- read.csv("EmpetrumTreatments.csv", header = TRUE, sep = ";")
head(treatments)

# Join the two data frames by ID code. The column names are spelled differently, so we need to tell the function which columns represent a match. We have two columns that contain the same information in both datasets: zone and individual ID.

experiment <- left_join(elongation_long, treatments, by = c("indiv" = "Indiv", "zone" = "Zone"))

# We see that the new object has the same length as our first data frame, which is what we want. And the treatments corresponding to each plant have been added!

# Base R funtion to do the same is:
experiment2 <- merge(elongation_long, treatments, by.x = c("zone", "indiv"), by.y = c("Zone", "Indiv"))  
# same result!

# effect of adding treatments to our data:
boxplot(length ~ Treatment, data = experiment)
# Is this statically significant?
# Find out later in the chronicles of data science :) 


