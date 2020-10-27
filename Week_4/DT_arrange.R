# Data Transformation
# Arrange rows with arrange()

# Arrange is similar to filter but instead of selecting rows to compare
# It changes rows order

install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

# If you provide more than one column name, each additional column will be used to break ties in the values of preceding columns:
arrange(flights, year, month, day)

# Use desc() to re-order by a column in descending order
arrange(flights, desc(dep_delay))


# for missing values they are always sorted at the end when using arrange
df <- tibble(x = c(5, 2, NA))
arrange(df, x)

# same if its descending the NA will be at end
arrange(df, desc(x))


# Exercises 
## 1.How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
# This works by: desc(decending) is.na (see if value is missing in deptime)
arrange(flights, desc(is.na(dep_time)), dep_time)
        
## 2.Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay))
EF <- arrange(flights, dep_delay)
## 3.Sort flights to find the fastest (highest speed) flights.
arrange(flights, air_time)
# think below is correct one
fast <- head(arrange(flights, desc(distance / air_time)))

## 4.Which flights traveled the farthest? Which traveled the shortest?
arrange(flights, desc(distance))
arrange(flights, distance)

#################################################################
# Select 
# select() allows you to rapidly zoom in on a useful subset using operations based on the names of the variables.
# below we can select just the variables we want to view
select(flights, year, month, day)

# select all between year and day
select(flights, year:day)

# select all but (all between year and day)
select(flights, -(year:day))

# rename a variable
rename(flights, tail_num = tailnum)

# use select() in conjunction with the everything() helper. This is useful if you have a handful of variables you’d like to move to the start of the data frame.
select(flights, time_hour, air_time, everything())

# Exercises
# 1.Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, "dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, 4, 6, 7, 9)
select(flights, starts_with("dep_"), starts_with("arr_"))

# 2.What happens if you include the name of a variable multiple times in a select() call?
select(flights, year, month, day, year, year)
## It only appears once each variable if you type it twice.
select(flights, arr_delay, everything())
## this can change the order of columns without having to specify the names of all the columns.

# 3.What does the any_of() function do? Why might it be helpful in conjunction with this vector?
  vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, any_of(vars))  
## selects all variables saved as vars, if one name is not present it will still run

# 4.Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?
  select(flights, contains("TIME"))
## shows all variables containing the word TIME not dependent on capitalisation
select(flights, contains("TIME", ignore.case = FALSE))
       
#############################################################       
# Mutate
# Add new variables with Mutate()
# ~ to add new columns that are functions of existing columns. 
# Always add new columns at the end
# to see all columns is View()

#Creating smaller data set
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)

# adding gain and speed as a variable and telling R how to calculate them
mutate(flights_sml, gain = dep_delay - arr_delay, speed = distance / air_time * 60)
view(flights_sml)

# more new variables
mutate(flights_sml, gain = dep_delay - arr_delay, hours = air_time / 60, gain_per_hour = gain / hours)
   
# to save them we use transmute()
transmute(flights, gain = dep_delay - arr_delay, hours = air_time / 60, gain_per_hour = gain / hours)
          
# Modular arithmetic: %/% (integer division) and %% (remainder),
# because of above below works
transmute(flights, dep_time, hour = dep_time %/% 100, minute = dep_time %% 100)

    
# Exercises

# 1.Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. 
##  Convert them to a more convenient representation of number of minutes since midnight.

flights_times <- mutate(flights,
                        dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
                        sched_dep_time_mins = (sched_dep_time %/% 100 * 60 +
                                                 sched_dep_time %% 100) %% 1440)
# 1440 = minutes in 24hr
# later on I'll learn to make this shorter as a function 
# View varaibles
select(flights_times, dep_time, dep_time_mins, sched_dep_time, sched_dep_time_mins)

# 2.Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?


# 3.Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
  
# 4.Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().

# 5.What does 1:3 + 1:10 return? Why?
  
# 6.What trigonometric functions does R provide?


  