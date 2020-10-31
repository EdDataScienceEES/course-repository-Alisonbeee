# INTRO TO MODEL DESIGN
# Tutorial by coding club: Created by Gergana
# Alison Stewart
# alisondianastewart@gmail.com
# 27th Oct 2020

# Tutorial Aims: ----

# Learn what a statistical model is
# Come up with a research question
# Think about our data
# Think about our experimental design
# Turn a question into a model
# Learn about the different types of models
# General linear models
# Hierarchical models using lme4
# Random slopes versus random intercepts lme4
# Hierarchical models using MCMCglmm

# Research question: ----
  # Question 1: How has plant species richness changed over time at Toolik Lake?
    # Hypothesis 1: Plant species richness has increased over time at Toolik Lake. 

# Question 1 needs a: Detection model: When we ask how plant species richness has changed over time, we are interested in detecting change.

  # Question 2: How does mean annual temperature influence plant species richness?
    # Hypothesis 1: Higher temperatures correspond with higher species richness.

# Question 2 needs a: Attribution model: When we ask how temperature influences plant species richness, we are looking to attribute the changes we’ve seen to a specific driver, in this case, temperature.

install.packages("glmmTMB")

# 3. Thinking about our data:
# Load libraries ----
library(dplyr)  # for data manipulation
library(ggplot2)  # for data visualisation
library(lme4)  # for models
library(sjPlot)  # to visualise model outputs
library(ggeffects)  # to visualise model predictions
library(MCMCglmm)  # for models
library(MCMCvis)  # to visualise model outputs
library(brms)  # for models
library(stargazer)  # for tables of model outputs
library(glmmTMB)

# Load data ----
# Remember to set your working directory to the folder
# where you saved the workshop files
toolik_plants <- read.csv("~/Desktop/CC-model-design-master/toolik_plants.csv")

# Inspect data
head(toolik_plants)

# To check out what class of data we are dealing with we can use the str() function.
str(toolik_plants)

# Make plot a categorical variable
toolik_plants$Plot <- as.factor(as.character(toolik_plants$Plot))

# Get the unique site names
unique(toolik_plants$Site)
length(unique(toolik_plants$Site))

# Group the dataframe by Site to see the number of blocks per site
toolik_plants %>% group_by(Site) %>%
  summarise(block.n = length(unique(Block)))

toolik_plants %>% group_by(Block) %>%
  summarise(plot.n = length(unique(Plot))) # Within each block, there are eight smaller plots.

# There are four years of data from 2008 to 2012.
unique(toolik_plants$Year)

# There are 129 different species
length(unique(toolik_plants$Species))
unique(toolik_plants$Species)

# There is some non species data here so we are going to remove it

# We use ! to say that we want to exclude
# all records that meet the criteria

# We use %in% as a shortcut - we are filtering by many criteria
# but they all refer to the same column: Species
toolik_plants <- toolik_plants %>%
  filter(!Species %in% c("Woody cover", "Tube",
                         "Hole", "Vole trail",
                         "removed", "vole turds",
                         "Mushrooms", "Water",
                         "Caribou poop", "Rocks",
                         "mushroom", "caribou poop",
                         "animal litter", "vole poop",
                         "Vole poop", "Unk?"))

# New number of species is 115
length(unique(toolik_plants$Species))


# Calculate species richness
toolik_plants <- toolik_plants %>%
  group_by(Year, Site, Block, Plot) %>%
  mutate(Richness = length(unique(Species)))

# Species richness in histogram
(hist <- ggplot(toolik_plants, aes(x = Richness)) +
    geom_histogram() +
    theme_classic())


# The plant cover can be any value that is positive, it is therefore bounded at 0 and must be between 0 and 1. We can see this when we make a histogram of the data:
(hist2 <- ggplot(toolik_plants, aes(x = Relative.Cover)) +
    geom_histogram() +
    theme_classic())

# 4. Thinking about our experimental design ----
  # we have both spatial and temporal replication.

# One of the assumptions of a model is that the data points are independent. In reality, that is very rarely the case. 
  # For example, plots that are closer to one another might be more similar, which may or may not be related to some of the drivers we’re testing, e.g. temperature.

