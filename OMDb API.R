# ------------------------ OMDb API -----------------------------------

# -------------- by Arti Annaswamy ------------------------------------
# This script firmly falls in the under-tested Beta category. Please let me know if you catch something that needs fixing.
# URL for more info on this API is at http://www.omdbapi.com

# ---------------------------------------------------------------------

# The script below creates a function that will take one or more IMDb IDs (in the format "tt#######") and 
# output a data frame with the API-provided data for all requested IMDb IDs. 

# For reference see the URL of any movie/TV show page on IMDB. For e.g. the URL for the 
# film "Star Wars: Episode III - Revenge of the Sith (2005)" is http://www.imdb.com/title/tt0121766/. 
# In this case, the IMDB ID would be tt0121766.

# How the scraper function works

#This function does the following:
  
#   1. Takes IMDB ID variable and creates a IMDB URL
#   2. Uses the getURL() function from the RCurl package to download the entire contents of the page into R
#   3. Uses the fromJSON() function from the rjson package to break the information down into its JSON components
#   4. Saves the resulting data as a data frame
#   5. Finally, running the for loop over a list of multiple IMDb IDs will give you a data-frame with all the results.

# Required libraries
library(rjson)
library(RCurl)

# --------------- OMDb API URL without Rotten Tomatoes data ---------------
# Pulls a "short" plot snippet, downloads in JSON format and requests year of release (y=yes)

omdb_url <- "http://www.omdbapi.com/?i=tt0318081&plot=short&r=json&y=yes" 

# --------------- OMDb API URL with Rotten Tomatoes ---------------
# Pulls all fields from the first API, with Rotten Tomatoes data added (tomatoes = true)

omdb_url_rt <- "http://www.omdbapi.com/?i=tt0318081&plot=short&r=json&y=yes&tomatoes=true"

# Create function using API with Rotten Tomatoes

getOmdb <- function(imdb_id){
  omdb_url <- paste("http://www.omdbapi.com/?i=", imdb_id, "&plot=short&r=json&y=yes&tomatoes=true", sep = "")
  omdb_raw <-  getURL(omdb_url,encoding="UTF-8") 
  omdb_PARSED <- fromJSON(omdb_raw) #Format the JSON code
  as.data.frame(omdb_PARSED)
}

# Get data
imdbIdList <- data.frame(imdbID = c("tt0034055", "tt0068768", "tt0090555", 
                                    "tt0119214", "tt0066049", "tt0422528", 
                                    "tt0110997", "tt0391198", "tt0384488", 
                                    "tt0095800", "tt0484111", "tt0082764", 
                                    "tt1935179", "tt0325805", "tt0241760", 
                                    "tt0368709", "tt0415978", "tt0071970", 
                                    "tt0162710", "tt1640459", "tt1149362", 
                                    "tt0092744", "tt0057869", "tt0317248", 
                                    "tt0165643"))

# Run Query on Sample List of IMDb IDs
omdbData = NULL
for (i in 1:nrow(imdbIdList)) {
  omdbData <- rbind(omdbData, getOmdb(imdbIdList[i,]))
}

# Write omdbData file

write.csv(omdbData, "omdbData.csv", row.names=FALSE)