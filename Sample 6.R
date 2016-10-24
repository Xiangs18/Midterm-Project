library(ggthemes)
library(ggplot2)
library(plotrix)
library(dplyr)

df <- read.csv('Tidydata.csv')

# Delete the unnecessary new column
dfnew <- select(df,-X)

# Data Visualization ------------------------------------------------------------

# Bar graphics indicating oil and gas withdraws corresponding to different Rural Urban Continuum Code at year 2011
dfnew.RUC <- select(dfnew, County_Name, Rural_Urban_Continuum_Code_2013, year:gaswithdraw)
dfnew.RUC2011 <- filter(dfnew.RUC, year == 2011)

gg <- ggplot(data = dfnew.RUC2011, aes(x = Rural_Urban_Continuum_Code_2013, y = oilwithdraw))
gg + geom_bar(stat = "identity") + labs(title = "Oil withdraws with different Rural Urban Continuum Code", x = "Rural Urban Continuum Code", y = "Oil withdraws in 2011")

gg <- ggplot(data = dfnew.RUC2011, aes(x = Rural_Urban_Continuum_Code_2013, y = gaswithdraw))
gg + geom_bar(stat = "identity") + labs(title = "Gas withdraws with different Rural Urban Continuum Code", x = "Rural Urban Continuum Code", y = "Gas withdraws in 2011")


