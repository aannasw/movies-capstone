# ------------------------ IMDb Scraper in R -----------------------------------
# ------------------------ by Arti Annaswamy ------------------------------------

# This script firmly falls in the under-tested Beta category. Please let me know if you catch something that needs fixing.

getIMDbfin <- function(imdb_id){
  url <- paste("http://www.imdb.com/title/", imdb_id, "/", sep = "")
  raw <-  getURL(url,encoding="UTF-8") 
  PARSED <- htmlParse(raw) #Format the html code
  imdbId = imdb_id
  finlines = tryCatch(paste(gsub("[^[:graph:]]","\\1",xpathSApply(PARSED, "//*[(@id = 'titleDetails')]", xmlValue)), collapse = "|"), error = function(e) NA)
  data_frame(imdbId = imdbId, finlines = finlines)
}

getIMDbfin("tt1080016")

# Use gsub, regexpr and substr to get the Opening Weekend, Gross and Budget amts out of the 'finlines' text chunk