library(ggthemes)
library(ggplot2)
library(plotrix)
library(dplyr)

df <- read.csv('Tidydata.csv')

# Delete the unnecessary new column
dfnew <- select(df,-X)

# Data Visualization ------------------------------------------------------------

# Each State filled with categorical indicators
state_oil_growth<- ggplot(dfnew, aes(x=Stabr, fill=oil_change_group))+
  geom_bar() + labs(title = "Each State Filled with Growth Indicator", x = "States", y = "Counts")
state_oil_growth

state_gas_growth<- ggplot(dfnew, aes(x=Stabr, fill=gas_change_group))+
  geom_bar() + labs(title = "Each State Filled with Growth Indicator", x = "States", y = "Counts")
state_gas_growth

state_oil_gas_growth<- ggplot(dfnew, aes(x=Stabr, fill=oil_gas_change_group))+
  geom_bar() + labs(title = "Each State Filled with Growth Indicator", x = "States", y = "Counts")
state_oil_gas_growth