# Similarly, it’s possible that the data points in one year are not independent from those in the year before. For example, if a species was more abundant in the year 2000, that’s going to influence it’s abundance in 2001 as well.


# 5. Turn a question into a model ----
  # Question 1: How has plant species richness changed over time at Toolik Lake?

    # Richness is a function of time.
    #In R, this turns into the code: richness ~ time.

# 7. General linear models ----
plant_m <- lm(Richness ~ I(Year-2007), data = toolik_plants)
summary(plant_m)

# Assumptions made:
  # The data are normally distributed.
  # The data points are independent of one another.
  # The relationship between the variables we are studying is actually linear.

# CHECK DATA FITS
# This can tell us how well our data fits the lm and what the outliers are like
plot(plant_m)

# 8. Hierarchical models using lme4 ----

# First, let’s model with only site as a random effect. 
# go to tutorial for full explaiation here of why we can to state that 2008 is our first year of data collection
plant_m_plot <- lmer(Richness ~ I(Year-2007) + (1|Site), data = toolik_plants)
summary(plant_m_plot)
plot(plant_m_plot)  # Checking assumptions

# We are still not accounting for the different plots and blocks though, so let’s gradually add those and see how the results change.
plant_m_plot2 <- lmer(Richness ~ I(Year-2007) + (1|Site/Block), data = toolik_plants)
summary(plant_m_plot2)

# This final model answers our question about how plant species richness has changed over time, whilst also accounting for the hierarchical structure of the data. 
plant_m_plot3 <- lmer(Richness ~ I(Year-2007) + (1|Site/Block/Plot), data = toolik_plants)
summary(plant_m_plot3)

