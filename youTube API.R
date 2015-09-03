# ------------------------ YouTube Data API v3 in R -----------------------------------
# ----------------------------- by Arti Annaswamy ------------------------------------

# This script firmly falls in the under-tested Beta category. Please let me know if you catch something that needs fixing.
# For more info on the general search and video stats aspects of this API, visit  
# https://developers.google.com/youtube/v3/docs/search/list#try-it and
# https://developers.google.com/youtube/v3/docs/videos/list#try-it respectively.

# API URL for video statistics 
# https://www.googleapis.com/youtube/v3/videos?part=statistics&id=L0JPE202szI&key={YOUR_API_KEY}

# API URL for video search by keyword
# https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=bourne+ultimatum+trailer
# &type=video&videoCaption=any&videoDuration=short&key={YOUR_API_KEY}

# --------------------------- IMPORTANT INFO --------------------------

# You will first need to sign up for a Google Developer Account (free) and then enable the YouTube API, and get 
# the API key, which you can assign to the yTubeAPIkey variable below.

yTubeAPIkey = "Paste your API key here between the quotes and run code to assign to variable"

# ------------------------------- Keyword Search with Top 5 results --------------------------------------

# The script below accepts a selection of keywords and returns the top 5 relevant results from YouTube
# To change the number of results returned, change the 'maxResults=5' part below. Lots of other changes
# are possible - check out the detailed documentation here: 
# https://developers.google.com/youtube/v3/docs/search/list#try-it

searchYtube <- function(x){
  url = paste("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=",x,"&type=video&videoCaption=any&videoDuration=short&key=",yTubeAPIkey, sep = "")
  raw.data <- getURL(url, encoding = "UTF-8")
  rd <- fromJSON(raw.data)
  if (rd$pageInfo$totalResults[1] != 0) {
    vidTitle = NULL
    vidID = NULL
    vidDate = NULL
    for (n in 1:5) {
      if (is.null(rd$items[n][[1]]) == TRUE) break
      vidTitle <- rbind(vidTitle, rd$items[[n]]$snippet$title) 
      vidID <- rbind(vidID, rd$items[[n]]$id$videoId) 
      vidDate <- rbind(vidDate, rd$items[[n]]$snippet$publishedAt)
    }
    vidSearchString <- rep(x, nrow(vidTitle))
    cbind.data.frame(vidSearchString, vidTitle, vidID, vidDate)
  }
}

# Try the API call
searchYtube("dark+knight+rises+2012+trailer")

# ------------------------------- Get Video Statistics by Video ID --------------------------------------

# The script below accepts a youTube video ID and returns the stats for that specific video.
# Lots of other changes are possible - check out the detailed documentation here: 
# https://developers.google.com/youtube/v3/docs/search/list#try-it

getYtube <- function(id){
  url=paste("https://www.googleapis.com/youtube/v3/videos?part=statistics&id=",id,"&maxResults=5&key=", yTubeAPIkey, sep = "")
  raw.data <- getURL(url, encoding = "UTF-8")
  rd <- fromJSON(raw.data)
  rd <- as.data.frame(rd)
  totalResults <- rd$pageInfo.totalResults
  itemID <- rd$items.id
  viewCount <- rd$items.statistics.viewCount
  likeCount <- rd$items.statistics.likeCount
  dislikeCount <- rd$items.statistics.dislikeCount
  favCount <- rd$items.statistics.favoriteCount
  commentCount <- rd$items.statistics.commentCount
  data_frame(itemID, viewCount, likeCount, dislikeCount, favCount, commentCount, totalResults)
}

# Try the API call
getYtube("GokKUqLcvD8")
