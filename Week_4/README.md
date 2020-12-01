# Week four

#### Class Tutorials
Found in `Tutorials_W4`
* [Basic data manipulation in R](https://ourcodingclub.github.io/tutorials/data-manip-intro/)

* [Efficient data manipulation in R](https://ourcodingclub.github.io/tutorials/data-manip-efficient/index.html)

* Challenge script found in `Tutorials_challenge_W4`

What I want to do | How to do it
------------------|--------------
`rename()` Change names of column | dataset <- rename(dataset, colnewname = cololdname, colnewname1 = cololdname1, colnewname2 = cololdname2) 
`filter()` Chose what column data to keep| newdataset <- filter(dataset, col1 %in% c(2, 3), col2 %in% c("X2009", "X2010", "X2011"))
`select()` Selecting certain columns to keep | newdataset <- dplyr::select(dataset, col1, col2, col3)
`mutate()` New column | newdataset <- mutate(dataset, total.growth = X2007 + X2008 + X2009 + X2010 + X2011 + X2012) {total.growth is new col}
`group_by()` Create internal grouping structure | grouped_newdataset <- group_by(dataset, col1) {data is grouped by col1}
`summarise()` Summary stats | summary3 <- summarise(grouped_newdataset, total.growth = sum(length), mean.growth = mean(length), sd.growth = sd(length))
`join()` Join datasets with same attributes | joineddataset <- left_join(dataset1, dataset2, by = c("indiv" = "Indiv", "zone" = "Zone")) {end part if they are named wrong}
Connect `dplyr` functions | Use a pipe %>%
`summarise_all()` get mean for all columns | summ.all <- summarise_all(dataset, mean)
`case_when()` re-classifying values or factors | With this: vector2 <- c("What am I?", "A", "B", "C", "D") Then: case_when(vector2 == "What am I?" ~ "I am the walrus", vector2 %in% c("A", "B") ~ "goo", vector2 == "C" ~ "ga", vector2 == "D" ~ "joob")




#### Readings: 

[Tidyverse](https://www.tidyverse.org/)

The **tidyverse** is an opinionated collection of R packages designed for data science. All packages share an underlying design philosophy, grammar, and data structures.

I think this is the full list of packages you get when you 
** install.packages("tidyverse") ** in Rstudio


[R for Data Science Chapter 5 Data transformation](http://r4ds.had.co.nz/transform.html)

- **Visualisation** is an important tool for insight generation, but it is **rare** that you get the data in exactly the right form you need. Often you’ll need to **create some new variables or summaries, or maybe you just want to rename the variables or reorder the observations** in order to make the data a little easier to work with.

- I’m going to learn how to do this using the the dplyr package. 

- Code and annotated instructions of how I did this can be found in the **data_transformation file**

#### Abbreviations are 
* int stands for integers.
* dbl stands for doubles, or real numbers.
* chr stands for character vectors, or strings.
* dttm stands for date-times (a date + a time).

*There are three other common types of variables that aren’t used in this dataset but you’ll encounter later in the book:*
* lgl stands for logical, vectors that contain only TRUE or FALSE.
* fctr stands for factors, which R uses to represent categorical variables with fixed possible values.
* date stands for dates.

#### The five key dplyr functions that allow you to solve the vast majority of your data manipulation challenges:
* Pick observations by their values (filter()).
* Reorder the rows (arrange()).
* Pick variables by their names (select()).
* Create new variables with functions of existing variables (mutate()).
* Collapse many values down to a single summary (summarise()).

These can all be used in conjunction with group_by() which changes the scope of each function from operating on the entire dataset to operating on it group-by-group. These six functions provide the verbs for a language of data manipulation.
All verbs work similarly:
1. The first argument is a data frame.
2. The subsequent arguments describe what to do with the data frame, using the variable names (without quotes).
3. The result is a new data frame.

#### 6 functions are:
To use filtering effectively, you have to know how to select the observations that you want using the comparison operators. 
* != (not equal)
*  == (equal).
* >, >=, <, <=,  (these are just greater than/equal too type commands)

#### Multiple arguments to filter() are combined with “and”

* & is “and”
* | is “or”
* and ! is “not”

#### Missing values 

* Are represented as NA’s
* NA represents an unknown value so missing values are “contagious”: almost any operation involving an unknown value will also be unknown.

if you want to determine if a value is missing, use **is.na()**

We use can use filter(), which only includes rows where the condition is TRUE; it excludes both FALSE and NA values. 
If you want to preserve missing values, ask for them explicitly:
* In code I have this example but don’t fully understand it

After doing exercise it is 
* filter(flights, is.na(dep_time))
* Using the filter it allows me to see how many flights are missing a departure time.


#### Select()
Helper functions
* starts_with("abc"): matches names that begin with “abc”.
* ends_with("xyz"): matches names that end with “xyz”.
* contains("ijk"): matches names that contain “ijk”.
* matches("(.)\\1"): selects variables that match a regular expression. This one matches any variables that contain repeated characters. You’ll learn more about regular expressions in strings.
* num_range("x", 1:3): matches x1, x2 and x3.



#### Cumulative and rolling aggregates: 
R provides functions for running sums, products, mins and maxes: 
* cumsum(), 
* cumprod(), 
* cummin(), 
* cummax(); 
* and dplyr provides cummean() for cumulative means




#### R for Data Science Part II Wrangle [Chapters 9 - 16](http://r4ds.had.co.nz/wrangle-intro.html)
This is a work in progress throughout the weeks
  
  












