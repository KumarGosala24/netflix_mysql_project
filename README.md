# Netflix Trends Analyzer using MySQL
![image alt](https://github.com/KumarGosala24/netflix_mysql_project/blob/557b50d8206f6a114740c1e29ba5ef3e78756657/logo.png)


### Overview
<hr style="border: none; border-top: 0.5px solid #ccc;" />

This project focuses on analyzing Netflix's movie and TV show catalog using MySQL. By writing SQL queries, we explore the structure and trends within the platform’s content. The project answers real-world business questions to gain actionable insights.


### 🎯 Objectives
<hr style="border: none; border-top: 0.2px solid #ccc;" />

 **•** Compare the number of Movies vs TV Shows on Netflix.

 **•** Find the most common content ratings.

 **•** Analyze content by release year, country, and duration.

 **•** Filter and classify shows based on keywords, genres, and other custom conditions.

 **•** Generate summaries and trends for content growth, popular actors, and more.


### 🗂️ Dataset
<hr style="border: none; border-top: 0.2px solid #ccc;" />

Source: Kaggle

 **•** Dataset Name: Netflix Movies and TV Shows

 **•** Dataset Link: [Movie Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows)


## Schema

```sql
CREATE TABLE netflix_data (
  show_id VARCHAR(20),
  type VARCHAR(20),
  title TEXT,
  director TEXT,
  cast TEXT,
  country TEXT,
  date_added VARCHAR(50),
  release_year INT,
  rating VARCHAR(20),
  duration VARCHAR(20),
  listed_in TEXT,
  description TEXT
);
```

### Business Problems and Solutions
___
#### 1. count the number of movies vs Tv shows
```sql
select type, count(*) as total_content
from netflix_data 
group by type;
```
#### 2. Find the most common rating for movies and TV shows
```sql
SELECT rating, COUNT(*) AS total
FROM netflix_data
GROUP BY rating
ORDER BY total DESC
LIMIT 1;
```
#### 3. List all movies released in a specific year (e.g., 2020)
```sql
SELECT *
FROM netflix_data
WHERE type = 'Movie' AND release_year = 2020;
```
#### 4. Find the top 5 countries with the most content on Netflix
```sql
SELECT country, COUNT(*) AS total
FROM netflix_data
GROUP BY country
ORDER BY total DESC
LIMIT 5;
```
#### 5. Identify the longest movie
```sql
select * from netflix_data 
where 
type = 'Movie'
and 
duration = (select max(duration) from netflix_data);
```
#### 6. Find content added in the last 5 years
```sql
SELECT *
FROM netflix_data
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;
```
#### 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
```sql
SELECT *
FROM netflix_data
WHERE director = 'Rajiv Chilaka'; 
```
#### 8. List all TV shows with more than 5 seasons
```sql
SELECT *
FROM netflix_data
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
  ```
#### 9. Count the number of content items in each genre
```sql
SELECT listed_in AS genre, COUNT(*) AS total
FROM netflix_data
GROUP BY listed_in
ORDER BY total DESC;
```
#### 10. Top 5 years with highest average content released in India
```sql
SELECT release_year, COUNT(*) AS total
FROM netflix_data
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY total DESC
LIMIT 5;
```
#### 11. List all movies that are documentaries
```sql
SELECT *
FROM netflix_data
WHERE type = 'Movie' AND listed_in LIKE '%Documentary%';
```
#### 12. Find all content without a director
```sql
SELECT *
FROM netflix_data
WHERE director IS NULL OR director = '';
```
#### 13. Find how many movies actor 'Salman Khan' appeared in last 10 years
```sql
SELECT COUNT(*) AS total
FROM netflix_data
WHERE type = 'Movie'
  AND `cast` LIKE '%Salman Khan%'
  AND release_year >= YEAR(CURDATE()) - 10;
  ```
#### 14. Top 10 actors with highest number of movies produced in India
```sql
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
```
#### 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
```sql
SELECT 
  CASE 
    WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
    ELSE 'Good'
  END AS category,
  COUNT(*) AS total
FROM netflix_data
GROUP BY category;
```
#### 16 Has Netflix increased or decreased content production over the years?
```sql
SELECT release_year, COUNT(*) AS total_titles
FROM netflix_data
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year ASC;
```
#### 17 Which country produces the most Netflix content?
```sql
SELECT country, COUNT(*) AS total_titles
FROM netflix_data
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;
```
#### 18  Which years saw the highest number of releases on Netflix?
```sql
SELECT release_year, COUNT(*) AS total_titles
FROM netflix_data
GROUP BY release_year
ORDER BY total_titles DESC
LIMIT 10;
```
#### 19 Find duplicate entries (same title, different metadata)
```sql
SELECT title, COUNT(*) AS duplicate_count
FROM netflix_data
GROUP BY title
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
```
#### 20 Which directors have the most content on Netflix?
```sql
SELECT director, COUNT(*) AS total_titles
FROM netflix_data
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;
```

### Findings and Conclusion
<hr style="border: none; border-top: 0.1px solid #ccc;" />
 **•** Content Variety: Netflix offers a wide mix of movies and TV shows, covering many genres and ratings.

 **•** Popular Ratings: The most frequent ratings reveal who the main audience is.

 **•** Regional Trends: India and other top countries show where Netflix focuses its content.

**•** Content Types: Grouping shows by keywords helps us understand the themes and nature of the library.

Overall, this analysis gives a clear picture of Netflix’s content and can guide future choices about what to add or promote.


### Author
<hr style="border: none; border-top: 0.1px solid #ccc;" />
This project demonstrates my MySQL skills through real-world Netflix data analysis, highlighting key abilities needed for data analyst roles.

Connect with me on [LinkedIn](https://www.linkedin.com/in/sowjanya-kumar-gosala/)


























 
