-- SPOTFIY SQL PROJECT 
-- CREATE TABLE 
DROP TABLE IF EXISTS spotfiy;
CREATE TABLE spotfiy(
	artist VARCHAR(275),
	track VARCHAR(275),
	album VARCHAR(275),
	album_type VARCHAR(75),
	danceability FLOAT,
	energy FLOAT,
	loudness FLOAT,
	speechiness FLOAT,
	acousticness FLOAT,
	instrumentalness FLOAT,
	liveness FLOAT,
	valence FLOAT,
	tempo FLOAT,
	duration_main FLOAT,
	title VARCHAR(275),
	channel VARCHAR(275),
	views FLOAT,
	likes BIGINT,
	comments BIGINT,
	licensed BOOLEAN,
	official_video BOOLEAN,
	stream BIGINT,
	energy_liveness FLOAT,
	most_played_on VARCHAR(75)
);

-- see the data 
SELECT * FROM spotfiy;

--EDA
SELECT COUNT(*) FROM spotfiy;

-- unique artist
SELECT COUNT(DISTINCT artist) FROM spotfiy;

-- how many ablum types in spotfiy
SELECT DISTINCT album_type FROM spotfiy;

SELECT MAX(duration_main) FROM spotFIy;
SELECT MIN(duration_main) FROM spotFIy;

SELECT * FROM spotfiy
WHERE duration_main =0;

-- deleted row because duration_main is zero is not possiable
DELETE FROM spotfiy
WHERE duration_main=0;

-- now recheck any row have zero mintues durations time
SELECT * FROM spotfiy
WHERE duration_main =0;

-- how many type of channel
SELECT DISTINCT channel FROM spotfiy;

-- most_played_on spotfiy
SELECT DISTINCT most_played_on FROM spotfiy;

----------------------------------------------------
--Data Analysis - Esay Category
----------------------------------------------------

--1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT DISTINCT track FROM spotfiy
WHERE stream>1000000000;

--2. List all albums along with their respective artists.
SELECT DISTINCT album ,artist
FROM spotfiy
ORDER BY 1;

--3. Get the total number of comments for tracks where licensed =TRUE.
SELECT SUM(comments) AS total_comments
FROM spotfiy
WHERE licensed='True'

--4. Find all tracks that belong to the album type single
SELECT track
FROM spotfiy
WHERE album_type ILIKE 'single'

--5. count the total number of tracks by each artist.
SELECT artist, COUNT(track) AS total_number_songs
FROM spotfiy
GROUP BY 1
ORDER BY 2 DESC;

-------------------------------------------
--Data Analysis Medium Level Questions
-------------------------------------------

--1. calculate the average danceability of tracks in each album.
SELECT album,
	   avg(danceability) AS avg_danceability 	
FROM spotfiy
GROUP BY 1
ORDER BY 2 DESC;

--2.Find the top 5 tracks with the highest energy values.
SELECT track,avg(energy)
FROM spotfiy
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--3.List all tracks along with their views and likes where official_video =True.
SELECT track,
	   sum(views) AS total_views,
	   sum(likes) AS total_likes,
	   sum(comments) AS total_comments
FROM spotfiy
WHERE official_video='true'
GROUP BY 1;

--4. For each album, calculate the total views of all associated tracks.
SELECT album,track,
	   sum(views) AS total_likes
FROM spotfiy
GROUP BY 1,2
ORDER BY 3 DESC;

--5. Retrieve the track names that been streamed on spotfiy more than youtube.
SELECT * FROM 
(SELECT
	track,
	COALESCE(SUM(CASE WHEN most_played_on ='youtube' THEN stream END),0) AS streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on ='spotfiy' THEN stream END),0) AS streamed_on_spotfiy
FROM spotfiy
GROUP BY 1
) as t1
WHERE streamed_on_spotfiy>streamed_on_youtube
	  AND 
	  streamed_on_spotfiy <>0
	

SELECT * FROM spotfiy

-----------------------------------------------
-- Data Analysis Advanced leve Sql Quries
-----------------------------------------------

--1. Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_artist
AS
(SELECT track,artist,SUM(views) AS mosted_views,
	   DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotfiy
GROUP BY 2,1
ORDER BY 2,3 DESC
)
SELECT * FROM ranking_artist
WHERE rank<=3

--2. Write a query to find tracks where the liveness score is above the average.
SELECT track,artist,liveness
FROM spotfiy
WHERE liveness > (SELECT AVG(liveness) FROM spotfiy)

--3. Use a with clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte
AS
(SELECT album,
	   MAX(energy) AS highest_energy,
	   MIN(energy) AS lowest_energy 
FROM spotfiy
GROUP BY 1
)
SELECT album,highest_energy-lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC;

























