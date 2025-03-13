

-- 15 Business Problems

--1. Count the number of Movies vs TV Shows
SELECT type,
COUNT(*) as num_of_type
FROM netflix
GROUP BY type;
--2. Find the most common rating for Movies and TV Shows
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

--3. List all movies released in a specific year 2020

SELECT *
FROM netflix
WHERE release_year = 2020 and type ='Movie';

--4. Find the top 5 countries with the most content on Netflix

SELECT 	
    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS new_country,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1
ORDER BY total_content DESC
LIMIT 5;

--5. Identify the longest Movie


SELECT title,  SUBSTRING(duration, 1,POSITION ('m' IN duration)-1)::int AS duration
FROM Netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY 2 DESC
LIMIT 1;

--6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 Years';

--7. Find all the Movies/TV Shows by director 'Mike Flanagan'

SELECT *
FROM netflix
WHERE director ILIKE '%Mike Flanagan%';

--8. List all TV Shows with more than 5 seasons
SELECT title,duration,type
FROM(
SELECT *,SPLIT_PART(duration,' ',1) :: integer AS num_of_seasons
FROM netflix
WHERE type= 'TV Show'
)
WHERE num_of_seasons >5;

--9. Count the number of content items in each genre

SELECT 
TRIM(UNNEST(STRING_TO_ARRAY(listed_in,','))) AS genre,
COUNT(show_id) AS num_of_content
FROM netflix
GROUP BY genre;

--10. Find each year and the average number of content release in India on netflix. Return top 5 year with highest average content release.

SELECT COUNT(*),EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS Year
FROM netflix
WHERE country LIKE '%India%'
GROUP BY Year
ORDER BY COUNT(*) DESC
LIMIT 5;
--11. List all movies that are documentaries

SELECT *
FROM netflix
WHERE listed_in ILIKE '%Documentaries%' AND type ='Movie';

--12. Find all content without a director

SELECT *
FROM netflix
WHERE director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years.

SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%' AND type='Movie' AND EXTRACT(YEAR FROM CURRENT_DATE)-release_year<10;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India. 

SELECT TRIM(UNNEST(STRING_TO_ARRAY(casts,','))) AS actor,COUNT(*) AS count_actor
FROM netflix
WHERE country LIKE '%India%'
GROUP BY actor
ORDER BY count_actor DESC
LIMIT 10;

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad_content' and all other content as 'Good_content'.Count how many items fall into each category.

SELECT 
CASE WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_content' ELSE 'Good_content' END AS description2,COUNT(*) AS count_desc
FROM netflix
GROUP BY description2;