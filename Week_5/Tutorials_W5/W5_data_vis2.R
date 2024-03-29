# DATA VISUALISATION 2: 
# By coding club
# Alison Stewart
# alisondianastewart@gmail.com
# 22nd Oct 2020



# Tutorial aims & steps:
  
# Customise histograms in ggplot2
  # Add titles, subtitles, captions and axis labels
  # Change the plot background
  # Fix the legend and customise colours
  # Create your own colour palette
  # Customise boxplots in ggplot2
  # Add regression lines to your plots
  # Create your own ggplot theme
  # Challenge yourself!

## Vegetation of magical lands
## Data visualisation tutorial
## YOUR NAME
## DATE
#
# Load libraries ----
library(dplyr)  # For data manipulation
library(ggplot2)  # For data visualisation

setwd("~/Desktop/CC-10-DataVis2-master")  # Set working directory to the folder where you saved the data

# Read in data ----
magic_veg <- read.csv("magic_veg.csv")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# str() function, which shows what type each variable ia
str(magic_veg)

# land - the location within the land of magic (two possible lands: Narnia and Hogsmeade)
# plot - the plot number within each land
# year - the year the measurement was taken
# species - the species name (or code), Note that these are fake species!
# height - the imaginary canopy height at that point
# id - the id of each observation


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1. Customise histograms in ggplot2

# Let us first calculate how many species there are in each plot.
species_counts <- magic_veg %>%
  group_by(land, plot) %>%
  summarise(Species_number = length(unique(species)))

(hist <- ggplot(species_counts, aes(x = plot)) +
    geom_histogram()) # odd looking histogram

# So we need to add y axis and 
  # You therefore need to tell R that you already know how many species are in each plot. 
  # You do that by specifying the stat argument (identity)
(hist <- ggplot(species_counts, aes(x = plot, y = Species_number)) +
    geom_histogram(stat = "identity"))

# Note: an equivalent alternative is to use geom_col (for column), which takes a y value and displays it
(col <- ggplot(species_counts, aes(x = plot, y = Species_number)) +
    geom_col())


