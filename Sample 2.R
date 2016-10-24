library(ggthemes)
library(ggplot2)
library(plotrix)
library(dplyr)

df <- read.csv('Tidydata.csv')

# Delete the unnecessary new column
dfnew <- select(df,-X)

# Data Visualization ------------------------------------------------------------

# Each year's oilwithdraw filled with States
ab <- ggplot(dfnew, aes(x = year, y = oilwithdraw, fill = factor(Stabr))) + geom_bar(stat = "identity")
ab + labs(title = "Oilwithdraw for Each Year Filled with States", x = "Years", y = "Oildwithdraw(barrels)")

# Each year's gaswithdraw filled with States
ab <- ggplot(dfnew, aes(x = year, y = gaswithdraw, fill = factor(Stabr))) + geom_bar(stat = "identity")
ab + labs(title = "Gaswithdraw for Each Year Filled with States", x = "Years", y = "Gasdwithdraw(thousand cubic feet)")

# Each state's Oilwithdraw filled with year
c <- ggplot(dfnew, aes(x = Stabr, y = oilwithdraw, fill = factor(year))) + geom_bar(stat = "identity")
c + labs(title = "Oildwithdraw for Each State Filled with Year", x = "States", y = "Oildwithdraw(barrels)") + 
  theme_classic()

# Each state's gasdwithdraw filled with year
c <- ggplot(dfnew, aes(x = Stabr, y = gaswithdraw, fill = factor(year))) + geom_bar(stat = "identity")
c + labs(title = "Gasdwithdraw for Each State Filled with Year", x = "States", y = "Gaswithdraw(thousand cubic feet)") + 
  theme_wsj()