## challenge 
## Can you produce a bar plot of the mean wingspan for each species 
## and save it to your computer?

sparrow <- mean(22, 24, 21)
kingfisher <- mean(26, 23, 25)
eagle <- mean(195, 201, 185)
hummingbird <- mean(8, 9, 9)

## got the mean values in 
## vector part?
## got to name the two parts

wingspan <- c(sparrow, kingfisher, eagle, hummingbird)

bird_species <- c("sparrow", "kingfisher", "eagle", "hummingbird")


## make data frame
wings <- data.frame(bird_species, wingspan)

# Plot the bar plot & save it to file

png("birds.png", width=950, height=500)

barplot(wings$wingspan, names.arg = wings$bird_sp)
        
dev.off()

##then run this again to see plot?? maybe a better way lol
barplot(wings$wingspan, names.arg = wings$bird_sp)
