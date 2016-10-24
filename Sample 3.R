library(ggthemes)
library(ggplot2)
library(plotrix)
library(dplyr)

df <- read.csv('Tidydata.csv')

# Delete the unnecessary new column
dfnew <- select(df,-X)

# Data Visualization ------------------------------------------------------------

# Present top 10 biggest oil production states in piechart
newstatesoil <- dfnew %>% group_by(Stabr) %>% summarize(sum_oil = sum(as.numeric(oilwithdraw)))
pie(newstatesoil$sum_oil, labels = newstatesoil$Stabr, col = rainbow(length(newstatesoil$Stabr)),main = "Pie chart of country")
# We find that the pie chart is too dense. Let's list top 10 states, and its relative pie chart
newstatedata <- newstatesoil[order(-newstatesoil$sum_oil),]
# Now, here comes the top 10 states in oilwithdraw
Cleanstatedata <- newstatedata[1:10,]
pie(Cleanstatedata$sum_oil, labels = Cleanstatedata$Stabr, col = rainbow(length(Cleanstatedata$Stabr)),main = "Pie chart of country")


# Present top 10 biggest gas production states in piechart
newstatesgas <- dfnew %>% group_by(Stabr) %>% summarize(sum_gas = sum(as.numeric(gaswithdraw)))
newstatedata1 <- newstatesgas[order(-newstatesgas$sum_gas),]
# Now, here comes the top 10 states in gaswithdraw
Cleanstatedata1 <- newstatedata1[1:10,]
pie(Cleanstatedata1$sum_gas, labels = Cleanstatedata1$Stabr, col = rainbow(length(Cleanstatedata1$Stabr)),main = "Pie chart of country")
