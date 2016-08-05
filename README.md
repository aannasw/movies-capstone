# Movies Capstone Project
Springboard's Foundations of Data Science Workshop https://www.springboard.com/workshops/data-science

Analysis of Opening Weekend Grosses for Movies released in USA (2005 - 2014)

#### Project Report
![Slide 4 - Data Sources](https://github.com/aannasw/movies-capstone/blob/master/assets/slide04_Data.png?raw=true)
![Slide 18 - Text Analysis](https://github.com/aannasw/movies-capstone/blob/master/assets/slide18_TextAnalysis.png?raw=true)
![Slide 23 - Per-Screen Averages](https://github.com/aannasw/movies-capstone/blob/master/assets/slide23_Screens.png?raw=true)

#### Software/Tech Info

Primarily R and APIs, but also some Python and SQL. This also necessitated hastily acquired knowledge of installing SQLObject ORM and installing and working with a SQLite database. The Python and SQL proved ultimately unnecessary for the purpose it was used for (see the section below on IMDbPy), but it was good practice.
- R Studio
- R packages like 
  - XML, RCurl, scrapeR, rjson, RJSONIO for data collecting
  - dplyr, stringr, tidyr, lubridate for data wrangling
  - ggplot2, ggthemes, gridExtra for visualization
  - caTools, ROCR, mice, rpart, rpart.plot, randomForest, caret, e1071, class, tm, SnowballC, flexclust for analysis
- APIs like OMDb, YouTube Search, YouTube Get
- Python, SQLite etc

#### Data sources

##### 1. Movie Lens via GroupLens.org
The genesis of this idea was from the Movie Lens data sets provided by [Group Lens](http://grouplens.org/datasets/movielens/). The '**MovieLens Latest**' dataset (30K movies, 21M ratings) as well as the subset (9K movies, 100K ratings) are both available for analysis. 

This analysis for this project began with the 8K subset. Once the data processing steps were nailed down, the same steps were applied to process the larger dataset. 

The dataset contains the following files:
- Movies with the columns `movieId`, `title`, and `genres`. The genres are in a pipe-separated list. 
  - *Data processing performed*: Parsed the list of genres out by creating new columns, one per genre, with a binary value identifying whether that particular movie is tagged with the said genre

- Ratings with the columns `userId`, `movieId`, `rating`, `timestamp`.
  - *Data processing performed*: Summarized the rating by mean and median, and attached to the `movies` dataset

- Links with the columns `movieId`, `imdbId`, `tmdbId`
  - *Data processing performed*: This dataset was the key to expanding out data collection to other websites. The imdbId is a proper primary key that attaches to a wealth of information available via the IMDb website.

- Tags with the columns `userId`, `movieId`, `tag`, `timestamp`
  - *Data processing performed*: This dataset has not been used in the analysis at this time. That may very well change - this is an interesting collection of descriptive phrases and tags applied to a particular movie by users.
  
##### 2. OMDb API
With the IMDb IDs provided in the 30K movies dataset, the [OMDb API](http://www.omdbapi.com) becomes a very useful tool to extract specific data from IMDb as well as from Rotten Tomatoes. The OMDb API has a few handy toggles for turning off and on a limited number of fields, but the data output is sufficient to perform some interesting analysis.

The R code for this scrape turned out to be pretty simple and easy to put together, and quick to run. See `'OMDb API.R'` for further details.

- `Title`: Coach Carter
- `Year`: 2005
- `Rated`: PG-13
- `Released`: 38366
- `Runtime`: 136 min
- `Genre`: Drama, Sport
- `Director`: Thomas Carter
- `Writer`: Mark Schwahn, John Gatins
- `Actors`: Samuel L. Jackson, Rob Brown, Robert Ri'chard, Rick Gonzalez
- `Plot`: Controversy surrounds high school basketball coach Ken Carter after he benches his entire team for breaking their academic contract with him.
- `Language`: English
- `Country`: USA, Germany
- `Awards`: 3 wins & 15 nominations.
- `Poster`: http://ia.media-imdb.com/images/M/MV5BMTIwMTc1MDQ1Nl5BMl5BanBnXkFtZTcwNDk3NzcyMQ@@._V1_SX300.jpg
- `Metascore`: 57
- `imdbRating`: 7.2
- `imdbVotes`: 84055
- `imdbID`: tt0393162
- `Type`: movie
- `tomatoMeter`: 65
- `tomatoImage`: fresh
- `tomatoRating`: 6.1
- `tomatoReviews`: 145
- `tomatoFresh`: 94
- `tomatoRotten`: 51
- `tomatoConsensus`: Even though it's based on a true story, Coach Carter is pretty formulaic stuff, but it's effective and energetic, thanks to a strong central performance from Samuel L. Jackson.
- `tomatoUserMeter`: 85
- `tomatoUserRating`: 3.7
- `tomatoUserReviews`: 405967
- `DVD`: 38524
- `BoxOffice`: $67.2M
- `Production`: Paramount Pictures
- `Website`: http://www.coachcartermovie.com/index2.html

##### 3. YouTube Data API v3

The purpose of using this API was first, to see what kind of options are available in the API of a company as large as Google and second, to see how the API key process works in combination with the quotas and rate limits set by Google. 

The data is queried in two steps:

1. A general keyword search of the movie name + year released + the word "trailer" to get the top 5 relevant results with that combination of words, and

2. A targeted query to get the number of views primarily, but also other datapoints like favoriteCount, likeCount, dislikeCount etc for each of the videos in the query results from step 1.

This involved a fair amount of grappling with `gsub` and string-operations in R to get the search string in the format `full+movie+name+yyyy+trailer` (for e.g. `edge+of+tomorrow+2014+trailer`), followed by setting up a developer account in Google and enabling the YouTube API, working with the fairly easy to use form-based documentation for the [general search](https://developers.google.com/youtube/v3/docs/search/list#try-it) and the [video stats](https://developers.google.com/youtube/v3/docs/videos/list#try-it) APIs, and some guesswork to get the R code going. See `youTube API.R` for more details.

##### 4. IMDb Alternate Interfaces (along with IMDbPY, SQLite etc)

This was by far the most painful, and ultimately, useless, for the purpose of this analysis. Yet, the process of going through it all proved informative and perhaps someday, when I have nothing better to do, I might give this another try.

IMDb provides a subset of its entire database (and even that's a pretty big set of files). This [reddit comment](https://www.reddit.com/r/datasets/comments/246ycf/imdbrottentomatoes_data/ch4hujb) conveys my feelings about this dataset better than I can, but suffice it to say that it is a very long, laborious process that may not ultimately yield the data you need. But great for practice in all the technologies and software it required for processing.

The process went as follows:

1. Download [IMDbPy](http://imdbpy.sourceforge.net) and install via Terminal or appropriate command line
2. Install an SQL ORM wrapper like [SQLObject](http://sqlobject.org)
3. Install a database engine like SQLite (actually, don't use SQLite, since the IMDbPY documentation that I read too late, specifically says that IMDbPY doesn't do well with SQLite. It took over 35 hours to completely unpack and import the IMDB text file downloads. That is before I manually deleted several large text files I did not need, or it may very well have taken 48-60 hrs. 
Again, there is *nothing wrong* with SQLite. It just doesn't work that well with the IMDbPY processing. In tests conducted by IMDbPY, MySQL seems to have performed best.
4. Create an empty database using SQLite or your preferred tool
5. Save the IMDb zip files you want included in the database in a folder on your computer
6. Using the full paths of the locations of 1) the IMDbPY setup file 2) the SQLite database and 3) the IMDb source files, run the setup file
7. At this point, you could use Python to query the resulting database, or like I did, being more familiar with SQL, used SQL to query and extract the necessary data files
8. This is around when I discovered that the extracted data files possess no primary key at all that ties the data to the IMDb ID. (!!!!). 
Apparently using the IMDbPY files and scripts queries the website directly, giving you the IMDb ID in the process (or so I understand from skimming through the documentation), but the **downloaded** data files do not contain the IMDb ID.

#### 5. IMDB Data Scraper

And finally, lacking any other way of getting movie financial data from IMDb, I wrote a scraper in R that collects the financial info for a pre-cleaned, pre-filtered dataset. Since this data isn't consistently available on IMDb, they have not designated very specific html/xml formatting for this data and as a result, the data still downloads as a chunk. Further `gsub` and `substring` magic is required to extract the 'Opening Weekend:', 'Gross:' and 'Budget:' numbers from the text chunk.

See `IMDb scraper.R` for more info.

#### 6. Box Office Mojo Scraper

Box Office Mojo contains a few key pieces of data that aren't available consistently on IMDb - namely, opening weekend box office, daily collections, # of screens released, and best of all, inflation-adjusted opening weekend numbers and the flexibility to set the year you'd like to track against i.e. 2005 opening weekend numbers in today's dollars.

The process I used to get and clean this data involved multiple passes in R and a lot of relying on Excel and Excel formulas for a few cheats here and there, so a clear workflow isn't currently available for me to upload here. Stay tuned.

### Thoughts and next steps
If you've read this far, thank you for visiting and I hope you enjoy the visualizations and analysis. Feel free to initiate a conversation or send me your suggestions / comments / struggles with getting IMDb data via my website http://artiannaswamy.com

