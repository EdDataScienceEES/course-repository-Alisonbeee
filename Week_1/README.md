# Week-one

#### Class Tutorials where:

[Getting started with R and RStudio](https://ourcodingclub.github.io/tutorials/intro-to-r/)
 
[Troubleshooting and how to find help](https://ourcodingclub.github.io/tutorials/troubleshooting/)


## Notes on first week
### How to start an R script

What to do I want to do | Code 
------------------------|------
Install Packages | install.packages("dplyr")
Add Libraries | library(dplyr)
Set working directory | setwd("~/Desktop/Github.....")
Load data in | read.csv("edidiv.csv")



### How to explore data

What to do I want to do | Code 
------------------------|------
Display first few rows | head(dataset)
Display specific collumn first few rows | head(dataset$column)
Display last few rows | tail(dataset)
What variable each column is | str(dataset)
Show what variable a column is | class(dataset$column)
Total number of rows and columns | dim(dataset)
View Summary | summary(dataset)
Change a factor | dataset$column <- as.factor(dataset$column)

Note: in Summary() will show for example n number of species of each species in a column if that column is a factor.



### What is the difference between characters, numerics, factors and intergers
Reference: [Difference between variables](http://kddata.co/qa/question.php?nbr=6)

* numeric() are numbers with fractional parts (1.101) (non-catergorical)
* integer() are numbers without fractorinal parts (1) (non-catergorical)
* characters() are alphabetic characters (always catergorical)
* factors() are for alphanumeric variables (always catergorical)

* If there are many unique values : character < factor
* If there are few then : character > factor

Note: non-catergorical means order matters (e.g. 2.1 is bigger than 1.3)
Whereas catergorical means order does not matter e.g. (list of hair colour)



### How to visualise number of species by a boxplot

What to do I want to do | Code 
------------------------|------
Creating new data sets for each species | Beetle <- filter(dataset, column == "Beetle") 
Find n of each species | a <- lenght(unique(Beetle$column))
Combine n of each species as a vector | biodiv <- c(a,b,c...)
Add names to n values | names(biodic) <- c("Beetle", "Bird", ...)
Create barplot | barplot(biodiv, xlab="Taxa" ,ylab="No.of Species", ylim=c(0,600), cex.names=1.5, cex.axis=1.5, cex.lab=1.5)
Save barplot | png("barplot.png", width=950, height=(950) 
Remove plot from viewer | dev.off()
Show where plot was saved | getwd()



### What each aspect of barplot code means 
What to do I want to do | Code 
------------------------|------
xlab | naming x axis
ylab | naming y axis
ylim | lenght of y axis
cex.names | x axis size (each name size)
cex.axis | y axis size (0.600 number size)
cex.lab | title size



### Saving data set for later
What to do I want to do | Code 
------------------------|------
Create new vector for taxa | taxa <- c("Beetle", "Bird", ...)
Change factor | taxa_f <- factor(taxa) 
New vector for richness | richness <- c(a,b,c,...)
Create new data table | biodata <- data.frame(taxa_f, richness)
Create new file | write.csv(biodata, file="biodata.csv")



### Making a barplot with data set not vector
barplot(biodata$richness, names.arg=c("Beetle",...), xlab="Taxa", ylab="Number of species", ylim=c(0,600))

* Differences are that we $richness to state what variable is used in table
* name.arg to select names to go with richness numbers 



### Having trouble use this link
[troubleshooting help](https://ourcodingclub.github.io/tutorials/troubleshooting/)

Noted: my most common one so far has been just remebering commas and brackets

## Inital thoughts on data science course 21st Sep 2020

* Note to self: Not sure fully how to use this yet but going to try keep all my notes in github.

* Aim1: Hopefully will figure out the best way to save notes so I can access them in the best possible way. 

* Aim2: Start readings today and make some notes


* End of week 1: getting used to thinking a little for myself and troubleshooting simple issues

* did have one confusion where my bar graph didn't work in the first tutorial but I just ran the code again and it magically fixed??!!

* next aim: to start making graphs pretty 

## Readings 
Note: Readings for week 1 and 2 are the same so if a specific is not found here it will be in week 2


[What is Data science? - Wikipedia](https://en.wikipedia.org/wiki/Data_science)

"concept to unify statistics, data analysis and their related methods" in order to "understand and analyze actual phenomena" with data."

[Github - Wikipedia](https://en.wikipedia.org/wiki/GitHub)"

"GitHub, Inc. is an American multinational corporation that provides hosting for software development and version control using Git."
Also github is a great collab tool for teams to code at the same time

[Creating a repository (hello-world)](https://guides.github.com/activities/hello-world/)