# ADDING THE LOCATIONS
# TO get it to be even better we can add colour for each location by adding fill = land
(hist <- ggplot(species_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_histogram(stat = "identity"))
# Remember that any aesthetics that are a function of your data (like fill here) 
  #need to be INSIDE the aes() brackets.


# MAKING IT SIDE BY SIDE
# This is much easier to read!!!
(hist <- ggplot(species_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_histogram(stat = "identity", position = "dodge"))

# TO SEE ALL PLOT NUMBERS WE:
   # Adding continuous section
(hist <- ggplot(species_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_histogram(stat = "identity", position = "dodge") + 
    scale_x_continuous(breaks = c(1:6)) + 
    scale_y_continuous(limits = c(0, 50)))


# ADDING TITLES
# Just run this to see where all things end up
(hist <- ggplot(species_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_histogram(stat = "identity", position = "dodge") +
    scale_x_continuous(breaks = c(1,2,3,4,5,6)) + 
    scale_y_continuous(limits = c(0, 50)) +
    labs(title = "Species richness by plot", 
         subtitle = "In the magical lands",
         caption = "Data from the Ministry of Magic", 
         x = "\n Plot number", y = "Number of species \n"))     # \n adds space before x and after y axis text


# CONTROL EVEN MORE!!!
  # using theme() to add font changes
(hist <- ggplot(species_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_histogram(stat = "identity", position = "dodge") +
    scale_x_continuous(breaks = c(1,2,3,4,5,6)) + 
    scale_y_continuous(limits = c(0, 50)) +
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme(axis.text = element_text(size = 12), 
          axis.title = element_text(size = 12, face = "italic"), 
          plot.title = element_text(size = 14, hjust = 0.5, face = "bold")))


# CHANGE GREY BACKGROUND
  # Using theme_bw() to change to white
  # panel.grid = element_blank() to get rid of lines

(hist <- ggplot(species_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_histogram(stat = "identity", position = "dodge") + 
    scale_x_continuous(breaks = c(1,2,3,4,5,6)) + 
    scale_y_continuous(limits = c(0, 50)) +
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme_bw() +
    theme(panel.grid = element_blank(), 
          axis.text = element_text(size = 12), 
          axis.title = element_text(size = 12), 
          plot.title = element_text(size = 14, hjust = 0.5, face = "bold")))


# CHANGE LEGEND 
  # Use the scale_...() functions to customise both the color code AND the legend at once.
  # We can change it to “Land of Magic,” by specifying name = "Land of Magic" in our function scale_fill_manual().
  # For no name we can specify in scale_fill_manual, name = NULL.
(hist <- ggplot(species_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_histogram(stat = "identity", position = "dodge") + 
    scale_x_continuous(breaks = c(1,2,3,4,5,6)) + 
    scale_y_continuous(limits = c(0, 50)) +
    scale_fill_manual(values = c("#FFB90F", "#009ACD"),     # specifying the colours
                      name = "Land of Magic") +                # specifying title of legend
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme_bw() +
    theme(panel.grid = element_blank(), 
          axis.text = element_text(size = 12), 
          axis.title = element_text(size = 12), 
          plot.title = element_text(size = 14, hjust = 0.5, face = "bold"), 
          plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , "cm"), 
          legend.title = element_text(face = "bold"),
          legend.position = "bottom", 
          legend.box.background = element_rect(color = "grey", size = 0.3)))

# Can change labels of figure in scale_fill_manual too
(hist <- ggplot(species_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_histogram(stat = "identity", position = "dodge") + 
    scale_x_continuous(breaks = c(1,2,3,4,5,6)) + 
    scale_y_continuous(limits = c(0, 50)) +
    scale_fill_manual(values = c("rosybrown1", "#deebf7"),           # specifying the colours
                      labels = c("HOGSMEADE", "NARNIA"),             # changing the site labels
                      name = "Land of Magic") +                      # defining legend title
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme_bw() +
    theme(panel.grid = element_blank(), 
          axis.text = element_text(size = 12), 
          axis.title = element_text(size = 12), 
          plot.title = element_text(size = 14, hjust = 0.5, face = "bold"), 
          plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , "cm"), 
          legend.title = element_text(face = "bold"),
          legend.position = "bottom", 
          legend.box.background = element_rect(color = "grey", size = 0.3)))

# EXTRA ON THEME()
# you can also do legend.position = c(0.1, 0.8), which would bring the legend 
# to the top left hand corner (corresponding to the x and y values on the graph).
# Finally, we’ve used legend.box.background = element_rect() to create a light grey rectangle
# that surrounds the legend. If you don’t want this, you can just remove that line of code.


# SAVE GRAPH
# or use ggsave("images/magical-land-sp-richness.png") to put in a folder
ggsave("magical-sp-rich-hist.png", width = 7, height = 5, dpi = 300)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 2. Create your own colour palette
  # Can do this by creating a colour vector

# Create vectors with land names and species counts
land <- factor(c("Narnia", "Hogsmeade", "Westeros", "The Shire", "Mordor", "Forbidden Forest", "Oz"))
counts <- as.numeric(c(55, 48, 37, 62, 11, 39, 51))

# Create the new data frame from the vectors
more_magic <- data.frame(land, counts)

# We'll need as many colours as there are factor levels
length(levels(more_magic$land))    # that's 7 levels 

# CREATE THE COLOUR PALETTE
magic.palette <- c("#698B69", "#5D478B", "#5C5C5C", "#CD6090", "#EEC900", "#5F9EA0", "#6CA6CD")    # defining 7 colours
names(magic.palette) <- levels(more_magic$land)                                                    # linking factor names to the colours

# Bar plot with all the factors

(hist <- ggplot(more_magic, aes(x = land, y = counts, fill = land)) +
    geom_histogram(stat = "identity", position = "dodge") + 
    scale_y_continuous(limits = c(0, 65)) +
    scale_fill_manual(values = magic.palette,                        # using our palette here
                      name = "Land of Magic") +                
    labs(title = "Species richness in magical lands", 
         x = "", y = "Number of species \n") + 
    theme_bw() +
    theme(panel.grid = element_blank(), 
          axis.text = element_text(size = 12), 
          axis.text.x = element_text(angle = 45, hjust = 1), 
          axis.title = element_text(size = 12), 
          plot.title = element_text(size = 14, hjust = 0.5, face = "bold"), 
          plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , "cm"), 
          legend.title = element_text(face = "bold"),
          legend.position = "bottom", 
          legend.box.background = element_rect(color = "grey", size = 0.3)))


# See how consistent the colour scheme is if you drop some factors (using filter in the first line)

(hist <- ggplot(filter(more_magic, land %in% c("Hogsmeade", "Oz", "The Shire")), aes(x = land, y = counts, fill = land)) +
    geom_histogram(stat = "identity", position = "dodge") + 
    scale_y_continuous(limits = c(0, 65)) +
    scale_fill_manual(values = magic.palette,                       # using our palette ensures that colours with no corresponding factors are dropped
                      name = "Land of Magic") +                
    labs(title = "Species richness in magical lands", 
         x = "", y = "Number of species \n") + 
    theme_bw() +
    theme(panel.grid = element_blank(), 
          axis.text = element_text(size = 12), 
          axis.text.x = element_text(angle = 45, hjust = 1), 
          axis.title = element_text(size = 12), 
          plot.title = element_text(size = 14, hjust = 0.5, face = "bold"), 
          plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , "cm"), 
          legend.title = element_text(face = "bold"),
          legend.position = "bottom", 
          legend.box.background = element_rect(color = "grey", size = 0.3)))

# Link on how to use gradients for continuous data
# https://ggplot2.tidyverse.org/reference/scale_gradient.html
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 3. Customise boxplots in ggplot2
  # reshape the dataset to take account of year as well

yearly_counts <- magic_veg %>%
  group_by(land, plot, year) %>%                             # We've added in year here
  summarise(Species_number = length(unique(species))) %>%
  ungroup() %>%
  mutate(plot = as.factor(plot))

# Plot this without making it PRETTY <3
(boxplot <- ggplot(yearly_counts, aes(plot, Species_number, fill = land)) +
    geom_boxplot())


# PRETTY TIME: using theme()
(boxplot <- ggplot(yearly_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_boxplot() +
    scale_x_discrete(breaks = 1:6) +
    scale_fill_manual(values = c("rosybrown1", "#deebf7"),
                      breaks = c("Hogsmeade","Narnia"),
                      name="Land of magic",
                      labels=c("Hogsmeade", "Narnia")) +
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme_bw() + 
    theme() + 
    theme(panel.grid = element_blank(), 
          axis.text = element_text(size = 12), 
          axis.title = element_text(size = 12), 
          plot.title = element_text(size = 14, hjust = 0.5, face = "bold"), 
          plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , "cm"), 
          legend.position = "bottom", 
          legend.box.background = element_rect(color = "grey", size = 0.3)))

# Saving the boxplot
ggsave("magical-sp-rich-boxplot1.png", width = 7, height = 5, dpi = 300)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# BOXPLOT PROBLEM:
# A problem with them, especially if used without a measure of uncertainty (e.g. error bars), is that what they display is a range of values starting from 0.
# An easy alternative is a dot plot, which you could have done by summarising the species_counts
# Create the summarised data
summary <- species_counts %>%  group_by(land) %>% summarise(mean = mean(Species_number),
                                                            sd = sd(Species_number))

# Make a dot plot
(dot <- ggplot(summary, aes(x = land, y = mean, colour = land)) +
    geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = 0.2) +
    geom_point(size = 3) + 
    scale_y_continuous(limits = c(0, 50)) +
    scale_colour_manual(values = c('#CD5C5C', '#6CA6CD'), 
                        labels = c('HOGSMEADE', 'NARNIA'), 
                        name = 'Land of Magic') +                   
    labs(title = 'Average species richness', 
         x = '', y = 'Number of species \n') + 
    theme_bw() +
    theme(panel.grid = element_blank(), 
          axis.text = element_text(size = 12), 
          axis.title = element_text(size = 12), 
          plot.title = element_text(size = 14, hjust = 0.5, face = 'bold'), 
          plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , 'cm'), 
          legend.title = element_text(face = 'bold'),
          legend.position = 'bottom', 
          legend.box.background = element_rect(color = 'grey', size = 0.3)))

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Reordering factors:
# we wanted to have Narnia come before Hogsmeade
# Reordering the data
yearly_counts$land <- factor(yearly_counts$land, 
                             levels = c("Narnia", "Hogsmeade"),
                             labels = c("Narnia", "Hogsmeade"))

# Plotting the boxplot 
(boxplot <- ggplot(yearly_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_boxplot() +
    scale_x_discrete(breaks = 1:6) +
    scale_fill_manual(values = c("#deebf7", "rosybrown1"),
                      breaks = c("Narnia","Hogsmeade"),
                      name = "Land of magic",
                      labels = c("Narnia", "Hogsmeade")) +
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme_bw() + 
    theme() + 
    theme(panel.grid = element_blank(), 
          axis.text = element_text(size = 12), 
          axis.title = element_text(size = 12), 
          plot.title = element_text(size = 14, hjust = 0.5, face = "bold"), 
          plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , "cm"), 
          legend.position = "bottom", 
          legend.box.background = element_rect(color = "grey", size = 0.3)))


# REORDER PLOTS
# Reordering the data 
yearly_counts$plot <- factor(yearly_counts$plot, 
                             levels = c("6", "1", "2", "3", "4", "5"),
                             labels = c("6", "1", "2", "3", "4", "5"))

# Plotting the boxplot 
(boxplot2 <- ggplot(yearly_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_boxplot() +
    scale_x_discrete(breaks = 1:6) +
    scale_fill_manual(values = c("#deebf7", "rosybrown1"),
                      breaks = c("Narnia","Hogsmeade"),
                      name = "Land of magic",
                      labels = c("Narnia", "Hogsmeade")) +
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme_bw() + 
    theme() + 
    theme(panel.grid = element_blank(), 
          axis.text = element_text(size = 12), 
          axis.title = element_text(size = 12), 
          plot.title = element_text(size = 14, hjust = 0.5, face = "bold"), 
          plot.margin = unit(c(0.5,0.5,0.5,0.5), units = , "cm"), 
          legend.position = "bottom", 
          legend.box.background = element_rect(color = "grey", size = 0.3)))

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 4. Plot regression lines onto your plots:
# Plant heights, and how they might have changed over time:
  # data manipulation to extract just the heights:

heights <- magic_veg %>%
  filter(!is.na(height)) %>%                    # removing NA values
  group_by(year, land, plot, id) %>%
  summarise(Max_Height = max(height)) %>%       # Calculating max height
  ungroup() %>%                                 # Need to ungroup so that the pipe doesn't get confused
  group_by(year, land, plot) %>%
  summarise(Height = mean(Max_Height))          # Calculating mean max height

# Scatterplot
(basic_mm_scatter <- ggplot(heights, aes(year, Height, colour = land)) +
    geom_point() +
    theme_bw())


# Plot trends
  # using stat_smooth in ggplot2, by specifying a linear model (lm) method.
(basic_mm_scatter_line <- ggplot(heights, aes(year, Height, colour = land)) +
    geom_point() +
    theme_bw() +
    stat_smooth(method = "lm"))


# Change to a non linear fit
(improved_mm_scat <- ggplot(heights, aes(year, Height, colour = land)) +
    geom_point() +
    theme_bw() +
    stat_smooth(method = "lm", formula = y ~ x + I(x^2)))



# CREATING A CUSTOM THEME
# for our histograms we won’t need to use legend.position, but it’s fine to keep it in the theme in case any future graphs we apply it to do have the need for legends.
theme_coding <- function(){            # creating a new theme function
  theme_bw()+                          # using a predefined theme as a base
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),       # customising lots of things
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 14),
          panel.grid = element_blank(),
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
          plot.title = element_text(size = 20, vjust = 1, hjust = 0.5),
          legend.text = element_text(size = 12, face = "italic"),
          legend.title = element_blank(),
          legend.position = c(0.9, 0.9))
}

