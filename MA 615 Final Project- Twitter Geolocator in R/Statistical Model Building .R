
write.csv(Data, "Data.csv")
# We load Data into EXCEl and make sure their full name column follow the same formart(City, States)
fullnames_update <- read.csv("Data.csv")
# Our ideas is to divide all states into 4 Areas(West, Mid_west, South, North East)
fullnames_update$State_names <- gsub(".*,","",fullnames_update$full_name)
fullnames_update$State_names <- gsub(".* ","",fullnames_update$State_names)
# Now we categorize 50 states into 4 regions: East, West, South, and Midwest 

# Regional divisions used by the United States Census Bureau
# 
# Region 4: Northeast
# Connecticut, Maine, Massachusetts, New Hampshire, Rhode Island, Vermont, New Jersey, New York, and Pennsylvania
# 
# Region 3: Midwest
# Illinois, Indiana, Michigan, Ohio, Wisconsin, Iowa, Kansas, Minnesota, Missouri, Nebraska, North Dakota, and South Dakota
# 
# Region 2: South
# Delaware, Florida, Georgia, Maryland, North Carolina, South Carolina, Virginia, District of Columbia, and West Virginia
# Alabama, Kentucky, Mississippi, Tennessee, Arkansas, Louisiana, Oklahoma, and Texas
# 
# Region 1: West
# Arizona, Colorado, Idaho, Montana, Nevada, New Mexico, Utah, Wyomingm, Alaska, California, Hawaii, Oregon, and Washington

Handsome <- function(input){
  Reg1 = c("WA", "MT", "OR", "ID", "WY", "CA", "NV", "UT", "CO", "AZ", "NM") # West
  Reg2 = c("OK", "TX", "AR", "LA", "MS", "AL", "TN", "KY", "WV", "MD", "DE", "DC", "VA", "NC", "SC", "GA", "FL") # South
  Reg3 = c("ND", "SD", "NE", "KS", "MO", "IA", "MN", "WI", "IL", "IN", "OH", "MI") # Midwest
  Reg4 = c("NY", "PA", "NJ", "CT", "RI", "MA", "VT", "NH", "ME") # Northeast
  if (input %in% Reg1)
    return(1)
  else if (input %in% Reg2)
    return(2)
  else if (input %in% Reg3)
    return(3)
  else
    return(4)
}
fullnames_update$regions <- apply(data.frame(fullnames_update$State_names), 1, Handsome)

# Let's build a model 
sentiment <- function(x){
  if(x==3)
    return("Positive")
  else if (x==2)
    return("Neutral")
  else
    return("Negative")
}
fullnames_update$sentiment <- apply(data.frame(fullnames_update$sentclass), 1, sentiment)


# Ordinal Logistic Regression
# extract data that will be used in the Ordinal Logistic Resgression Model 
logdata <- fullnames_update[,c("sentiment","regions")]
attach(logdata)

# load packages
library(foreign)
library(ggplot2)
library(MASS)
library(Hmisc)
library(reshape2)

# description of data
# categorical data distribution
lapply(logdata[, c("sentiment","regions")], table)
ftable(xtabs(~ regions + sentiment, data = logdata))


# Ordinal Logistic Regression
## fit ordered logit model and store results 'm'
logdata$sentiment <- as.factor(logdata$sentiment)
m <- polr(sentiment ~ regions, data = logdata, Hess=TRUE)
## view a summary of the model
summary(m)
## coefficient
coefficient <- coef(summary(m))
## calculate and store p values
p <- pnorm(abs(coefficient[, "t value"]), lower.tail = FALSE) * 2
## combined coefficient and p values
(mresult <- cbind(coefficient, "p value" = p))
## compute confidence interval
(ci <- confint(m)) # If the 95% CI does not cross 0, the parameter estimate is statistically significant.

sdata <- ftable(xtabs(~ regions + sentiment, data = logdata))
sdata <- as.data.frame(sdata)
shiny.data <- matrix(sdata$Freq,nrow=3,ncol=4,byrow=TRUE)
colnames(shiny.data) <- c("Midwest","Northeast","South","West")
rownames(shiny.data) <- c("Negative","Neutral","Positive")
shiny.data
saveRDS(shiny.data,"ShinyData.RDS")

