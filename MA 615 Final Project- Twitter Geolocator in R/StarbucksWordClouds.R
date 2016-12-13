# Let's import necessary packages needed for generating a wordclound
library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(stringr)


# We try to get rid of Emoji and weried characters
Star_text <- sapply(tweetsFinalclean.df$text, function(row) iconv(row, "latin1", "ASCII", sub=""))
# create a corpus
Star_corpus = Corpus(VectorSource(Star_text))
# create document term matrix applying some transformations
tdm = TermDocumentMatrix(Star_corpus,
       control = list(removePunctuation = TRUE,
       stopwords = c("Starbucks", stopwords("english")),
       removeNumbers = TRUE, tolower = TRUE))

# define tdm as matrix
m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)
# plot wordcloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))

# save the image in png format
png("Starbuckswordclound.png", width=8, height=6, units="in", res=300)
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
dev.off()

--------------------------------------
# Now, let's build a world coulds of just twitter handles from Starbucks tweets

# We first focus on @
pal <- brewer.pal(9,"YlGnBu")
pal <- pal[-(1:4)]
foo <- str_extract_all(Star_text, "@\\w+")
namesCorpus1 <- Corpus(VectorSource(foo))
wordcloud(words = namesCorpus1, scale=c(3,0.5), max.words=40, random.order=FALSE, 
          rot.per=0.10, use.r.layout=FALSE, colors="red")
# Save the image in png format
png("Starbucks@wordclound.png", width=8, height=6, units="in", res=300)
wordcloud(words = namesCorpus1, scale=c(3,0.5), max.words=40, random.order=FALSE, 
          rot.per=0.10, use.r.layout=FALSE, colors="red")
dev.off()

# When focus on #
set.seed(146)
hoo <- str_extract_all(Star_text, "#\\w+")
namesCorpus2 <- Corpus(VectorSource(hoo))
wordcloud(words = namesCorpus2, scale=c(3,0.5), max.words=40, random.order=FALSE, 
          rot.per=0.10, use.r.layout=FALSE, colors=pal)

# Save the image in png format
png("Starbucks#wordclound.png", width=8, height=6, units="in", res=300)
wordcloud(words = namesCorpus2, scale=c(3,0.5), max.words=40, random.order=FALSE, 
          rot.per=0.10, use.r.layout=FALSE, colors=pal)
dev.off()
