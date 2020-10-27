# EFFICIENT AND BEAUTIFUL DATA VISUALISATION
# Tutorial by coding club: Created by Gergana
# Alison Stewart
# alisondianastewart@gmail.com
# 24th Oct 2020

# Tutorial Aims:
  # 1. Make and beautify maps
  # 2. Visualise distributions with raincloud plots
  # 3. Make, customise and annotate histograms

# ggplot jargon
  # geom: a geometric object
  # aes: short for aesthetics.
  # stat: a stat layer
  # theme: a theme is made of a set of visual parameters


# Your working directory, set to the folder you just downloaded from Github, e.g.:
setwd("~/Desktop/CC-dataviz-beautification-master")


# Need to install older ggplot2 for this code to work!
remotes::install_version('ggplot2', version = '3.2.1')


# Libraries ----
# if you haven't installed them before, run the code install.packages("package_name")
library(tidyverse)
library(ggthemes)# for a mapping theme
library(proj4)
library(ggalt)  # for custom map projections
library(ggrepel)  # for annotations
library(viridis)  # for nice colours


# Data ----
# Load data - site coordinates and plant records from
# the Long Term Ecological Research Network
# https://lternet.edu and the Niwot Ridge site more specifically
lter <- read.csv("lter.csv")
niwot_plant_exp <- read.csv("niwot_plant_exp.csv")


# Note: using data --- creates a heading that can be clicked on the top right of script


# MAPS ----
# Get the shape of North America
north_america <- map_data("world", region = c("USA", "Canada"))

# Exclude Hawaii if you want to
north_america <- north_america[!(north_america$subregion %in% "Hawaii"),]

# A very basic map
(lter_map1 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region), 
             color = "gray80", fill = "gray80", size = 0.3) +
    # Add points for the site locations
    geom_point(data = lter, 
               aes(x = long, y = lat)))

  # You can ignore this warning message, it's cause we have forced
  # specific lat and long columns onto geom_map()
  # Warning: Ignoring unknown aesthetics: x, y



# We can use COLOURS to indicate the elevation of each site.
(lter_map2 <- ggplot() +
    geom_map(map = north_america, data = north_america,
             aes(long, lat, map_id = region), 
             color = "gray80", fill = "gray80", size = 0.3) +
    geom_point(data = lter, 
               aes(x = long, y = lat, fill = ele),
               # when you set the fill or colour to vary depending on a variable
               # you put that (e.g., fill = ele) inside the aes() call
               # when you want to set a specific colour (e.g., colour = "grey30"),
               # that goes outside of the aes() call
               alpha = 0.8, size = 4, colour = "grey30",
               shape = 21))

ggsave(lter_map2, filename = "map2.png",
       height = 5, width = 8)

# if you wanted to save this (not amazing) map
# you can use ggsave()
ggsave(lter_map1, filename = "map1.png",
       height = 5, width = 8)  # the units by default are in inches

# the map will be saved in your working directory
# if you have forgotten where that is, use this code to find out
getwd()



# Making Map Realistic ----
# Next up we can work on improving the map projection - by default we get the Mercantor projection but that doesn’t represent the world very realistically. 
# With the ggalt package and the coord_proj function, we can easily swap the default projection.

(lter_map3 <- ggplot() +
   geom_map(map = north_america, data = north_america,
            aes(long, lat, map_id = region), 
            color = "gray80", fill = "gray80", size = 0.3) +
   coord_proj(paste0("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96",
                     " +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")) +
   geom_point(data = lter, 
              aes(x = long, y = lat, fill = ele),
              alpha = 0.8, size = 4, colour = "grey30",
              shape = 21))
# ERROR ----
# Above not working at all similar issue 
# https://rud.is/b/2015/07/24/a-path-towards-easier-map-projection-machinations-with-ggplot2/
# Above link might help?


# Violin plots ----
# Visualise distributions (and make them rain data with raincloud plots)
# Violin plots (the fatter the violin at a given value, the more data points there) 
  # are pretty and sound poetic, but we can customise them to make their messages pop out more. Thus the beautification journey begins again.

# DISTRIBUTIONS ----
# Setting a custom ggplot2 function
# This function makes a pretty ggplot theme
# This function takes no arguments 
# meaning that you always have just niwot_theme() and not niwot_theme(something else here)

theme_niwot <- function(){
  theme_bw() +
    theme(text = element_text(family = "Helvetica Light"),
          axis.text = element_text(size = 16), 
          axis.title = element_text(size = 18),
          axis.line.x = element_line(color="black"), 
          axis.line.y = element_line(color="black"),
          panel.border = element_blank(),
          panel.grid.major.x = element_blank(),                                          
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),  
          plot.margin = unit(c(1, 1, 1, 1), units = , "cm"),
          plot.title = element_text(size = 18, vjust = 1, hjust = 0),
          legend.text = element_text(size = 12),          
          legend.title = element_blank(),                              
          legend.position = c(0.95, 0.15), 
          legend.key = element_blank(),
          legend.background = element_rect(color = "black", 
                                           fill = "transparent", 
                                           size = 2, linetype = "blank"))
}



