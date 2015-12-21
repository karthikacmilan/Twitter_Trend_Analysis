#Twitter OAuth 
rm(list=ls())
library(twitteR)
library(ROAuth)
library(RCurl)
#dowload curl cert
download.file(url="http://curl.haxx.se/ca/cacert.pem",
              destfile="cacert.pem")
#set constant values
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
#consumerkey and secret
consumerKey = "vbbXj015eOgSqNwU7A1NFBe94"
consumerSecret = "BVGoCYSshnXiyG4gGgwH1m9oc2m9y8SgEzkqrLpQLRJNpiNPvd"
twitCred <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret,
                             requestURL=requestURL,
                             accessURL=accessURL,
                             authURL=authURL)
#asking for access
twitCred$handshake(cainfo="cacert.pem")
#specify PIN XXXXXX
registerTwitterOAuth(twitCred)
save(list="twitCred", file="twitteR_credentials")
load("twitteR_credentials")
registerTwitterOAuth(twitCred)
searchte <- searchTwitter('#Datamining', cainfo="cacert.pem")
save(searchte,file="rdmTweets.Rdata")
