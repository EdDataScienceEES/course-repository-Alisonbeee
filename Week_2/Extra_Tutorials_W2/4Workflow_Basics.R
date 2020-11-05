# 4 Workflow: basics

# 4.1 Coding basics


# Calculator in R
1 / 200 * 30
#> [1] 0.15
(59 + 73 + 2) / 3
#> [1] 44.66667
sin(pi / 2)
#> [1] 1


# You can create new objects with <-:
x <- 3 * 4
# This saves x in the environment


# Alt(option) and minus is a shortcut to <- 


# 4.2 What’s in a name?
# Object names must start with a letter, and can only contain letters, numbers, _ and .
  #i_use_snake_case
  #otherPeopleUseCamelCase
  #some.people.use.periods
  #And_aFew.People_RENOUNCEconvention


# You can inspect an object by typing its name:
x
#> in console it shows 12

# Make another assignment:
this_is_a_really_long_name <- 2.5

this_is_a_really_long_name 
# 2.5

# Make yet another assignment:
r_rocks <- 2 ^ 3

r_rock
#> Error: object 'r_rock' not found
R_rocks
#> Error: object 'R_rocks' not found
# Wrong because we spelled it wrong and then didnt use correct lowercase


# 4.3 Calling functions
# R has a large collection of built-in functions that are called like this:
function_name(arg1 = val1, arg2 = val2, ...)


# Let’s try using seq() which makes regular sequences of numbers
seq(1, 10)
#  Gives:  [1]  1  2  3  4  5  6  7  8  9 10
x <- "hello world"

x <- "hello"
# gives x - think also means code is continued to this line till i close" "

# stoo
y <- seq(1, 10, length.out = 5)
y
#[1]  1.00  3.25  5.50  7.75 10.00

# To skip writing y again put the function in brackets
(y <- seq(1, 10, length.out = 5))
#> [1]  1.00  3.25  5.50  7.75 10.00

# 4.4 Exercises
my_variable <- 10
my_varıable
#> Error in eval(expr, envir, enclos): object 'my_varıable' not found
# Spelled wrong


#2. Tweak each of the following R commands so that they run correctly:
library(tidyverse)

ggplot(dota = mpg) + # spelled wrong
  geom_point(mapping = aes(x = displ, y = hwy))

fliter(mpg, cyl = 8) # spelled wrong # add extra ==
filter(diamond, carat > 3) #diamond not found?
# change to mpg because that is the data set and cyl like top because thats in it


# Working code from above
library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

view(mpg)
filter(mpg, cyl == 8) 
filter(mpg, cyl > 3)

#3. Press Alt + Shift + K. What happens? How can you get to the same place using the menus?
# Key board shortcut reference: go to tools: Keyboard shortcut help
