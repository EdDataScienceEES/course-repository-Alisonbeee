# Tutorial: Beautiful & Informative data visualisation
# Alison Stewart
# Oct 21st 2020

# Your working directory, set to the folder you just downloaded from Github, e.g.:
setwd("~/Desktop/CC-4-Datavis-master")

# Libraries - if you haven't installed them before, run the code install.packages("package_name")
library(tidyr)
library(dplyr)
library(ggplot2)
library(readr)
library(gridExtra)

# Import data from the Living Planet Index - population trends of vertebrate species from 1970 to 2014
LPI <- read.csv("LPIdata_CC.csv")

# Reshape data into long form
# By adding 9:53, we select columns 9 to 53, the ones for the different years of monitoring
LPI2 <- gather(LPI, "year", "abundance", 9:53)
View(LPI2)

# Remove X from year
LPI2$year <- parse_number(LPI2$year)

# When manipulating data it's always good check if the variables have stayed how we want them
# Use the str() function
str(LPI2)

# Abundance is also a character variable, when it should be numeric, let's fix that
LPI2$abundance <- as.numeric(LPI2$abundance)

# Number of species 
unique(LPI2$`Common.Name`)

# Pick just one species 
vulture <- filter(LPI2, Common.Name == "Griffon vulture / Eurasian griffon")
head(vulture)

# There are a lot of NAs in this dataframe, so we will get rid of the empty rows using na.omit()
vulture <- na.omit(vulture)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 3a. Histograms to visualise data distribution

# With base R graphics
base_hist <- hist(vulture$abundance)


#With ggplot2: creating graph with no brackets
vulture_hist <- ggplot(vulture, aes(x = abundance))  +
  geom_histogram() 

# Calling the object to display it in the plot viewer
vulture_hist

# With brackets: you create and display the graph at the same time
(vulture_hist <- ggplot(vulture, aes(x = abundance))  +
    geom_histogram())


# The default ggplot settings (right) are not ideal: there is lots of unnecessary grey space behind 
# the histogram, the axis labels are quite small, and the bars blend with each other. 
# Lets beautify the histogram a bit! This is where the true power of ggplot2 shines.

(vulture_hist <- ggplot(vulture, aes(x = abundance)) +                
    geom_histogram(binwidth = 250, colour = "#8B5A00", fill = "#CD8500") +    # Changing the binwidth and colours
    geom_vline(aes(xintercept = mean(abundance)),                       # Adding a line for mean abundance
               colour = "red", linetype = "dashed", size=1) +           # Changing the look of the line
    theme_bw() +                                                      # Changing the theme to get rid of the grey background
    ylab("Count\n") +                                                   # Changing the text of the y axis label
    xlab("\nGriffon vulture abundance")  +                              # \n adds a blank line between axis and text
    theme(axis.text = element_text(size = 12),                          # Changing font size of axis labels and title
          axis.title.x = element_text(size = 14, face = "plain"),       # face="plain" is the default, you can change it to italic, bold, etc. 
          panel.grid = element_blank(),                                 # Removing the grey grid lines
          plot.margin = unit(c(1,1,1,1), units = , "cm")))              # Putting a 1 cm margin around the plot

# We can see from the histogram that the data are very skewed - a typical distribution of count abundance data


# Learning to use colour picker
install.packages("colourpicker")
# Go to addins and select colour picker!!


# 3b. Scatter plot to examine population change over time
# Filtering the data to get records only from Croatia and Italy using the `filter()` function from the `dplyr` package
vultureITCR <- filter(vulture, Country.list %in% c("Croatia", "Italy"))

# Using default base graphics
plot(vultureITCR$year, vultureITCR$abundance, col = c("#1874CD", "#68228B"))

# Using default ggplot2 graphics
(vulture_scatter <- ggplot(vultureITCR, aes(x = year, y = abundance, colour = Country.list)) +  # linking colour to a factor inside aes() ensures that the points' colour will vary according to the factor levels
    geom_point())


