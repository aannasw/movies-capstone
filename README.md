# movies-capstone
Foundations of Data Science Capstone Project - Analysis of Opening Weekend Grosses for Movies released in USA (2005 - 2014)

#### Software/Tech Info
Primarily R and APIs, but also some Python and SQL. The SQL also required hastily acquired knowledge of installing SQLObject ORM and installing and working with a SQLite database. The Python and SQL provided ultimately unnecessary for the purpose it was used for (see the section below on IMDbPy), but it was good practice.

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

The purpose of using this API was to 1) see what kind of options are available in the API of a company as large as Google and 2) see how the API key process works in combination with the quotas and rate limits set by Google. 

The data is queried in two steps:
1. A general keyword search of the movie name + year released + the word "trailer" to get the top 5 relevant results with that combination of words, and
2. A targeted query to get the number of views primarily, but also other datapoints like favoriteCount, likeCount, dislikeCount etc for each of the videos in the query results from step 1.

This involved a fair amount of grappling with `gsub` and string-operations in R to get the searching string in this format `full+movie+name+yyyy+trailer` (for e.g. `edge+of+tomorrow+2014+trailer`), followed by setting up a developer account in Google and enabling the YouTube API, working with the fairly easy to use form-based documentation for the [general search](https://developers.google.com/youtube/v3/docs/search/list#try-it) and the [video stats](https://developers.google.com/youtube/v3/docs/videos/list#try-it) APIs, and some guesswork to get the R code going. See `youTube API.R` for more details.

##### 4. OMDb API
With the IMDb IDs provided in the 30K movies dataset, the [OMDb API](http://www.omdbapi.com) becomes a 