# Calculate species richness per plot per year
niwot_richness <- niwot_plant_exp %>% group_by(plot_num, year) %>%
  mutate(richness = length(unique(USDA_Scientific_Name))) %>% ungroup()

# we can visualise how it varies across fertilisation treatments.
(distributions1 <- ggplot(niwot_richness, aes(x = fert, y = richness)) +
    geom_violin())

# REMEBER: the fatter the violin at a given value, the more data points there)


# Add custom theme ----
(distributions2 <- ggplot(niwot_richness, aes(x = fert, y = richness)) +
   geom_violin(aes(fill = fert, colour = fert), alpha = 0.5) +
   # alpha controls the opacity
   theme_niwot())

# we can overlay the violins with box plots.
(distributions3 <- ggplot(niwot_richness, aes(x = fert, y = richness)) +
    geom_violin(aes(fill = fert, colour = fert), alpha = 0.5) +
    geom_boxplot(aes(colour = fert), width = 0.2) +
    theme_niwot())

# So intead of a boxplot, we can add the actual data points because we still don’t know exactly where the data points are
(distributions4 <- ggplot(niwot_richness, aes(x = fert, y = richness)) +
    geom_violin(aes(fill = fert, colour = fert), alpha = 0.5) +
    geom_jitter(aes(colour = fert), position = position_jitter(0.1), 
                alpha = 0.3) +
    theme_niwot())

# Raincloud plots ----
# Still busy!!
# And this is where raincloud plots come in! 
# They combine a distribution with the real data points as well as a boxplot.


# We will use a function by Ben Marwick
# This code loads the function in the working environment
source("https://gist.githubusercontent.com/benmarwick/2a1bb0133ff568cbe28d/raw/fb53bd97121f7f9ce947837ef1a4c65a73bffb3f/geom_flat_violin.R")

# Now we can make the plot!
(distributions5 <- 
    ggplot(data = niwot_richness, 
           aes(x = reorder(fert, desc(richness)), y = richness, fill = fert)) +
    # The half violins
    geom_flat_violin(position = position_nudge(x = 0.2, y = 0), alpha = 0.8) +
    # The points
    geom_point(aes(y = richness, color = fert), 
               position = position_jitter(width = 0.15), size = 1, alpha = 0.1) +
    # The boxplots
    geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.8) +
    # \n adds a new line which creates some space between the axis and axis title
    labs(y = "Species richness\n", x = NULL) +
    # Removing legends
    guides(fill = FALSE, color = FALSE) +
    # Setting the limits of the y axis
    scale_y_continuous(limits = c(0, 30)) +
    # Picking nicer colours
    scale_fill_manual(values = c("#5A4A6F", "#E47250",  "#EBB261", "#9D5A6C")) +
    scale_colour_manual(values = c("#5A4A6F", "#E47250",  "#EBB261", "#9D5A6C")) +
    theme_niwot())

# we can flip the x and y axis.

(distributions6 <- 
    ggplot(data = niwot_richness, 
           aes(x = reorder(fert, desc(richness)), y = richness, fill = fert)) +
    geom_flat_violin(position = position_nudge(x = 0.2, y = 0), alpha = 0.8) +
    geom_point(aes(y = richness, color = fert), 
               position = position_jitter(width = 0.15), size = 1, alpha = 0.1) +
    geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.8) +
    labs(y = "\nSpecies richness", x = NULL) +
    guides(fill = FALSE, color = FALSE) +
    scale_y_continuous(limits = c(0, 30)) +
    scale_fill_manual(values = c("#5A4A6F", "#E47250",  "#EBB261", "#9D5A6C")) +
    scale_colour_manual(values = c("#5A4A6F", "#E47250",  "#EBB261", "#9D5A6C")) +
    coord_flip() +
    theme_niwot())


# A data manipulation tip: Using case_when(), combined with mutate,
# is a great way to create new variables based on one or more conditions from other variables.

# Create new columns based on a combo of conditions using case_when()
# A fictional example
alpine_magic <- niwot_richness %>% mutate(fairy_dust = case_when(fert == "PP" & hits > 5 ~ "Blue fairy dust",
                                                                 fert == "CC" & hits > 15 ~ "The ultimate fairy dust"))

# Plot new column 
(distributions_magic <- 
    ggplot(data = alpine_magic, 
           aes(x = reorder(fairy_dust, desc(richness)), y = richness, fill = fairy_dust)) +
    geom_flat_violin(position = position_nudge(x = 0.2, y = 0), alpha = 0.8) +
    geom_point(aes(y = richness, color = fairy_dust), 
               position = position_jitter(width = 0.15), size = 1, alpha = 0.1) +
    geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.8) +
    labs(y = "\nSpecies richness", x = NULL) +
    guides(fill = FALSE, color = FALSE) +
    scale_y_continuous(limits = c(0, 30)) +
    scale_fill_manual(values = c("turquoise4", "magenta4")) +
    scale_colour_manual(values = c("turquoise4", "magenta4")) +
    coord_flip() +
    theme_niwot())

