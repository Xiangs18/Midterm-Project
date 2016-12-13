library(ggthemes)
library(ggplot2)
library(plotrix)
library(dplyr)


df <- read.csv('Tidydata.csv')

# Delete the unnecessary new column
dfnew <- select(df,-X)

# Data Visualization ------------------------------------------------------------

# Oidwithdraw for each year in bar diagram
a <- ggplot(dfnew, aes(x = year, y = gaswithdraw)) 
a + geom_bar(stat = "identity")

# Gaswithdraw for each year in bar diagram
b <- ggplot(dfnew, aes(x = year, y = oilwithdraw)) 
b + geom_bar(stat = "identity")

