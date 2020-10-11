# How to use the dplyr package by illustrating the key ideas using data from the nycflights13 package, 
# and use ggplot2 to help us understand the data.

install.packages("nycflights13")

library(nycflights13)
library(tidyverse)
## note of the conflicts message that’s printed when you load the tidyverse. It tells you that dplyr overwrites some functions in base R.


# View data
flights
## Console shows first few rows and collums that fit on screen
## We can see what the variables here too 

# To view full data set
View(flights)
# It is shown as a Tibble, which are are data frames, but slightly tweaked to work better in the tidyverse.


# Filter allows us to subset observations based on their values.
filter(flights, month == 1, day == 1)
# flights (is the name of the data frame), month and day is the expressions that filter the argument
# == is what part of data we are taking (1st of jan)

# save results of filter
jan1 <- filter(flights, month == 1, day == 1)

# R either prints out the results, or saves them to a variable. 
# If you want to do both, you can wrap the assignment in parentheses:
(dec25 <- filter(flights, month == 12, day == 25))
## important to use == for equal not = 
## when using == for an equation (Computers use finite precision arithmetic (they obviously can’t store an infinite number of digits!) so remember that every number you see is an approximation. Instead of relying on ==, use near():)


# Boolean operators 
# Code finds all flights that departed in November or December:
filter(flights, month == 11 | month == 12)

# below is a different way to write above but in short hand (good for if you're doing lots of months)
nov_dec <- filter(flights, month %in% c(11, 12))

# We can use these operations to find specifics from our data
# Ex: find flights that weren’t delayed (on arrival or departure) by more than two hours

# Two ways to write
filter(flights, !(arr_delay > 120 | dep_delay > 120))
# !Not delayed greater than 120 |and departed greater than 120
filter(flights, arr_delay <= 120, dep_delay <= 120)
# arrived less than or equal to 120 <=


# Missing values
# If you want to determine if a value is missing, use is.na():
# filter() only includes rows where the condition is TRUE; it excludes both FALSE and NA values. If you want to preserve missing values, ask for them explicitly:

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

#Exercise to find flights that have:

#Had an arrival delay of two or more hours
filter(flights, arr_delay >= 120, dep_delay >= 120)
#Flew to Houston (IAH or HOU)
filter(flights, dest == "IAH" | dest == "HOU")
filter(flights, dest %in% c("IAH","HOU"))
#Were operated by United, American, or Delta
filter(flights, carrier %in% c("UA", "AA", "DL"))
#Departed in summer (July,  August, and September)
filter(flights, month %in% c(7, 8, 9))
#Arrived more than two hours late, but didn’t leave late
filter(flights, arr_delay > 120, dep_delay <= 0)
#Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay > 60, arr_delay < 30)
#Departed between midnight and 6am (inclusive)
filter(flights, dep_time <= 600)


# Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed to answer the previous challenges?
?between()
between(dep_time,600, 2400)
filter(flights, between(dep_time,600, 2400))
#above attempts don't work: below is solution
filter(flights, between(month, 7, 9))

#How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
filter(flights, is.na(dep_time))
## also arrival time is missing 
### found in help that if you run a summary(flights) it will show all missing values

#Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general rule? (NA * 0 is a tricky counterexample!)
NA ^ 0
# [1] 1
# NA ^ 0 == 1 since for all numeric values X^0 = 1  

NA | TRUE
# [1] TRUE
# If the NA is (TRUE or FALSE) or TRUE it will always == TRUE

FALSE & NA 
# [1] FALSE
# The value of NA & FALSE is FALSE because anything and FALSE is always FALSE
# Think of FALSE as minus in math and TRUE positive (+ & - = -) 

NA * 0 
# [1] NA
# The reason that NA * 0 != 0 is that  0×∞ and  0×−∞ are undefined
# R represents undefined results as NaN, which is an abbreviation of “not a number”.       


# Arrange rows with arrange


