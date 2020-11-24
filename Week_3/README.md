# Week three

This week has been based more on theory and learning how to do different things within github and desktop RStudio plus coding etiquette. Not much content will be found in this week other than important notes to remember from this weeks topics.


#### Class tutorials
* [Intro to git and version control](https://ourcodingclub.github.io/tutorials/git/)
* [Coding Etiquette](https://ourcodingclub.github.io/tutorials/etiquette/)

#### Extra tutorials
* [R for Data Science Chapter 1](http://r4ds.had.co.nz/introduction.html)

![](data-science.png)


# Coding club session 7th Oct: Notes
### Intro to git and version control
If both are doing work (when both push) the software picks it up and will flag up and then you can chose which version (you have to solve this before you can continue).

When there is a project opened from GitHub you can see what repository is open at the very top.

Repository files are bottom right 
- This holds all the folders and data

In top right box there’s a git tab
- When you save a script (update) in the git tab a M comes up and this shows you have modified the file.
- When I am happy I can select the file and commit it 
    - A box comes up and then I can write a message when I commit it (to say what I did)
    - Before I submit I should click pull (this checks that online repository is up to date) if it is not then someone else has changed it while I was working on it
    - Then when I push that makes what is online

Then go to online repository 
- On git it will highlight the change in green 
- The insight tab shows what everyone has done 



### Coding ettique 
What to do I want to do | Code 
------------------------|------
Create sections | Type this after title ----
Create intro for script | Include name, date, email, title, data location
Collapse section | click arrow at code line number to hide section
Set working directory for mac | `setwd("~/Work/coding_club/CC-etiquette-master")`
Import data | `LPI <- read.csv("LPIdata_CC.csv")`
Name files | use informative file names like: `LPI_analysis_Apr_2017.R`
Objects | Easy to read name e.g.`avg_clicks`
Spaces | include these between everything so it is easier to read
Curly brackets } | Should always go on its own line below 
Use multiple lines for long code | can do this if a line ends with `+` or `%>%` signifying something is coming next
Rename old objects | click the magnifying glass and then can change variables this way 
Rename old objects in code | names(dataframe) <- `gsub(".", "_", names(dataframe), fixed = TRUE)`
Add box of hashtag | download addin `install.packages("devtools")` `devtools::install_github("ThinkRstat/littleboxes")`



# Readings:
* [Computer_programming](https://en.wikipedia.org/wiki/Computer_programming)
Computer programming is the process of designing and building an executable computer program to accomplish a specific computing result or to perform a specific task.
The purpose of programming is to find a sequence of instructions that will automate the performance of a task on a computer, often for solving a given problem.

* [Programming_language](https://en.wikipedia.org/wiki/Programming_language)
A programming language is a formal language comprising a set of instructions that produce various kinds of output. Programming languages are used in computer programming to implement algorithms.

* [Functional_programming](https://en.wikipedia.org/wiki/Functional_programming)
Functional programming is a programming paradigm where programs are constructed by applying and composing functions. It is a declarative programming paradigm in which function definitions are trees of expressions that each return a value, rather than a sequence of imperative statements which change the state of the program.
Functions are treated as first-class citizens, meaning that they can be bound to names (including local identifiers), passed as arguments, and returned from other functions, just as any other data type can. This allows programs to be written in a declarative and composable style, where small functions are combined in a modular manner.

* [Object-oriented_programming](https://en.wikipedia.org/wiki/Object-oriented_programming)
Object-oriented programming (OOP) is a programming paradigm based on the concept of "objects", which can contain data and code: data in the form of fields (often known as attributes or properties), and code, in the form of procedures (often known as methods).

* [R_(programming_language)](https://en.wikipedia.org/wiki/R_(programming_language))
R is a programming language and free software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing. The R language is widely used among statisticians and data miners for developing statistical software and data analysis. 
