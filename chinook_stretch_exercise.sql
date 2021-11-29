/* SQL Stretch Exercise
====================================================================
We will be working with database chinook.db
You can download it here: https://drive.google.com/file/d/0Bz9_0VdXvv9bWUtqM0NBYzhKZ3c/view?usp=sharing&resourcekey=0-7zGUhDz0APEfX58SA8UKog

 The Chinook Database is about an imaginary video and music store. Each track is stored using one of the digital formats and has a genre. The store has also some playlists, where a single track can be part of several playlists. Orders are recorded for customers, but are called invoices. Every customer is assigned a support employee, and Employees report to other employees.
*/



--==================================================================
/* TASK I
How many audio tracks in total were bought by German customers? And what was the total price paid for them?
hint: use subquery to find all of tracks with their prices
*/

select count(*), sum(invoice_items.UnitPrice*invoice_items.Quantity) from invoice_items 
    JOIN invoices ON invoice_items.InvoiceId = invoices.InvoiceId AND invoices.BillingCountry = 'Germany'
    JOIN tracks ON invoice_items.TrackId =  tracks.TrackId 
    WHERE tracks.MediaTypeId in (
                                select MediaTypeId from media_types where Name like '%audio%'
                                )  
/* TASK II
What is the space, in bytes, occupied by the playlist “Grunge”, and how much would it cost?
(Assume that the cost of a playlist is the sum of the price of its constituent tracks).
*/
SELECT sum(Bytes), sum(UnitPrice) FROM playlist_track 
    JOIN playlists ON playlist_track.PlaylistId = playlists.PlaylistId AND playlists.Name = 'Grunge'
    JOIN tracks ON tracks.TrackId = playlist_track.TrackId

/* TASK III
List the names and the countries of those customers who are supported by an employee who was younger than 35 when hired. 
*/
SELECT customers.FirstName, customers.LastName, customers.Country,SupportRepId, employees.FirstName, employees.LastName FROM customers 
    JOIN employees ON customers.SupportRepId = employees.EmployeeId AND employees.HireDate - employees.BirthDate < 35 