# Now to add even more!!!
(vulture_scatter <- ggplot(vultureITCR, aes (x = year, y = abundance, colour = Country.list)) +
    geom_point(size = 2) +                                               # Changing point size
    geom_smooth(method = "lm", aes(fill = Country.list)) +               # Adding linear model fit, colour-code by country
    theme_bw() +
    scale_fill_manual(values = c("#EE7600", "#00868B")) +                # Adding custom colours for solid geoms (ribbon)
    scale_colour_manual(values = c("#EE7600", "#00868B"),                # Adding custom colours for lines and points
                        labels = c("Croatia", "Italy")) +                # Adding labels for the legend
    ylab("Griffon vulture abundance\n") +                             
    xlab("\nYear")  +
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),     # making the years at a bit of an angle
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 14, face = "plain"),                        
          panel.grid = element_blank(),                                   # Removing the background grid lines               
          plot.margin = unit(c(1,1,1,1), units = , "cm"),                 # Adding a 1cm margin around the plot
          legend.text = element_text(size = 12, face = "italic"),         # Setting the font for the legend text
          legend.title = element_blank(),                                 # Removing the legend title
          legend.position = c(0.9, 0.9)))                                 # Setting legend position - 0 is left/bottom, 1 is top/right


# 3c. Boxplot to examine whether vulture abundance differs between Croatia and Italy
(vulture_boxplot <- ggplot(vultureITCR, aes("Country list", abundance)) + geom_boxplot())

# Beautifying

(vulture_boxplot <- ggplot(vultureITCR, aes(Country.list, abundance)) + 
    geom_boxplot(aes(fill = Country.list)) +
    theme_bw() +
    scale_fill_manual(values = c("#EE7600", "#00868B")) +               # Adding custom colours
    scale_colour_manual(values = c("#EE7600", "#00868B")) +             # Adding custom colours
    ylab("Griffon vulture abundance\n") +                             
    xlab("\nCountry")  +
    theme(axis.text = element_text(size = 12),
          axis.title = element_text(size = 14, face = "plain"),                     
          panel.grid = element_blank(),                                 # Removing the background grid lines               
          plot.margin = unit(c(1,1,1,1), units = , "cm"),               # Adding a margin
          legend.position = "none"))                                    # Removing legend - not needed with only 2 factors


# 3d. Barplot to compare species richness of a few European countries

# Calculating species richness using pipes %>% from the dplyr package
richness <- LPI2 %>% filter (Country.list %in% c("United Kingdom", "Germany", "France", "Netherlands", "Italy")) %>%
  group_by(Country.list) %>%
  mutate(richness = (length(unique(Common.Name)))) # create new column based on how many unique common names (or species) there are in each country 

# Plotting the species richness
(richness_barplot <- ggplot(richness, aes(x = Country.list, y = richness)) +
    geom_bar(position = position_dodge(), stat = "identity", colour = "black", fill = "#00868B") +
    theme_bw() +
    ylab("Species richness\n") +                             
    xlab("Country")  +
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),  # Angled labels, so text doesn't overlap
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 14, face = "plain"),                      
          panel.grid = element_blank(),                                          
          plot.margin = unit(c(1,1,1,1), units = , "cm")))

# 4. Using facets and creating panels
# Plot the population change for all countries
(vulture_scatter_all <- ggplot(vulture, aes (x = year, y = abundance, colour = Country.list)) +
    geom_point(size = 2) +                                               # Changing point size
    geom_smooth(method = "lm", aes(fill = Country.list)) +               # Adding linear model fit, colour-code by country
    theme_bw() +
    ylab("Griffon vulture abundance\n") +                             
    xlab("\nYear")  +
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),     # making the years at a bit of an angle
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 14, face = "plain"),                        
          panel.grid = element_blank(),                                   # Removing the background grid lines               
          plot.margin = unit(c(1,1,1,1), units = , "cm"),                 # Adding a 1cm margin around the plot
          legend.text = element_text(size = 12, face = "italic"),         # Setting the font for the legend text
          legend.title = element_blank(),                                 # Removing the legend title
          legend.position = "right"))   

# Above too cluttered so:
# By adding a facetting layer, we can split the data in multiple facets representing the different countries. This is done using facet_wrap().
# Plot the population change for countries individually
(vulture_scatter_facets <- ggplot(vulture, aes (x = year, y = abundance, colour = Country.list)) +
    geom_point(size = 2) +                                               # Changing point size
    geom_smooth(method = "lm", aes(fill = Country.list)) +               # Adding linear model fit, colour-code by country
    facet_wrap(~ Country.list, scales = "free_y") +                      # THIS LINE CREATES THE FACETTING
    theme_bw() +
    ylab("Griffon vulture abundance\n") +                             
    xlab("\nYear")  +
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),     # making the years at a bit of an angle
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 14, face = "plain"),                        
          panel.grid = element_blank(),                                   # Removing the background grid lines               
          plot.margin = unit(c(1,1,1,1), units = , "cm"),                 # Adding a 1cm margin around the plot
          legend.text = element_text(size = 12, face = "italic"),         # Setting the font for the legend text
          legend.title = element_blank(),                                 # Removing the legend title
          legend.position = "right"))   