# Let’s visualise the results using the sjPlot package!
# Set a clean theme for the graphs
set_theme(base = theme_bw() + 
            theme(panel.grid.major.x = element_blank(),
                  panel.grid.minor.x = element_blank(),
                  panel.grid.minor.y = element_blank(),
                  panel.grid.major.y = element_blank(),
                  plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm")))

# Visualises random effects 
(re.effects <- plot_model(plant_m_plot3, type = "re", show.values = TRUE))
save_plot(filename = "model_re.png",
          height = 11, width = 9)  # Save the graph if you wish

# To see the estimate for our fixed effect (default): Year
# plot that shows us the random effects of site
(fe.effects <- plot_model(plant_m_plot3, show.values = TRUE))
save_plot(filename = "model_fe.png",
          height = 11, width = 9)  # Save the graph if you wish


# include temperature
plant_m_temp <- lmer(Richness ~ Mean.Temp + (1|Site/Block/Plot) + (1|Year),
                     data = toolik_plants)
summary(plant_m_temp)



# Let’s see the model outputs again:
# Visualise the random effect terms
(temp.re.effects <- plot_model(plant_m_temp, type = "re", show.values = TRUE))
save_plot(filename = "model_temp_re.png",
          height = 11, width = 9)

# Visualise the fixed effect
(temp.fe.effects <- plot_model(plant_m_temp, show.values = TRUE))
save_plot(filename = "model_temp_fe.png",
          height = 11, width = 9)


# Assumptions made:
  # The data are normally distributed.
  # The data points are independent of one another.
  # The relationship between the variables we are studying is actually linear.
  # Plots represent the spatial replication and years represent the temporal replication in our data.

# Assumptions not accounted for:
  # We have not accounted for spatial autocorrelation in the data - whether more closely located plots are more likely to show similar responses than farther away plots.
  # We have not accounted for temporal autocorrelation in the data - whether the influence of prior years of data are influencing the data in a given year.


# 9. Random slopes versus random intercepts lme4 ----

# For our question, how does temperature influence species richness, we can allow each plot to have it’s own relationship with temperature.
plant_m_rs <- lmer(Richness ~ Mean.Temp + (Mean.Temp|Site/Block/Plot) + (1|Year),
                   data = toolik_plants)
summary(plant_m_rs)

# the model structure is too complicated for the underlying data, so now we can simplify it.

plant_m_rs <- lmer(Richness ~ Mean.Temp + (Mean.Temp|Plot) + (1|Year),
                   data = toolik_plants)
summary(plant_m_rs)

# This one is not converging either! Let’s try with just a Plot random intercept and with random slopes to illustrate what a random slope model looks like.
plant_m_rs <- lmer(Richness ~ Mean.Temp + (Mean.Temp|Plot),
                   data = toolik_plants)
summary(plant_m_rs)


# We can visualise the results:
(plant.re.effects <- plot_model(plant_m_rs, type = "re", show.values = TRUE))

(plant.fe.effects <- plot_model(plant_m_rs, show.values = TRUE))



# We will use the ggeffects package to calculate model predictions and plot them.
  # First, we calculate the overall predictions for the relationship between species richness and temperature. 
  # Then, we calculate the predictions for each plot, thus visualising the among-plot variation. 
ggpredict(plant_m_rs, terms = c("Mean.Temp")) %>% plot()

ggpredict(plant_m_rs, terms = c("Mean.Temp", "Plot"), type = "re") %>% plot()


# Note y axis doesnt start at 0 so trend seems more than is:

# Overall predictions - note that we have specified just mean temperature as a term
predictions <- ggpredict(plant_m_rs, terms = c("Mean.Temp"))

(pred_plot1 <- ggplot(predictions, aes(x, predicted)) +
    geom_line() +
    geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = .1) +
    scale_y_continuous(limits = c(0, 22)) +
    labs(x = "\nMean annual temperature", y = "Predicted species richness\n"))


# Predictions for each grouping level (here plot which is a random effect)
# re stands for random effect
predictions_rs_ri <- ggpredict(plant_m_rs, terms = c("Mean.Temp", "Plot"), type = "re")

(pred_plot2 <- ggplot(predictions_rs_ri, aes(x = x, y = predicted, colour = group)) +
    stat_smooth(method = "lm", se = FALSE)  +
    scale_y_continuous(limits = c(0, 22)) +
    labs(x = "\nMean annual temperature", y = "Predicted species richness\n"))

ggsave(pred_plot2, filename = "ri_rs_predictions.png",
       height = 5, width = 5)



# 10. Hierarchical models using MCMCglmm ----

  # Using Generalised Linear Mixed-effects Models 

# in MCMCglmm, we can add random and fixed effects to account for the structure of the data we are modelling. 
# In MCMCglmm, there is greater flexibility in terms of specifying priors
# For example, there might be some lower and upper bound limit for our response variable - 
# e.g. we probably won’t find more than 1000 species in one small plant plot and zero is the lowest species richness can ever be.

plant_mcmc <- MCMCglmm(Richness ~ I(Year - 2007), random = ~Site,
                       family = "poisson",  data = toolik_plants)
# But we have a different problem: the model doesn’t converge.
# The MCMC_dummy warning message is just referring to the fact that the data, toolik_plants, has the characteristics of a tibble
# the real problem is that the model can’t converge when Site is a random effect. We might not have enough sites or enough variation in the data.

# Let’s explore how the model looks if we include Block and Plot as random effects (here they are random intercepts).
plant_mcmc <- MCMCglmm(Richness ~ I(Year-2007), random = ~Block + Plot,
                       family = "poisson", data = toolik_plants)

summary(plant_mcmc)
# The posterior mean (i.e., the slope) for the Year term is -0.07 (remember that this is on the logarithmic scale, because we have used a Poisson distribution). 
# So in general, based on this model, species richness has declined over time.


# Now we should check if the model has converged
plot(plant_mcmc$VCV)
plot(plant_mcmc$Sol)
# Ours really don’t give off that fuzzy caterpillar vibe! So in this case, even though the model ran and we got our estimates, we wouldn’t really trust this model. 


# Set weakly informative priors
prior2 <- list(R = list(V = 1, nu = 0.002),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.v = 10000),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.v = 10000),
                        G3 = list(V = 1, nu = 1, alpha.mu = 0, alpha.v = 10000)))

# Extract just the Betula nana data
betula <- filter(toolik_plants, Species == "Bet nan")

betula_m <- MCMCglmm(round(Relative.Cover*100) ~ Year, random = ~Site + Block + Plot,
                     family = "poisson", prior = prior2, data = betula)

summary(betula_m)
plot(betula_m$VCV)
plot(betula_m$Sol)

# This time it is like a catapiller

# Visualise model outputs ----
MCMCplot(betula_m$Sol)
MCMCplot(betula_m$VCV)
# THis bit doesnt work!!!
