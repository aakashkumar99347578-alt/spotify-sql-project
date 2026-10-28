# Spotify SQL Project

A SQL-based data analysis project based on the Spotify dataset (`cleaned_dataset.csv`). This project covers database table creation, exploratory data analysis (EDA), data cleaning, and solving business queries categorized into Easy, Medium, and Advanced difficulty levels.

---

## Project Structure

- **`cleaned_dataset.csv`**: Cleaned dataset containing Spotify track attributes, audio features, and streaming/view metrics.
- **`spotify SQL Project.sql`**: Complete SQL script containing table creation schema, EDA queries, data cleaning steps, and analytical business queries.

---

## Database Schema

```sql
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
```

---

## Exploratory Data Analysis (EDA) & Data Cleaning

### 1. View Data & Record Count
```sql
SELECT * FROM spotfiy;
SELECT COUNT(*) FROM spotfiy;
```

### 2. Unique Artists & Album Types
```sql
-- Unique artists
SELECT COUNT(DISTINCT artist) FROM spotfiy;

-- Album types
SELECT DISTINCT album_type FROM spotfiy;
```

### 3. Track Duration Range Check & Cleaning
```sql
-- Check min and max track duration
SELECT MAX(duration_main) FROM spotfiy;
SELECT MIN(duration_main) FROM spotfiy;

-- Check and delete tracks with duration = 0
SELECT * FROM spotfiy WHERE duration_main = 0;
DELETE FROM spotfiy WHERE duration_main = 0;
SELECT * FROM spotfiy WHERE duration_main = 0;
```

### 4. Channels & Streaming Platforms
```sql
-- Distinct channels
SELECT DISTINCT channel FROM spotfiy;

-- Platforms where tracks are most played
SELECT DISTINCT most_played_on FROM spotfiy;
```

---

## Business Questions & SQL Queries

### Easy Category

#### 1. Retrieve the names of all tracks that have more than 1 billion streams
```sql
SELECT DISTINCT track FROM spotfiy
WHERE stream > 1000000000;
```

#### 2. List all albums along with their respective artists
```sql
SELECT DISTINCT album, artist
FROM spotfiy
ORDER BY 1;
```

#### 3. Get the total number of comments for tracks where licensed = TRUE
```sql
SELECT SUM(comments) AS total_comments
FROM spotfiy
WHERE licensed = 'True';
```

#### 4. Find all tracks that belong to the album type 'single'
```sql
SELECT track
FROM spotfiy
WHERE album_type ILIKE 'single';
```

#### 5. Count the total number of tracks by each artist
```sql
SELECT artist, COUNT(track) AS total_number_songs
FROM spotfiy
GROUP BY 1
ORDER BY 2 DESC;
```

---

### Medium Category

#### 1. Calculate the average danceability of tracks in each album
```sql
SELECT album,
       AVG(danceability) AS avg_danceability 	
FROM spotfiy
GROUP BY 1
ORDER BY 2 DESC;
```

#### 2. Find the top 5 tracks with the highest energy values
```sql
SELECT track, AVG(energy)
FROM spotfiy
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

#### 3. List all tracks along with their views and likes where official_video = TRUE
```sql
SELECT track,
       SUM(views) AS total_views,
       SUM(likes) AS total_likes,
       SUM(comments) AS total_comments
FROM spotfiy
WHERE official_video = 'true'
GROUP BY 1;
```

#### 4. For each album, calculate the total views of all associated tracks
```sql
SELECT album, track,
       SUM(views) AS total_likes
FROM spotfiy
GROUP BY 1, 2
ORDER BY 3 DESC;
```

#### 5. Retrieve track names that have been streamed on Spotify more than YouTube
```sql
SELECT * FROM 
(SELECT
    track,
    COALESCE(SUM(CASE WHEN most_played_on = 'youtube' THEN stream END), 0) AS streamed_on_youtube,
    COALESCE(SUM(CASE WHEN most_played_on = 'spotfiy' THEN stream END), 0) AS streamed_on_spotfiy
FROM spotfiy
GROUP BY 1
) AS t1
WHERE streamed_on_spotfiy > streamed_on_youtube
  AND streamed_on_spotfiy <> 0;
```

---

### Advanced Category

#### 1. Find the top 3 most-viewed tracks for each artist using window functions
```sql
WITH ranking_artist AS
(
    SELECT track, artist, SUM(views) AS mosted_views,
           DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM spotfiy
    GROUP BY 2, 1
    ORDER BY 2, 3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3;
```

#### 2. Find tracks where the liveness score is above the average
```sql
SELECT track, artist, liveness
FROM spotfiy
WHERE liveness > (SELECT AVG(liveness) FROM spotfiy);
```

#### 3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album
```sql
WITH cte AS
(
    SELECT album,
           MAX(energy) AS highest_energy,
           MIN(energy) AS lowest_energy 
    FROM spotfiy
    GROUP BY 1
)
SELECT album, highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC;
```