# arrange multiple figures together to create a panel. We will do this using grid.arrange() from the package gridExtra.
grid.arrange(vulture_hist, vulture_scatter, vulture_boxplot, ncol = 1)

# This doesn't look right - the graphs are too stretched, the legend and text are all messed up, the white margins are too big

# Fixing the problems - adding ylab() again overrides the previous settings
(panel <- grid.arrange(
  vulture_hist + ggtitle("(a)") + ylab("Count") + xlab("Abundance") +   # adding labels to the different plots
    theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = , "cm")),
  
  vulture_boxplot + ggtitle("(b)") + ylab("Abundance") + xlab("Country") +
    theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = , "cm")),
  
  vulture_scatter + ggtitle("(c)") + ylab("Abundance") + xlab("Year") +
    theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = , "cm")) +
    theme(legend.text = element_text(size = 12, face = "italic"),     
          legend.title = element_blank(),                                   
          legend.position = c(0.85, 0.85)), # changing the legend position so that it fits within the panel
  
  ncol = 1)) # ncol determines how many columns you have



# To get around the too stretched/too squished panel problems, we will save the file and give it exact dimensions using ggsave from the ggplot2 package
ggsave(panel, file = "vulture_panel2.png", width = 5, height = 12) 


# Challenge :

# I chose two Arctic animals
arctic <- filter(LPI2, Common.Name %in% c('Reindeer / Caribou', 'Beluga whale'))

# GRAPH 1 - POPULATION CHANGE OVER TIME

(arctic.scatter<- ggplot(arctic, aes(x = year, y = abundance)) +
    geom_point(aes(colour = Country.list), size = 1.5, alpha = 0.6) +                # alpha controls transparency
    facet_wrap(~ Common.Name, scales = 'free_y') +                                   # facetting by species
    stat_smooth(method = 'lm', aes(fill = Country.list, colour = Country.list)) +    # colour coding by country
    scale_colour_manual(values = c('#8B3A3A', '#4A708B', '#FFA500', '#8B8989'), name = 'Country') +
    scale_fill_manual(values = c('#8B3A3A', '#4A708B', '#FFA500', '#8B8989'), name = 'Country') +
    labs(x = 'Year', y = 'Abundance \n') +
    theme_bw() +
    theme(panel.grid = element_blank(),
          strip.background = element_blank(),
          strip.text = element_text(size = 12),
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 12),
          legend.text = element_text(size = 12),
          legend.title = element_text(size = 12))
)

# GRAPH 2 - BOXPLOTS OF ABUNDANCE ACROSS FIVE COUNTRIES

# Only have four countries so no subsetting; let's plot directly:
(arctic.box <- ggplot(arctic, aes(x = Country.list, y = abundance)) +
    geom_boxplot() +
    labs(x = 'Country', y = 'Abundance \n') +
    theme_bw() +
    facet_wrap(~Common.Name, scales = 'free_y') +
    theme(panel.grid = element_blank(),
          strip.background = element_blank(),
          strip.text = element_text(size = 12),
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 12),
          legend.text = element_text(size = 12),
          legend.title = element_text(size = 12))
)

# Not great becausE of high-abundance outliers for reindeer in Canada - let's remove them for now (wouldn't do that for an analysis!)
(arctic.box <- ggplot(filter(arctic, abundance < 8000), aes(x = Country.list, y = abundance)) +
    geom_boxplot() +
    labs(x = 'Country', y = 'Abundance \n') +
    theme_bw() +
    facet_wrap(~Common.Name, scales = 'free_y') +
    theme(panel.grid = element_blank(),
          strip.background = element_blank(),
          strip.text = element_text(size = 12),
          axis.text = element_text(size = 12),
          axis.text.x = element_text(angle = 45, hjust = 1),
          axis.title = element_text(size = 12))
)

#Align together in a panel - here I use the egg package that lines up plots together regardless of whether they have a legend or not


library(egg)

ggarrange(arctic.scatter + labs(title = 'Population change over time'), 
          arctic.box + labs(title = 'Population size across countries'))
