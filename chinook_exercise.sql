/* SQL Exercise
====================================================================
We will be working with database chinook.db
You can download it here: https://drive.google.com/file/d/0Bz9_0VdXvv9bWUtqM0NBYzhKZ3c/view?usp=sharing&resourcekey=0-7zGUhDz0APEfX58SA8UKog

 The Chinook Database is about an imaginary video and music store. Each track is stored using one of the digital formats and has a genre. The store has also some playlists, where a single track can be part of several playlists. Orders are recorded for customers, but are called invoices. Every customer is assigned a support employee, and Employees report to other employees.
*/


-- MAKE YOURSELF FAIMLIAR WITH THE DATABASE AND TABLES HERE





--==================================================================
/* TASK I
Which artists did not make any albums at all? Include their names in your answer.
*/
SELECT Name FROM artists WHERE ArtistId not in(select ArtistId from albums)

/* TASK II
Which artists recorded any tracks of the Latin genre?
*/

SELECT DISTINCT artists.Name FROM artists
    JOIN albums ON artists.artistid = albums.artistid
    JOIN tracks ON albums.AlbumId = tracks.AlbumId
    WHERE tracks.GenreId = 7

/* TASK III
Which video track has the longest length?
*/

SELECT trackid, name, Milliseconds FROM tracks WHERE Milliseconds = (SELECT MAX(Milliseconds) FROM tracks)

/* TASK IV
Find the names of customers who live in the same city as the top employee (The one not managed by anyone).
*/

SELECT FirstName, LastName FROM customers WHERE City IN (SELECT city FROM employees WHERE ReportsTo is NULL)

/* TASK V
Find the managers of employees supporting Brazilian customers.
*/

SELECT FirstName, LastName FROM employees 
      WHERE EmployeeId IN   (SELECT ReportsTo FROM employees 
                                            WHERE EmployeeId IN (SELECT SupportRepId FROM customers 
                                                                                     WHERE Country = 'Brazil'
                                                                )
                            )

/* TASK VI
Which playlists have no Latin tracks?
*/

SELECt * FROM playlists WHERE PlaylistId not in (
    SELECT PlaylistId FROM playlist_track 
        JOIN tracks ON tracks.TrackId = playlist_track.TrackId
        JOIN genres ON tracks.GenreId = genres.GenreId
        WHERE genres.Name = 'Latin'