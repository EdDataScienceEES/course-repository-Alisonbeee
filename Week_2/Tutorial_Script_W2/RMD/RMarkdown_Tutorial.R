---
  title: "Edinburgh Biodiversity"
author: John_Doe
date: 22/Oct/2016
output: html_document
---
# Coding Club Workshop 7 R Markdown and reproducible code - Template R script
# Written by John Godlee
# 21/11/16 
# University of Edinburgh

# Use this example R script to practice compiling an R Markdown file, using the tutorial materials provided at: ourcodingclub.github.io/2016/11/24/rmarkdown-1.html

# Follow through the tutorial to make a well commented, easy to follow record of what is going on so that others can easily follow.

# Loading packages
library(dplyr)

# Loading biodiversity data
# This data is a publicly available dataset of occurrence records for many animal, 
# plant, and fungi species, for 2000-2016 from the NBN Gateway

setwd("~Desktop/RMD")
## Above doesnt work (error : canot change working directory
# so do below instead not sure if this is ok to do
edidiv <- read.csv(file="~/Desktop/RMD/edidiv.csv")


# Constructing a table of species richness in each taxonomic group
## richness sorted for each species
## %>% means : we read the %>% as “and then”
## https://uc-r.github.io/pipe link on how 
richness <- 
  edidiv %>%
    group_by(taxonGroup) %>%
    summarise(Species_richness = n_distinct(taxonName))

richness

# Creating a barplot of species richness in each taxonomic group
## Say what data to use (richness) names.arg sets name on x axis $attches two
## then what sets the x and y, 
barplot(richness$Species_richness, 
        names.arg = richness$taxonGroup, 
        xlab = "Taxa", ylab = "Number of species", 
        ylim = c(0,600)
        ) 

# Determining what the most common species is in each taxonomic group 

max_abund <-
  edidiv %>%
    group_by(taxonGroup) %>%
    summarise(taxonName = names(which.max(table(taxonName))))

max_abund

# Joining the two data frames together, using "taxonGroup" as the reference
## this is to see the richness of the most common species??
richness_abund <- inner_join(richness, max_abund, by = "taxonGroup")

# Renaming the headers of the tables, and viewing the data frame

richness_abund <- rename(richness_abund, Most_abundant =  taxonName, Taxon = taxonGroup)

richness_abund

# Things to think about:
  # - Which bits of code need to be displayed in the final .html file?
  # - How can the formatting of the R markdown file be improved?

# Experiment with other demo R scripts in the repo, or your own scripts for further practice! 
  # - RMarkdown_Demo_1.R 
  # - RMarkdown_Demo_2.R 
  # - RMarkdown_Demo_3.R
