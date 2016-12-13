## Statistical Model: Bootstrap


# load data
starclass <- readRDS("Data.RDS")

index.pos <- which(starclass$sentclass==3)
index.neu <- which(starclass$sentclass==2)
index.neg <- which(starclass$sentclass==1)

pos.fav <- starclass[index.pos,]$favourites_count
neu.fav <- starclass[index.neu,]$favourites_count
neg.fav <- starclass[index.neg,]$favourites_count
pos.fol <- starclass[index.pos,]$followers_count
neu.fol <- starclass[index.neu,]$followers_count
neg.fol <- starclass[index.neg,]$followers_count
pos <- starclass[index.pos,]
neu <- starclass[index.neu,]
neg <- starclass[index.neg,]
attach(pos)
attach(neu)
attach(neg)

# plot density of favourites_count and followers_count

# followers count
ggplot(data=pos, aes(followers_count))+geom_density(kernel="gaussian") +
ggtitle("Density of followers count of positive tweets")

ggplot(data=neu, aes(followers_count))+geom_density(kernel="gaussian") +
ggtitle("Density of followers count of neutral tweets")

ggplot(data=neg, aes(followers_count))+geom_density(kernel="gaussian") +
ggtitle("Density of followers count of negative tweets")


# favourites count
ggplot(data=pos, aes(favourites_count))+geom_density(kernel="gaussian") +
ggtitle("Density of favourites count of positive tweets")

ggplot(data=neu, aes(favourites_count))+geom_density(kernel="gaussian") +
ggtitle("Density of favourites count of neutral tweets")

ggplot(data=neg, aes(favourites_count))+geom_density(kernel="gaussian") +
ggtitle("Density of favourites count of negative tweets")


# use bootstrap to find mean of favourites_count for nagative, neutral and positive tweets
library(boot)

funmean <- function(data, index)
{
  x <- data[index]
  return(mean(x))
}

# bootstrap for positive, neutral and negtive
bootout.posfav <- boot(pos.fav, funmean, R = 10000)
bootci.posfav <- boot.ci(bootout.posfav, conf = 0.95, type = "all")
bootout.posfav
plot(bootout.posfav)
bootci.posfav

bootout.neufav <- boot(neu.fav, funmean, R = 10000)
bootci.neufav <- boot.ci(bootout.neufav, conf = 0.95, type = "all")
bootout.neufav
plot(bootout.neufav)
bootci.neufav

bootout.negfav <- boot(neg.fav, funmean, R = 10000)
bootci.negfav <- boot.ci(bootout.negfav, conf = 0.95, type = "all")
bootout.negfav
plot(bootout.negfav)
bootci.negfav



# use bootstrap to find mean of followers_count for nagative, neutral and positive tweets

bootout.posfol <- boot(pos.fol, funmean, R = 10000)
bootci.posfol <- boot.ci(bootout.posfol, conf = 0.95, type = "all")
bootout.posfol
plot(bootout.posfol)
bootci.posfol

bootout.neufol <- boot(neu.fav, funmean, R = 10000)
bootci.neufol <- boot.ci(bootout.neufol, conf = 0.95, type = "all")
bootout.neufol
plot(bootout.neufol)
bootci.neufol

bootout.negfol <- boot(neg.fav, funmean, R = 10000)
bootci.negfol <- boot.ci(bootout.negfol, conf = 0.95, type = "all")
bootout.negfol
plot(bootout.negfol)
bootci.negfol


