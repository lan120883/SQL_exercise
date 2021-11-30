/* SQL Exercise
====================================================================
We will be working with database imdb.db
You can download it here: https://drive.google.com/file/d/1E3KQDdGJs4a0i1RoYb8DEq0PFxCgI6cN/view?usp=sharing
*/


-- MAKE YOURSELF FAMILIAR WITH THE DATABASE AND TABLES HERE

SELECT * FROM movie_distributors;
SELECT * FROM distributors WHERE name = 'Universal Pictures';




--==================================================================
/* TASK I
 Find the id's of movies that have been distributed by “Universal Pictures”.
*/
SELECT movie_id FROM movie_distributors 
  JOIN distributors ON movie_distributors.distributor_id = distributors.distributor_id 
  AND distributors.name = 'Universal Pictures';


/* TASK II
 Find the name of the companies that distributed movies released in 2006.
*/

SELECT name FROM distributors
 JOIN movie_distributors ON movie_distributors.distributor_id = distributors.distributor_id
 JOIN movies ON movies.movie_id = movie_distributors.movie_id
 AND movies.year = 2006;

/* TASK III
Find all pairs of movie titles released in the same year, after 2010.
hint: use self join on table movies.
*/

SELECT m1.title as movie1, m2.title as movie2 
FROM movies as m1, movies as m2
WHERE m1.year = m2.year and m1.year>2010
    and m1.movie_id <> m2.movie_id;


/* TASK IV
 Find the names and movie titles of directors that also acted in their movies.
*/

SELECT people.name, movies.title from movies
  JOIN directors ON directors.movie_id= movies.movie_id
  JOIN people ON people.person_id = directors.person_id
  JOIN roles ON roles.person_id = people.person_id
  AND  roles.movie_id = movies.movie_id
  AND roles.person_id = directors.person_id;




/* TASK V
Find ALL movies realeased in 2011 and their aka titles.
hint: left join
*/


SELECT movies.title, aka_titles.* FROM movies
LEFT JOIN aka_titles ON aka_titles.movie_id = movies.movie_id
AND movies.year = 2011


/* TASK VI
Find ALL movies realeased in 1976 OR 1977 and their composer's name.
*/

SELECT people.name, movies.title, movies.year FROM movies
JOIN composers ON composers.movie_id = movies.movie_id
JOIN people ON people.person_id = composers.person_id 
WHERE movies.year = 1976 OR movies.year = 1977; 


/* TASK VII
Find the most popular movie genres.
*/


SELECT genres.label FROM genres
WHERE genres.genre_id = (SELECT genre_id FROM movie_genres 
       GROUP BY genre_id order by COUNT(movie_id) desc LIMIT 1);


/* TASK VIII
Find the people that achieved the 10 highest average ratings for the movies 
they cinematographed.
*/
SELECT * FROM (
    SELECT people.name, AVG(movies.rating) as avg_rating FROM cinematographers as ci
    JOIN movies ON movies.movie_id = ci.movie_id
    JOIN people ON people.person_id = ci.person_id 
    GROUP BY people.name
) x WHERE avg_rating = 10




/* TASK IX
Find all countries which have produced at least one movie with a rating higher than
8.5.
hint: subquery
*/

SELECT DISTINCT name FROM countries 
JOIN movie_countries ON movie_countries.country_id = countries.country_id
JOIN movies ON movie_countries.movie_id = movies.movie_id 
WHERE rating > 8.5;



/* TASK X
Find the highest-rated movie, and report its title, year, rating, and country. There
can be ties; if so, you should report for each of them.
*/


SELECT title, year, rating, countries.name  FROM movies 
JOIN movie_countries ON movie_countries.movie_id = movies.movie_id
JOIN countries ON movie_countries.country_id = countries.country_id
ORDER BY rating DESC LIMIT 1



/* STRETCH BONUS
Find the pairs of people that have directed at least 5 movies and whose 
carees do not overlap (i.e. The release year of a director's last movie is 
lower than the release year of another director's first movie).
*/
SELECT x.*, y.* FROM (
    select people.name,people.person_id, count(directors.movie_id) as cnt, min(movies.year) as year_start, max(movies.year) as year_end from directors 
    join movies on movies.movie_id = directors.movie_id
    join people on people.person_id = directors.person_id
    group by people.name, people.person_id order by cnt desc 
) x ,
(
    select people.name,people.person_id, count(directors.movie_id) as cnt, min(movies.year) as year_start, max(movies.year) as year_end from directors 
    join movies on movies.movie_id = directors.movie_id
    join people on people.person_id = directors.person_id
    group by people.name, people.person_id order by cnt desc  
) y 
WHERE x.cnt>=5 AND y.cnt>5 AND x.person_id<>y.person_id AND x.year_end<y.year_start