library(ggthemes)
library(ggplot2)
library(plotrix)
library(dplyr)

df <- read.csv('Tidydata.csv')


# Delete the unnecessary new column
dfnew <- select(df,-X)

summary(dfnew)

attach(dfnew)

# Data Visualization ------------------------------------------------------------

# Oidwithdraw for each year in bar diagram
a <- ggplot(dfnew, aes(x = year, y = gaswithdraw)) 
a + geom_bar(stat = "identity")

# Gaswithdraw for each year in bar diagram
b <- ggplot(dfnew, aes(x = year, y = oilwithdraw)) 
b + geom_bar(stat = "identity")

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


# Merge data frames to get total gas and oil production
newstate_oil_gas = merge(newstatedata,newstatedata1)
oil_gas_sum <- mutate(newstate_oil_gas, total = sum_oil + sum_gas)


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


# Bar graphics indicating oil and gas withdraws corresponding to different Rural Urban Continuum Code at year 2011
dfnew.RUC <- select(dfnew, County_Name, Rural_Urban_Continuum_Code_2013, year:gaswithdraw)
dfnew.RUC2011 <- filter(dfnew.RUC, year == 2011)

gg <- ggplot(data = dfnew.RUC2011, aes(x = Rural_Urban_Continuum_Code_2013, y = oilwithdraw))
gg + geom_bar(stat = "identity") + labs(title = "Oil withdraws with different Rural Urban Continuum Code", x = "Rural Urban Continuum Code", y = "Oil withdraws in 2011")

gg <- ggplot(data = dfnew.RUC2011, aes(x = Rural_Urban_Continuum_Code_2013, y = gaswithdraw))
gg + geom_bar(stat = "identity") + labs(title = "Gas withdraws with different Rural Urban Continuum Code", x = "Rural Urban Continuum Code", y = "Gas withdraws in 2011")









  


