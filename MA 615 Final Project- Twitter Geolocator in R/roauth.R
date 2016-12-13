
library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "VDgfnCeaFq4W2HDeEgMITzRK6"
consumerSecret <- "KS6YtieQJ2X1BsYvF5YcbSP9FBTlvhlHNL32nbSk8H142OS3Wh"
my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
                             requestURL = requestURL, accessURL = accessURL, authURL = authURL)


#### Now you need a pin from dev.twitter.com

my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(my_oauth, file = "my_oauth.Rdata")

