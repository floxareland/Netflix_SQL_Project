# Netflix Movies and TV Shows Data Analysis Using SQL
![Netflix Logo](https://github.com/floxareland/Netflix_SQL_Project/blob/main/BrandAssets_Logos_01-Wordmark.jpg)

## Overview
This project focuses on an in-depth analysis of Netflix's movie and TV show data using SQL. The aim is to derive meaningful insights and address key business questions based on the dataset. This README outlines the project's objectives, challenges, solutions, key discoveries, and conclusions.

## Objectives

- Examine the distribution of content types (movies vs. TV shows).
- Determine the most frequent ratings assigned to movies and TV shows.
- Analyze content based on release years, countries, and duration.
- Classify and explore content using specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT type,
COUNT(*) as num_of_type
FROM netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT type,rating,count_rating
FROM(
SELECT type,
rating,
COUNT(*) AS count_rating,
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY type,rating
)
WHERE ranking =1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT *
FROM netflix
WHERE release_year = 2020 and type ='Movie';
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 	
    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS new_country,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1
ORDER BY total_content DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT title,  SUBSTRING(duration, 1,POSITION ('m' IN duration)-1)::int AS duration
FROM Netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY 2 DESC
LIMIT 1;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 Years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT title,duration,type
FROM(
SELECT *,SPLIT_PART(duration,' ',1) :: integer AS num_of_seasons
FROM netflix
WHERE type= 'TV Show'
)
WHERE num_of_seasons >5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
TRIM(UNNEST(STRING_TO_ARRAY(listed_in,','))) AS genre,
COUNT(show_id) AS num_of_content
FROM netflix
GROUP BY genre;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT COUNT(*),EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS Year
FROM netflix
WHERE country LIKE '%India%'
GROUP BY Year
ORDER BY COUNT(*) DESC
LIMIT 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT *
FROM netflix
WHERE listed_in ILIKE '%Documentaries%' AND type ='Movie';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT *
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%' AND type='Movie' AND EXTRACT(YEAR FROM CURRENT_DATE)-release_year<10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(casts,','))) AS actor,COUNT(*) AS count_actor
FROM netflix
WHERE country LIKE '%India%'
GROUP BY actor
ORDER BY count_actor DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
SELECT 
CASE WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_content' ELSE 'Good_content' END AS description2,COUNT(*) AS count_desc
FROM netflix
GROUP BY description2;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset showcases a wide variety of movies and TV shows, spanning multiple genres and ratings.
- **Common Ratings:** Analyzing the most frequent ratings offers insights into the primary target audience for Netflix content.
- **Geographical Insights:**  Identifying top content-producing countries and analyzing release trends, particularly in India, reveals regional content distribution patterns.
- **Content Categorization:**  Grouping content by specific keywords helps in understanding the themes and genres prevalent on Netflix.

This analysis presents a holistic view of Netflix's content library, offering valuable insights that can support content strategy and decision-making.



- **YouTube**: [Subscribe to my channel for tutorials and insights](https://www.youtube.com/@zero_analyst)
- **Instagram**: [Follow me for daily tips and updates](https://www.instagram.com/zero_analyst/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/najirr)
- **Discord**: [Join our community to learn and grow together](https://discord.gg/36h5f2Z5PK)

Thank you for your support, and I look forward to connecting with you!
