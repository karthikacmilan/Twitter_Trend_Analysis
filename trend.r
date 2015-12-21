library(twitteR)
library(NLP)
library(slam)
library(tm)
library(SnowballC)
library(ggplot2)
library(wordcloud)
#convert tweets to data frame
df = do.call("rbind",lapply(rdmTweets, as.data.frame))
#build the corpus 
corpusi = Corpus(VectorSource(df$text))
#convert to lower case
corpusi = tm_map(corpusi,tolower)
#remove punctuation
corpusi = tm_map(corpusi,removePunctuation)
#remove numbers
corpusi = tm_map(corpusi,removeNumbers)
#remove urls
Rurl = function(x) gsub("http[[:alnum]]*","", x)
corpusi = tm_map(corpusi,Rurl)
#remove stopwords
stpwords = c(stopwords('english'),"via")
corpusi = tm_map(corpusi,removeWords,stpwords)
#stem words for more accuracy and reducing redundancy 
corpcopy = corpusi
corpusi = tm_map(corpusi,stemDocument)
for(i in 11:15){
  cat(paste("[[",i,"]]",sep=""))
  writeLines(strwrap(corpusi[[i]],width=73))
}
#checking count of a word
countfi = tm_map(corpcopy,grep,pattern="\\<mining")
sum(unlist(countfi))
#t-d matrix 
corpusi = Corpus(VectorSource(corpusi))
tdm = TermDocumentMatrix(corpusi)
#frequent terms 
findFreqTerms(tdm,lowfreq = 10)
tf = rowSums(as.matrix(tdm))
tf = subset(tf,tf>=10)

pdf("frequency.pdf")
qplot(names(tf),tf) + coord_flip()
barplot(tf,las=2)
graphics.off()
#finding association 
findAssocs(tdm,'data',0.25)
#Word COunt
library(wordcloud)
m = as.matrix(tdm)
freq = sort(rowSums(m),decreasing = TRUE)
set.seed(1234)
gl = gray((freq+10)/(max(freq)+10))
pdf("wordcloud.pdf")
wordcloud(words = names(freq),freq=freq,min.freq = 3,random.order = F)
graphics.off()
#clustering
tdm2 = removeSparseTerms(tdm,sparse = 0.95)
m2 = as.matrix(tdm2)
dm = dist(scale(m2))
fir = hclust(dm,method = "ward")
plot(fir)
rect.hclust(fir,k=10)
(group = cutree(fir,k=10))
#k-means clustering for clustering tweets
m3 = t(m2)
set.seed(123)
#set no of clusters to 5
k = 5
kms = kmeans(m3,k)
round(kms$centers,digits = 3)