# Get rid of NA plot
alpine_magic_only <- alpine_magic %>% drop_na(fairy_dust)

# Plot again with new fix
(distributions_magic2 <- 
    ggplot(data = alpine_magic_only, 
           aes(x = reorder(fairy_dust, desc(richness)), y = richness, fill = fairy_dust)) +
    geom_flat_violin(position = position_nudge(x = 0.2, y = 0), alpha = 0.8) +
    geom_point(aes(y = richness, color = fairy_dust), 
               position = position_jitter(width = 0.15), size = 1, alpha = 0.1) +
    geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.8) +
    labs(y = "\nSpecies richness", x = NULL) +
    guides(fill = FALSE, color = FALSE) +
    scale_y_continuous(limits = c(0, 30)) +
    scale_fill_manual(values = c("turquoise4", "magenta4")) +
    scale_colour_manual(values = c("turquoise4", "magenta4")) +
    coord_flip() +
    theme_niwot())



# Histograms ----
# Make, customise and annotate histograms

# Calculate number of data records per plot per year
# Using the tally() function
# Gets the n value for all species !!!!
observations <- niwot_plant_exp %>% group_by(USDA_Scientific_Name) %>%
  tally() %>% arrange(desc(n))  # rearanging the data frame so that the most common species are first

# Filtering out just Carex species
carex <- niwot_plant_exp %>%
  filter(str_detect(USDA_Scientific_Name, pattern = "Carex"))


# Create histogram
# we can visualise the distribution of how frequently these species are observed across the plots. 
# In these data, that means plotting a histogram of the number of “hits” - how many times during the field data collection the pin used for observations “hit” a Carex species.
(histogram1 <- ggplot(carex, aes(x = hits)) +
    geom_histogram())


# Add colour and change size
(histogram2 <- ggplot(carex, aes(x = hits)) +
    geom_histogram(alpha = 0.6, 
                   breaks = seq(0, 100, by = 3),
                   # Choosing a Carex-like colour
                   fill = "palegreen4") + theme_niwot())

# Remove empty space
(histogram3 <- ggplot(carex, aes(x = hits)) +
    geom_histogram(alpha = 0.6, 
                   breaks = seq(0, 100, by = 3),
                   fill = "palegreen4") +
    theme_niwot() +
    scale_y_continuous(limits = c(0, 100), expand = expand_scale(mult = c(0, 0.1))))
# the final line of code removes the empty blank space below the bars)


# We can use geom_step() to create the histogram outline
# Adding an outline around the whole histogram
h <- hist(carex$hits, breaks = seq(0, 100, by = 3), plot = FALSE)
d1 <- data.frame(x = h$breaks, y = c(h$counts, NA))  
d1 <- rbind(c(0, 0), d1)

(histogram4 <- ggplot(carex, aes(x = hits)) +
    geom_histogram(alpha = 0.6, 
                   breaks = seq(0, 100, by = 3),
                   fill = "palegreen4") +
    theme_niwot() +
    scale_y_continuous(limits = c(0, 100), expand = expand_scale(mult = c(0, 0.1))) +
    # Adding the outline
    geom_step(data = d1, aes(x = x, y = y),
              stat = "identity", colour = "palegreen4"))

summary(d1) # it's fine, you can ignore the warning message
# it's because some values don't have bars
# thus there are missing "steps" along the geom_step path

# add a line for the mean number of hits and add an annotation on the graph
(histogram5 <- ggplot(carex, aes(x = hits)) +
    geom_histogram(alpha = 0.6, 
                   breaks = seq(0, 100, by = 3),
                   fill = "palegreen4") +
    theme_niwot() +
    scale_y_continuous(limits = c(0, 100), expand = expand_scale(mult = c(0, 0.1))) +
    geom_step(data = d1, aes(x = x, y = y),
              stat = "identity", colour = "palegreen4") +
    geom_vline(xintercept = mean(carex$hits), linetype = "dotted",
               colour = "palegreen4", size = 1) +
    # Adding in a text allocation - the coordinates are based on the x and y axes
    annotate("text", x = 50, y = 50, label = "The mean number of\nCarex observations was 16.") +
    # "\n" creates a line break
    geom_curve(aes(x = 50, y = 60, xend = mean(carex$hits) + 2, yend = 60),
               arrow = arrow(length = unit(0.07, "inch")), size = 0.7,
               color = "grey30", curvature = 0.3) +
    labs(x = "\nObservation hits", y = "Count\n"))
# Similarly to the annotation, the curved line follows the plot's coordinates
# Have a go at changing the curve parameters to see what happens



