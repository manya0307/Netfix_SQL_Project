# Netfix Data Analysis using SQL

![Netflix logo](netflix.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. 

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql

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
```

## 15 Business Problems that we will be working on

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
type,
COUNT(*) as total_content 
FROM NETFLIX
GROUP BY type;
```

### 2. Find the most common rating for movies and TV shows.

```sql
SELECT 
type,
rating,
COUNT(*)
FROM NETFLIX
GROUP BY 1, 2;
```

### 3. List all movies released in a specific year (2021).

```sql
SELECT * FROM NETFLIX
WHERE type = 'Movie' AND release_year = 2021;
```

### 4. Find the top 5 countries with the most content on Netflix.

```sql
SELECT
UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
Count(*) as total_content
FROM NETFLIX
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

### 5. Identify the longest movie.

```sql
SELECT * FROM NETFLIX
WHERE type = 'Movie' AND duration = (SELECT MAX(duration) FROM NETFLIX);
```

### 6. Find the content added in the last 5 years.

```sql
SELECT * FROM NETFLIX
WHERE To_Date(date_added, 'Month DD, YYYY') >= Current_Date - Interval '5 years';
```

### 7. Find all the movies/ TV shows directed by "Milan Luthria".

```sql
SELECT * FROM NETFLIX
WHERE director LIKE '%Milan Luthria%';
```

### 8. List all TV shows with more than 5 seasons.

```sql
SELECT * FROM NETFLIX
WHERE 
type = 'TV Show' 
AND 
SPLIT_PART(duration, ' ', 1)::numeric > 5;
```

### 9. Count the number of content items in each genre.

```sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, 
COUNT(show_id) AS total_content
FROM NETFLIX
GROUP BY 1;
```

### 10. Find each year and the average number of content releases in India on Netflix. Return top 5 year with highest avg content release.

```sql
SELECT 
EXTRACT(YEAR FROM To_Date(date_added, 'Month DD, YYYY')) as year,
COUNT(*) AS yearly_content,
ROUND(COUNT(*)::numeric/ (SELECT COUNT(*) FROM NETFLIX WHERE country = 'India')::numeric * 100, 2) AS Avg_content_per_year 
FROM NETFLIX
WHERE country = 'India'
GROUP BY 1;
```

### 11. List all the movies that are documentaries.

```sql
SELECT * FROM NETFLIX
WHERE type = 'Movie' AND listed_in = 'Documentaries';
```

### 12. Find all the content without a director.

```sql
SELECT * FROM NETFLIX
WHERE director IS NULL;
```

### 13. Find out how many movies the actor "Liam Hemsworth" appeared in last 15 years.

```sql
SELECT * FROM NETFLIX 
WHERE casts LIKE '%Liam Hemsworth%' AND 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 15;
```

### 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

```sql
SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM NETFLIX 
WHERE country LIKE '%India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

### 15. Categorize the content based on the presence of the keywords "kill" and "violence" in the description field. Label content containing these keywords as 'Bad' and all other content as "Good". Count how many items fall into each category.

```sql
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
```

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## Author - Manya Singh

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. 