# Trying out saved theme function
# EXAMPLE 1: boxplot with all the theme elements specified

(boxplot <- ggplot(yearly_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_boxplot() +
    scale_x_discrete(breaks = 1:6) +
    scale_fill_manual(values = c("#deebf7", "rosybrown1"),
                      breaks = c("Narnia","Hogsmeade"),
                      name = "Land of magic",
                      labels = c("Narnia", "Hogsmeade")) +
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme_bw()+                          # using a predefined theme as a base
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),       # customising lots of things
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 14),
          panel.grid = element_blank(),
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
          plot.title = element_text(size = 20, vjust = 1, hjust = 0.5),
          legend.text = element_text(size = 12, face = "italic"),
          legend.title = element_blank(),
          legend.position = c(0.9, 0.9))
)

# EXAMPLE 2: Using our custom theme to achieve the exact same thing

(boxplot <- ggplot(yearly_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_boxplot() +
    scale_x_discrete(breaks = 1:6) +
    scale_fill_manual(values = c("#deebf7", "rosybrown1"),
                      breaks = c("Narnia","Hogsmeade"),
                      name = "Land of magic",
                      labels = c("Narnia", "Hogsmeade")) +
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme_coding()                      # short and sweeeeet!
)


# And if you need to change some elements (like the legend that encroaches on the graph here), you can simply overwrite:

(boxplot <- ggplot(yearly_counts, aes(x = plot, y = Species_number, fill = land)) +
    geom_boxplot() +
    scale_x_discrete(breaks = 1:6) +
    scale_fill_manual(values = c("#deebf7", "rosybrown1"),
                      breaks = c("Narnia","Hogsmeade"),
                      name = "Land of magic",
                      labels = c("Narnia", "Hogsmeade")) +
    labs(title = "Species richness by plot", 
         x = "\n Plot number", y = "Number of species \n") + 
    theme_coding() +                      # this contains legend.position = c(0.9, 0.9)
    theme(legend.position = "right")      # this overwrites the previous legend position setting
)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CHALLENGE: MORE MAGIC
  # Plot the species richness as a bar plot, coloured not by land this time, 
  # but with a shade representing the % of endemism. 

# Add % of endemic species to the data frame
more_magic <- more_magic %>% mutate(endemic = c(0.54, 0.32, 0.66, 0.80, 0.14, 0.24, 0.39))

# Going to use:
  # Link on how to use gradients for continuous data
  # https://ggplot2.tidyverse.org/reference/scale_gradient.html

# Creating the bar plot 

(endemic <- ggplot(more_magic, aes(x = land, y = counts, fill = endemic)) +   # colour coding by % endemic species
    geom_histogram(stat = 'identity') +
    scale_fill_gradient(low = '#87CEEB', high = '#4A708B',                     # creating gradient from pale to dark blue
                        name = 'Endemism % \n') +                              # setting legend title
    labs(x = 'Magical Land', y = 'Species richness \n', 
         title = 'Species richness and endemism in magical worlds') +               # setting axes and main titles
    theme_coding() +
    theme(legend.position = 'right',                     # changing the legend position
          legend.title = element_text(size = 12),        # adding the legend title back
          plot.title = element_text(size = 14))           # reducing size of main title
)

# Reordering factor levels of land by % endemism (directly within aes() with reorder function)

(endemic <- ggplot(more_magic, aes(x = reorder(land, endemic), y = counts, fill = endemic)) +
    geom_histogram(stat = 'identity') +
    scale_fill_gradient(low = '#87CEEB', high = '#4A708B',                     # creating gradient from pale to dark blue
                        name = 'Endemism % \n') +                              # setting legend title
    labs(x = 'Magical Land', y = 'Species richness \n', 
         title = 'Species richness and endemism in magical worlds') +               # setting axes and main titles
    theme_coding() +
    theme(legend.position = 'right',                     # changing the legend position
          legend.title = element_text(size = 12),        # adding the legend title back
          plot.title = element_text(size = 14))           # reducing size of main title
)
