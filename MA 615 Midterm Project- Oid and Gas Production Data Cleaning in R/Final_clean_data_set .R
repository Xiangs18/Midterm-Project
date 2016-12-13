library(tidyr)
library(dplyr)
library(ggplot2)

# Data Cleaning  ----------------------------------------------------------

#load data
data.raw <- read.csv("oilgascounty.csv")

#convert data type to data frame
data0 <- data.frame(data.raw)

#gather oil data from 2000 to 2011
data.oil0 <- gather(data0, year, oilwithdraw, oil2000:oil2011)
data.oil <- mutate(data.oil0, year=(gsub("oil","",year)))

#gather gas data from 2000 to 2011
data.gas0 <- gather(data.oil, year2, gaswithdraw, gas2000:gas2011)
data.gas <- mutate(data.gas0, year2=(gsub("gas","",year2)))

#delete verbose rows where year is not equal to year2
data1 <- filter(data.gas, year == year2)

#delete verbose column year2 and geoid
data <- select(data1, -year2, -geoid)

#Swap columns to make data more self-describing
Tidydata <- data[,c(1:7,11:13,8:10)]

write.csv(Tidydata, 'Tidydata.csv')

