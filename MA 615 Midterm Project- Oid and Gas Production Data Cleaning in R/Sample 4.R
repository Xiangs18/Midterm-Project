library(ggthemes)
library(ggplot2)
library(plotrix)
library(dplyr)

df <- read.csv('Tidydata.csv')

# Delete the unnecessary new column
dfnew <- select(df,-X)

# Data Visualization ------------------------------------------------------------

# Merge data frames to get total gas and oil production
newstate_oil_gas = merge(newstatedata,newstatedata1)
oil_gas_sum <- mutate(newstate_oil_gas, total = sum_oil + sum_gas)
View(oil_gas_sum)