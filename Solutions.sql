
-- 20 Bussiness problems 

-- 1. count the number of movies vs Tv shows

select type, count(*) as total_content
from netflix_data 
group by type;

-- 2. find the most common rating for  movies and Tv shows 


SELECT rating, COUNT(*) AS total
FROM netflix_data
GROUP BY rating
ORDER BY total DESC
LIMIT 1;

-- 3. list all movies relesead in a specific year

SELECT *
FROM netflix_data
WHERE type = 'Movie' AND release_year = 2020;


-- 4.  Find the top 5 countries with the most content on Netflix

SELECT country, COUNT(*) AS total
FROM netflix_data
GROUP BY country
ORDER BY total DESC
LIMIT 5;


-- 5. Identify the Longest Movie

select * from netflix_data;

select * from netflix_data 
where 
type = 'Movie'
and 
duration = (select max(duration) from netflix_data);


-- 6. Find Content Added in the Last 5 Years
SELECT *
FROM netflix_data
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;


-- 7 Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM netflix_data
WHERE director = 'Rajiv Chilaka';


-- 8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix_data
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;


-- 9. Count the number of content items in each genre

SELECT listed_in AS genre, COUNT(*) AS total
FROM netflix_data
GROUP BY listed_in
ORDER BY total DESC;


-- 10. Top 5 years with highest average content released in India

SELECT release_year, COUNT(*) AS total
FROM netflix_data
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY total DESC
LIMIT 5;


-- 11. List all movies that are documentaries

SELECT *
FROM netflix_data
WHERE type = 'Movie' AND listed_in LIKE '%Documentary%';



-- 12. Find all content without a director

SELECT *
FROM netflix_data
WHERE director IS NULL OR director = '';


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT COUNT(*) AS total
FROM netflix_data
WHERE type = 'Movie'
  AND `cast` LIKE '%Salman Khan%'
  AND release_year >= YEAR(CURDATE()) - 10;


-- 14. Top 10 actors with highest number of movies produced in India

SELECT actor, COUNT(*) AS total_movies
FROM (
  SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`cast`, ',', n.n), ',', -1)) AS actor
  FROM netflix_data
  JOIN (
    SELECT a.N + b.N * 10 + 1 AS n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
  ) n
  ON n.n <= 1 + LENGTH(`cast`) - LENGTH(REPLACE(`cast`, ',', ''))
  WHERE type = 'Movie' AND country LIKE '%India%'
) AS actor_list
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;


-- 15. Categorize content based on keywords in description

SELECT 
  CASE 
    WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
    ELSE 'Good'
  END AS category,
  COUNT(*) AS total
FROM netflix_data
GROUP BY category;


-- 16 Has Netflix increased or decreased content production over the years?

SELECT release_year, COUNT(*) AS total_titles
FROM netflix_data
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year ASC;


-- 17 Which country produces the most Netflix content?

SELECT country, COUNT(*) AS total_titles
FROM netflix_data
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;


-- 18  Which years saw the highest number of releases on Netflix?

SELECT release_year, COUNT(*) AS total_titles
FROM netflix_data
GROUP BY release_year
ORDER BY total_titles DESC
LIMIT 10;


-- 19 Find duplicate entries (same title, different metadata)

SELECT title, COUNT(*) AS duplicate_count
FROM netflix_data
GROUP BY title
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- 20 Which directors have the most content on Netflix?

SELECT director, COUNT(*) AS total_titles
FROM netflix_data
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;
