-- Netflix Project

CREATE TABLE NETFLIX
(
show_id VARCHAR(10),
type VARCHAR(10),
title VARCHAR(200),	
director VARCHAR(250),
casts VARCHAR(1000),	
country	VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(300)
);

SELECT * FROM NETFLIX;

SELECT COUNT(*) AS total_content FROM NETFLIX;

SELECT DISTINCT type FROM NETFLIX;

-- 15 Problems that we will be working on

-- 1. Count the number of movies VS TV Shows.

SELECT 
type,
COUNT(*) as total_content 
FROM NETFLIX
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows.

SELECT 
type,
rating,
COUNT(*)
FROM NETFLIX
GROUP BY 1, 2;

-- 3. List all movies released in a specific year (2021).

SELECT * FROM NETFLIX
WHERE type = 'Movie' AND release_year = 2021;

-- 4. Find the top 5 countries with the most content on Netflix.

SELECT
UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
Count(*) as total_content
FROM NETFLIX
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5. Identify the longest movie.

SELECT * FROM NETFLIX
WHERE type = 'Movie' AND duration = (SELECT MAX(duration) FROM NETFLIX);

-- 6. Find the content added in the last 5 years.

SELECT * FROM NETFLIX
WHERE To_Date(date_added, 'Month DD, YYYY') >= Current_Date - Interval '5 years';

-- 7. Find all the movies/ TV shows directed by "Milan Luthria".

SELECT * FROM NETFLIX
WHERE director LIKE '%Milan Luthria%';

-- 8. List all TV shows with more than 5 seasons.

SELECT * FROM NETFLIX
WHERE 
type = 'TV Show' 
AND 
SPLIT_PART(duration, ' ', 1)::numeric > 5;

-- 9. Count the number of content items in each genre.

SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, 
COUNT(show_id) AS total_content
FROM NETFLIX
GROUP BY 1;

-- 10. Find each year and the average number of content releases in India on Netflix. Return top 5 year with highest avg content release.

SELECT 
EXTRACT(YEAR FROM To_Date(date_added, 'Month DD, YYYY')) as year,
COUNT(*) AS yearly_content,
ROUND(COUNT(*)::numeric/ (SELECT COUNT(*) FROM NETFLIX WHERE country = 'India')::numeric * 100, 2) AS Avg_content_per_year 
FROM NETFLIX
WHERE country = 'India'
GROUP BY 1;

-- 11. List all the movies that are documentaries.

SELECT * FROM NETFLIX
WHERE type = 'Movie' AND listed_in = 'Documentaries';

-- 12. Find all the content without a director.

SELECT * FROM NETFLIX
WHERE director IS NULL;

-- 13. Find out how many movies the actor "Liam Hemsworth" appeared in last 15 years.

SELECT * FROM NETFLIX 
WHERE casts LIKE '%Liam Hemsworth%' AND 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 15;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM NETFLIX 
WHERE country LIKE '%India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15. Categorize the content based on the presence of the keywords "kill" and "violence" in the description field. Label content containing these keywords as 'Bad' and all other content as "Good". Count how many items fall into each category.

WITH New_Table
AS
(
SELECT *,
CASE 
WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Film'
ELSE 'Good_Film'
END category
FROM NETFLIX
)
SELECT 
category, 
COUNT(*) AS total_content
FROM New_Table
GROUP BY 1;