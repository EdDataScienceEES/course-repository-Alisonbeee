# EFFICIENT DATA MANIPULATION
# USE PIPES TO STREAMLINE YOUR CODE
# 14th Oct 2020
# Alison Stewart

# Tutorial aims:

# 1.Chain together multiple lines of codes with pipes %>%
# 2.Use dplyr to its full potential
# 3.Automate advanced tasks like plotting without writing a loop

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1. An introduction to pipes

# LIBRARIES
library(dplyr)     # for data manipulation
library(ggplot2)   # for making graphs; make sure you have it installed, or install it now

# Set your working directory
setwd("~/Desktop/CC-data-manip-2-master") 

# LOAD DATA
trees <- read.csv(file = "trees.csv", header = TRUE)

head(trees)  # make sure the data imported OK, familiarise yourself with the variables


# Count the number of trees for each species

trees.grouped <- group_by(trees, CommonName)    # create an internal grouping structure, so that the next function acts on groups (here, species) separately. 

trees.summary <- summarise(trees.grouped, count = length(CommonName))   # here we use length to count the number of rows (trees) for each group (species). We could have used any row name.

# Alternatively, dplyr has a tally function that does the counts for you!
trees.summary <- tally(trees.grouped)


# To improve above we can use ~Pipes~ it passes data from left to right and avoids repeating object name (trees.grouped) every time!!

# Count the number of trees for each species, with a pipe!
trees.summary <- trees %>%    # the data frame object that will be passed in the pipe
  group_by(CommonName) %>%    # see how we don't need to name the object, just the grouping variable?
  tally()                     # and we don't need anything at all here, it has been passed through the pipe!

# Think of the pipe as " and then "
# Cmd + Shift + M = %>% 

# Below this is happening:
# Tree data (and then) show only these 3 species (and then) present them 
# by their name and age group (and then) count the number of each species in each age group
trees.subset <- trees %>%
  filter(CommonName %in% c('Common Ash', 'Rowan', 'Scots Pine')) %>% 
  group_by(CommonName, AgeGroup) %>% 
  tally()


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. More functions of dplyr
# summarise_all(): will run a summary function of your choice over ALL the columns.

# 2a. summarise_all() - quickly generate a summary dataframe
summ.all <- summarise_all(trees, mean)
# As only two of the columns had numeric values over which a mean could be calculated, the other columns have missing values.

# 2b. case_when() - a favourite for re-classifying values or factors

vector <- c(4, 13, 15, 6)      # create a vector to evaluate

ifelse(vector < 10, "A", "B")  # give the conditions: if inferior to 10, return A, if not, return B
# ABBA

# The super useful case_when() is a generalisation of ifelse() that lets you assign more than two outcomes. 
  # All logical operators are available, and you assign the new value with a tilde ~. For instance:
vector2 <- c("What am I?", "A", "B", "C", "D")

case_when(vector2 == "What am I?" ~ "I am the walrus",
          vector2 %in% c("A", "B") ~ "goo",
          vector2 == "C" ~ "ga",
          vector2 == "D" ~ "joob")

# 3. Changing factor levels or create categorical variables
# We are wanting to add a new collum with the genus 


unique(trees$LatinName)  # Shows all the species names

# Create a new column with the tree genera
# creates the genus column and specifies conditions
trees.genus <- trees %>%
  mutate(Genus = case_when(              
    grepl("Acer", LatinName) ~ "Acer",
    grepl("Fraxinus", LatinName) ~ "Fraxinus",
    grepl("Sorbus", LatinName) ~ "Sorbus",
    grepl("Betula", LatinName) ~ "Betula",
    grepl("Populus", LatinName) ~ "Populus",
    grepl("Laburnum", LatinName) ~ "Laburnum",
    grepl("Aesculus", LatinName) ~ "Aesculus", 
    grepl("Fagus", LatinName) ~ "Fagus",
    grepl("Prunus", LatinName) ~ "Prunus",
    grepl("Pinus", LatinName) ~ "Pinus",
    grepl("Sambucus", LatinName) ~ "Sambucus",
    grepl("Crataegus", LatinName) ~ "Crataegus",
    grepl("Ilex", LatinName) ~ "Ilex",
    grepl("Quercus", LatinName) ~ "Quercus",
    grepl("Larix", LatinName) ~ "Larix",
    grepl("Salix", LatinName) ~ "Salix",
    grepl("Alnus", LatinName) ~ "Alnus"))

# This is a lot of typing and can actually be done quicker!
# Because the Genus is always the first word of the latin name 
# So,

library(tidyr)
trees.genus.2 <- trees %>% 
  tidyr::separate(LatinName, c("Genus", "Species"), sep = " ", remove = FALSE) %>%  
  dplyr::select(-Species)


# we're creating two new columns in a vector c("genus name" and "species name"), 
# "sep" refers to the separator, here space between the words, 
# (and then) remove = FALSE means that we want to keep the original column LatinName in the data frame


# Changing 5 factors of height to 3 
trees.genus <- trees.genus %>%   # overwriting our data frame 
  mutate(Height.cat =   # creating our new column
           case_when(Height %in% c("Up to 5 meters", "5 to 10 meters") ~ "Short",
                     Height %in% c("10 to 15 meters", "15 to 20 meters") ~ "Medium",
                     Height == "20 to 25 meters" ~ "Tall"))

## Reordering a factor's levels because R will show them in alphabetical otherwise

levels(trees.genus$Height.cat)  # shows the different factor levels in their default order

trees.genus$Height.cat <- factor(trees.genus$Height.cat,
                                 levels = c('Short', 'Medium', 'Tall'),   # whichever order you choose will be reflected in plots etc
                                 labels = c('SHORT', 'MEDIUM', 'TALL'))    # Make sure you match the new names to the original levels!
                                    

levels(trees.genus$Height.cat)  # a new order and new names for the levels


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 4. Advanced piping
# ~ making graphs with pipe function

install.packages("ggplot2")
library(ggplot2)


# Subset data frame to fewer genera (5)

trees.five <- trees.genus %>%
  filter(Genus %in% c("Acer", "Fraxinus", "Salix", "Aesculus", "Pinus"))

# Map all the trees

(map.all <- ggplot(trees.five) +
    geom_point(aes(x = Easting, y = Northing, size = Height.cat, colour = Genus), alpha = 0.5) +
    theme_bw() +
    theme(panel.grid = element_blank(),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 12)))

# Plotting a map for each genus

tree.plots <-  
  trees.five  %>%      # the data frame
  group_by(Genus) %>%  # grouping by genus
  do(plots =           # the plotting call within the do function
       ggplot(data = .) +
       geom_point(aes(x = Easting, y = Northing, size = Height.cat), alpha = 0.5) +
       labs(title = paste("Map of", .$Genus, "at Craigmillar Castle", sep = " ")) +
       theme_bw() +
       theme(panel.grid = element_blank(),
             axis.text = element_text(size = 14),
             legend.text = element_text(size = 12),
             plot.title = element_text(hjust = 0.5),
             legend.position = "bottom")
  ) 

# You can view the graphs before saving them
tree.plots$plots

# Saving the plots to file

tree.plots %>%              # the saving call within the do function
  do(., ggsave(.$plots, filename = paste(getwd(), "/", "map-", .$Genus, ".png", sep = ""), device = "png", height = 12, width = 16, units = "cm"))

