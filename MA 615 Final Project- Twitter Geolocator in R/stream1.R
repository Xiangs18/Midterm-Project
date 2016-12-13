library(streamR)
 
load("my_oauth.Rdata")

###########################################

filterStream("tweetsUS.json",
             track=c("Starbucks"),
             timeout=6000,
             oauth = my_oauth)

tweets.df <- parseTweets("tweetsUS.json",simplify = FALSE)
table(is.na(tweets.df$lat))

saveRDS(tweets.df, "StarbucksOriginalData.RDS")


library(ggplot2)
library(grid)

map.data <- map_data("state")
points <- data.frame(x=as.numeric(tweets.df$place_lon), y=as.numeric(tweets.df$place_lat))

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
        plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines"))+
        geom_point(data = points,
        aes(x = x, y = y), size = 1,
        alpha = 1/5, color = "darkgreen")+
  ggtitle("                   Tweets mentioning Starbucks in the U.S.")

------------------------------------------------------------------------

# Now we have some points outside U.S territorty. Since we only want to focus in US, we can
# filter out the positions outside the US afterwards. The following part will be involved of data cleaning

index <- which(tweets.df$country_code == "US")
tweetsClean.df <- tweets.df[index,]

map.data <- map_data("state")
points <- data.frame(x=as.numeric(tweetsClean.df$place_lon), y=as.numeric(tweetsClean.df$place_lat))

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
        plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines"))+
  geom_point(data = points,
             aes(x = x, y = y), size = 1,
             alpha = 1/5, color = "darkgreen")+
  ggtitle("                   Tweets mentioning Starbucks in the U.S.")


# We still have an outlier than is not in US Map, and therefore let us get rid of it. 
newindex <- which(tweetsClean.df$country == "Vereinigte Staaten")
tweetsFinalclean.df <- tweetsClean.df[-newindex,]
saveRDS(tweetsFinalclean.df, "StarbucksUSData.RDS")

map.data <- map_data("state")
points <- data.frame(x=as.numeric(tweetsFinalclean.df$place_lon), y=as.numeric(tweetsFinalclean.df$place_lat))

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
        plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines"))+
  geom_point(data = points,
             aes(x = x, y = y), size = 1,
             alpha = 1/5, color = "blue") +
  ggtitle("                   Tweets mentioning Starbucks in the U.S.")



