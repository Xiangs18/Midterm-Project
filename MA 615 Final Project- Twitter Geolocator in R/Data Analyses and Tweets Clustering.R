# More data cleaning so that only necessary columns are retained

# load in Raw data 
Data5 <- readRDS("StarbucksUSData.RDS")
# Data Cleaning
Data4 <- Data5[,c(1,13,20,21,22,29,34,37,38)]
# Combine Sentiment dataset with Data4 
Data3 <- cbind(Data4,mySentiment)
# More Data Cleaning
Data2 <- Data3[,c(1:9,18:19)]
# Add categorical variables into table based on the comparison of postive and negative scores
Data1 <- data.frame(Data2$positive - Data2$negative)
beautiful <- function(dk){
  if(dk > 0) {
    return(3)
  } else if (dk < 0) {
    return(1)
  } else {
    return(2)
  }
}
Data <- data.frame(Data2[1:11], apply(Data1, 1, beautiful))
colnames(Data)[12] <- "sentclass"
saveRDS(Data, "Data.RDS")
-----------------------------------------
# Cluster Tweets;Exploring spacial relationships

map.data <- map_data("state")
points <- data.frame(x=as.numeric(Data$place_lon), y=as.numeric(Data$place_lat), z=Data$sentclass)

points <- points[points$y>25,] 
ggplot(map.data)+
  geom_map(aes(map_id = region),
           map=map.data,
           fill="white",
           color="grey20",size=0.25)+
  expand_limits(x = map.data$long, y = map.data$lat)+
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        plot.background = element_blank(),
        plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) +
  geom_point(data = points,
             aes(x = x, y = y, colour = factor(z)), size = 1,alpha = 1) +
  ggtitle("                    Starbucks Tweets Clustering in the U.S.")













