# Week two

#### Class tutorials
found in `tutorial folder`

* [Tutorial: Introduction to Markdown](https://ourcodingclub.github.io/rmarkdown)
* [Coding Etiquette](https://ourcodingclub.github.io/tutorials/etiquette/)

#### Extra tutorials
found in `extra tutorials folder`
* [R for Data Science Chapter 4 Workflow](http://r4ds.had.co.nz/workflow-basics.html)
* [R for Data Science Chapter 27 Markdown](http://r4ds.had.co.nz/r-markdown.html)

## R related notes
Question | Answer
---------|---------
What is R | It is a programming language 
What is R studio | A software we can use the language R, and a graphic interface
A .R file is a | Script
R mark down files (.rmd) | a readable version of your r code 
Difference of note book and rmd file | The notebook is running it all the time and will show output at the end. Rmd is more like rStudio where you need to run each line
%>% means | we read the %>% as “and then”

### Caching
What is caching = storing files (a website on a second visit has saved cookies, photos, other files)  But in R it saves previously run code (so if there was a typo and you change your code and have to re run the whole code, instead of it taking ages it runs quicker due to it having saved previous code to cash). The cons are it takes up memory and if you have run a code for 3 months it can be useful to get rid of cash to check new code runs properly.

### Mark down 
Why would we not always use mark down = if its for the public do it in r markdown. But if I’m doing it for myself then do it in normal r script because I can annotate.

R markdown uses a range of languages (it is a markup language(it is more like a style you don’t write programs in it can use it to write notes))

### Text editor 
What is a text editor = it is an application on my Mac already

### More markdown
GitHub flavoured mark down = is a type of mark down that git hub recognises when creating websites 
(3 types normal mark down, r markdown, GitHub flavour markdown)
Git hub knows when it sees a flavour markdown to create a website

### Syntax 
is the grammar (commas, brackets)

### R data file = Where you store objects, 
When you close r studio it asks if you want to save your data as a r data file this occurs when you have not saved workspace 
What is git = a language 
What is GitHub = the environment and platform that uses git, a website, it is a “cloud” form of storage 

## Tasks
### Getting git on laptop
Downloading the git tab 
https://jennybc.github.io/2014-05-12-ubc/ubc-r/session03_git.html used this website but didn’t work 
I have downloaded honeydew and Xcode
**Now in week 3 I've solved this issue above and can use github in Rstudio much easier**


# Data Science 1st of Oct Zoom session
* 1: First go at cloning a repository to my computer 
* 2: Commit pull and push (how we interact with git hub with our computer) 
* 3: Everyone to work together in the course repository
* 4: Accept the course repository assignment (so they can see what I do on git hub and mark it… etc) These repository have deadlines on December 4th and sends over the repository
* 5: understand different types of files 
* 6: relative file path (concept) 
* 7: Think about coding etiquette (how I want to start every code)
* 8: understand collaborative coding 
* 9: prepare for version control next week

### After this lecture (where I’m at)
Feeling highly confused about how to get git hub on my RStudio and then when it is there how it works? Feeling a bit stressed and need time to process things and work out step by step what I need to do and how I can be proactive in class chats without asking stupid things and constructive things????

Steps to help: Spend time at night looking through issues of the day maybe and see if they relate to me??

### Questions I want to find answers too
 - Which bits of code need to be displayed in the final .html file?
 - How can the formatting of the R markdown file be improved? (I think this is to do with the cheat sheet
 - Why use R markdown instead of an R studio file? (Maybe its because you dont need r to open it?)


# Readings

Bryan J. (2017) Excuse me, do you have a moment to talk about version control? PeerJ Preprints 5:e3159v2 [Paper Link](https://doi.org/10.7287/peerj.preprints.3159v2) 

#### The benefits of git hub are

- Work becomes intergrated 
- Collaboration is much easier and a great tool
- A great website space to present code and working
- Great for courses such as “data science”
- Helps create competence in R quicker 

#### Purpose of Git
- Git main purpose is to help groups of developers work collaboratively on big software projects
- Git hub issues help identify bugs with the whole group

#### Commiting work
- You can push commits to git hub while you work which takes a snapshot of all files in the project
- Every time you commit you must also write a commit message signaling what change was made and the diff will show the content??
- You can look at history by reading commit changes 
- A commit will be automatically nicknamed by Git (known as SHA)(it is a random string of 40 characters)
- You can designate snapshots as special with a tag .

#### Markdown
- Markdown is a markup language will HTML 
- Use `'''{r}` before and after code to put it in a nice box
- Once an.Rmd le has been renderedto.md,  anyone  viewing  it  on  GitHub  can  read  the  prose,  study  the  R  code,and  viewthe results of running that code,  including  figures. 

NOTE: You can use exactly the same machinery to prepare a renderedversion of an R  script, i.e. to go  from .R to .md

#### Which files to commit?

- You can direct Git to ignore specfic files or file types, such as autosaves created by your editor
- A file that Git does not ignore is said to be tracked.
- It is best to work on .R .md .csv when on github as the push and pull system and also ability to view data on git is much better
- **Source files:** These files are created and edited by hand, such as R scripts
- **Configuration files:** These files modify the behavior of a tool, for example. gitignore identifies files Git should not track and some-project.Rprojrecords RStudio project settings.
- **Derived products:** These files are programmatically generated from sourcefi les and have external value. By executing .R or rendering .Rmd files, you obtain artifacts such as intermediate data (e.g.,.csvor.rds) and figures (e.g.,.pngor.pdf)
- **Intermediates:** These files are programmatically generated and serve a temporary purpose, but are not intrinsically valuable (e.g.,.auxand.login LaTeX work flows)

#### Web presence 
- Simply having a project on GitHub gives it a web presence!  
- Non-users of GitHub can visit the project in the browser and interact with it like a webpage. 
- GitHub also offers several ways to host a proper website directly from a repository, collectively known as **GitHub Pages**.  








