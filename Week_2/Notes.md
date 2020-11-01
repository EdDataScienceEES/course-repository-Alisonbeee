# Notes for data science

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
- Use '''{r} before and after code to put it in a nice box
- Once an.Rmd le has been renderedto.md,  anyone  viewing  it  on  GitHub  can  read  the  prose,  study  the  R  code,and  viewthe results of running that code,  including  figures. 

NOTE: You can use exactly the same machinery to prepare a renderedversion of an R  script, i.e. to go  from .R to .md

#### Which files to commit?

You can direct Git to ignore specfic files or file types, such as autosaves created by your editor
A file that Git does not ignore is said to be tracked.
It is best to work on .R .md .csv when on github as the push and pull system and also ability to view data on git is much better

**Source files:** These files are created and edited by hand, such as R scripts
**Configuration files:** These files modify the behavior of a tool, for example. gitignore identifies files Git should not track and some-project.Rprojrecords RStudio project settings.
**Derived products:** These files are programmatically generated from sourcefi les and have external value. By executing .R or rendering .Rmd files, you obtain artifacts such as intermediate data (e.g.,.csvor.rds) and figures (e.g.,.pngor.pdf)
**Intermediates:** These files are programmatically generated and serve a temporary purpose, but are not intrinsically valuable (e.g.,.auxand.login LaTeX work flows)

#### Web presence 
- Simply having a project on GitHub gives it a web presence!  
- Non-users of GitHub can visit the project in the browser and interact with it like a webpage. 
- GitHub also offers several ways to host a proper website directly from a repository, collectively known as **GitHub Pages**.  






