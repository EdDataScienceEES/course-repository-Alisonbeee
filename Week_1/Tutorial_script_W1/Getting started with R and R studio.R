# Coding Club Workshop 1 - R Basics
# Learning how to import and explore data, and make graphs about Edinburgh's biodiversity
# Written by Gergana Daskalova 06/11/2016 University of Edinburgh

install.packages("dplyr")
# Note that there are quotation marks when installing a package, but not when loading it
# and remember that hashtags let you add useful notes to your code! 

setwd("~/Desktop/Github/course-repository-Alisonbeee/Week_1")
# This is an example filepath, alter to your own filepath

# Importing Edinburgh Biodiversity Data, publicly available from the NBN Gateway https://data.nbn.org.uk/

# Add informative header

# Add libraries for packages

library(dplyr)
# Insert code to import data here
edidiv <- read.csv("edidiv.csv")


# It's good practice to always check your imported data before starting analysis
head(edidiv)
tail(edidiv)
str(edidiv)

head(edidiv$taxonGroup)     # Displays the first few rows of this column only
class(edidiv$taxonGroup)    # Tells you what type of variable we're dealing with: it's character now but we want it to be a factor
edidiv$taxonGroup <- as.factor(edidiv$taxonGroup)     # What are we doing here?! Now this is a factor not character?
## using the arrow above allows it to be overwritten so it now stays factor
#below more info
dim(edidiv) #  total rows and collums 
summary(edidiv)
summary(edidiv$taxonGroup)  # Gives you a summary of that particular variable (column) in your dataset


# We can create a vector (a series of values) listing how many species from each taxa have been recorded in Edinburgh
# We will filter out the data for each taxon group and then count the unique species within it
# Here we are only hinting to all the cool stuff we can do with dplyr - we will learn more in later tutorials.

Beetle <- filter(edidiv, taxonGroup == "Beetle")
Bird <- filter(edidiv, taxonGroup == "Bird")
Butterfly <- filter(edidiv, taxonGroup == "Buterfly")
FloweringPlants <- filter(edidiv, taxonGroup == "Flowering.Plants")
Fungus <- filter(edidiv, taxonGroup == "Fungus")
Hymenopteran <- filter(edidiv, taxonGroup == "Hymenopteran")
Lichen <- filter(edidiv, taxonGroup == "Lichen")
Liverwort <- filter(edidiv, taxonGroup == "Liverwort")
Mammal <- filter(edidiv, taxonGroup == "Mammal")
Mollusc <- filter(edidiv, taxonGroup == "mollusc")

# To find out the number of different species in each taxa, we will use the function unique() together (length)

a <- length(unique(Beetle$taxonName))
b <- length(unique(Bird$taxonName))
c <- length(unique(Butterfly$taxonName))
e <- length(unique(FloweringPlants$taxonName))
f <- length(unique(Fungus$TaxonName))
g <- length(unique(Hymenopteran$taxon.Name))
h <- length(unique(Lichen$taxonName))
i <- length(unique(Liverwort$taxonName))
j <- length(unique(Mammal$taxonname))
k <- length(unique(Mollusc$taxonName))

# We can now combine all those object in one vector using the c() function and add labels using names() 
biodiv <- c(a,b,c,e,f,g,h,i,j,k)
names(biodiv) <- c("Beetle", 
                   "Bird", 
                   "Butterfly", 
                   "FloweringPlants", 
                   "Fungus", 
                   "Hymenopteran", 
                   "Lichen", 
                   "Liverwort", 
                   "Mammal", 
                   "Mollusc")

# We have all the values now, so we can visualise them quickly with the barplot() function
barplot(as.matrix(biodiv))

# There's a few things not quite right that we should fix
# Add in axis titles 
# Make all column labels visible
# Set the limits for the y axis

# We also want to save our plot
png("barplot.png", width=950, height=500)

barplot(biodiv, xlab="Taxa", ylab="Number of species", ylim=c(0,600), cex.names= 1.5, cex.axis=1.5, cex.lab=1.5)
dev.off()

# The plot has been saved in your working directory
# To confirm where that was, you can use getwd(), and to change it, you can use setwd()
getwd()
## "/Users/alisonstewart/Desktop/Github/course-repository-Alisonbeee/Week_1"

# This was a vector of values, each with a label, which is suitable when dealing with just one set of values
# In most cases you will have more variables and categories
# For that we will use data frames - we can save a data frame as a csv file to use again later

taxa <- c("Beetle", 
          "Bird", 
          "Butterfly", 
          "FloweringPlants", 
          "Fungus", 
          "Hymenopteran", 
          "Lichen", 
          "Liverwort", 
          "Mammal", 
          "Mollusc")
taxa_f <- factor(taxa)
richness <- c(a,b,c,e,f,g,h,i,j,k)
biodata <- data.frame(taxa_f, richness)
write.csv(biodata, file="biodata.csv")

# If we want to make the same barplot using the data frame, not the vector, we need to slightly change the code
# We need to tell the barplot() function exactly what we want it to plot, in our case the richness
png("barplot2.png", width=950, height=500)

barplot(biodata$richness, names.arg=c("Beetle",
                                      "Bird",
                                      "Butterfly",
                                      "FloweringPlants",
                                      "Fungus",
                                      "Hymenopteran",
                                      "Lichen",
                                      "Liverwort",
                                      "Mammal",
                                      "Mollusc"),
        xlab="Taxa", ylab="Number of species", ylim=c(0,600))

dev.off()

# In this tutorial we found out how many species from a range of taxa have been recorded in Edinburgh.
