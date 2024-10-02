/*SQL MURDER MYSTERY 
Available information on Crime - 
Crime Type = Murder 
Crime Date = 20180115 (January 15 2018)
Crime Location = SQL City
*/
-- Given the details above, I used the below query to view the crime_scene-report table to see all the data contained in the table.  
SELECT *
FROM crime_scene_report

/*From the query above, I see that the table contains a columns titled Date, Type, Description and City. 
Using the information i have above, i go on to query the crime_scene_report using the query below to get all the 
data on the table where date is 20180115, type is Murder and City is 'SQL City"
*/
SELECT *
FROM crime_scene_report
WHERE date = 20180115 AND Type = 'murder' AND city = 'SQL City'

/*The result from the above query shows that there is a security footage showing 2 witnesses.
Witness 1 lives at the last house on "Northwestern Dr"
Witness 2 lives on "Franklin Ave". Witness 2 name is also Annabel. 
I go on to query the "person" table to see all the data in the table using the query below 
*/ 
SELECT *
FROM person

/* After running the above query, I see that the "Person" table includes columns  "name" and "address_street_name". 
Using the data gotten from the "crime_scene_report' table regarding the witnesses, I used the query below to check the "Person" 
table to see if there is any name "Annabel" on the "name" column and any address "Northwestern Dr" and 'Franklin Ave" 
on the "address_street_name" column.
*/

SELECT *
FROM person
WHERE name = 'Annabel%' and address_street_name In ('Northwestern Dr', 'Franklin Ave')

--The above query did not bring out any result so i decided to research on the witnesses one at a time. Using the query below 
--for "WITNESS 1" 
SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'

/*because there are a lot of people staying at 'Northwestern Dr', and also knowing that the witness stays at the last house, 
I then order the address_number in descending order
*/
SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC

--The above query has shown that "Morty Schapiro" stays at the last house on Northwestern Dr. Therefore, he is Witness 1. 
--Moving on the witness 2, i use the query below. 
SELECT *
FROM person
WHERE name LIKE 'Annabel' AND address_street_name = 'Franklin Ave'

-- The above query shows us that "Annabel Miller" is the second witness.
-- Next, I go ahead to query the Interview table to see the columns listed 
SELECT *
FROM interview

/* The query above shows that the interview table has only 2 columns, Person_id and transcript. 
Therefore, I will need the person Id of both witnesses. Using the query below. 
*/
SELECT name, id 
From person
WHERE name IN ('Annabel Miller', 'Morty Schapiro')

/*The above query shows that Morty Schapiro's  ID is 14887 and Annabel Miller's ID is 16371.
From the Schema, it shows that Id on the "Person" table and person_id on the "Interview" table are the same. 
with that, I will go on to query the interview table using the above query as a subquery to avoid errors from hardcoding the IDs 
to get the transcript of the IDs given in the query above
*/
SELECT *
FROM interview
JOIN person ON interview.person_id = person.ID
WHERE person_id IN (SELECT ID
                    FROM person
                    WHERE name IN ('Annabel Miller', 'Morty Schapiro'))

/*With the above query, i got the transcript of both witnesses which shows that - 
The suspect is likely a man and also a member of "get fit now" gym. He must also be a Gold member since the bag with him had
a membership number that starts with "48Z"
The suspect also has a car with a plate number that includes "H42W"
The suspect also worked out at a gym on 9th of January

With the above information, I will go ahead to view the get_fit_now_member table and then check to see the GOLD member with the
number that starts with "48Z" using the query below 
*/
SELECT *
FROM get_fit_now_member

SELECT *
FROM get_fit_now_member
WHERE membership_status = 'gold' and id LIKE '48Z%'

/*The above query brings 2 members with gold membership whose membership id starts with 48Z. 
Member 1 is Joe Germuska with membership id 48Z7A 
Member 2 is Jeremy Bowers with membership id 48Z55

Also verifying which of the above members checked in on the 9th of january using the query below 
*/

SELECT *
FROM get_fit_now_check_in
where check_in_date = 20180109 and membership_id like '48Z%'

/*Also using the information on the car plate, i will go on to view the Drivers_license table then check it for information on the car with 
plate number including "H42W" using the queries below
*/
SELECT *
FROM drivers_license

SELECT *
FROM drivers_license
WHERE plate_number LIKE '%H42W%' 
-- Since our suspect is likely a male, i will go on to add another filter for only male
SELECT *
FROM drivers_license
WHERE plate_number LIKE '%H42W%' and Gender = 'male'

/* The code above shows only 2 males with plate numbers that include "H42W'.
The drivers_license table does not include the names of the license holders only their id. 
The Schema also shows that the ID on the drivers_license table is the same as the license_id on the person table. 
Therefore, i used the below query to join both table and get names of the two males. 
*/
SELECT Name
FROM person
join drivers_license
on person.license_id = drivers_license.id
Where license_id In (select id 
                     from drivers_license
                     where plate_number LIKE '%H42W%' and Gender = 'male')

/*The above code gives the names "Tushar Chandra" and "Jeremy Bowers". This therefore eliminates "Joe Germuska" as a suspect as he 
does not have a registered car with a plate number thats includes "H42W". Therefore, we are left with "Tushar Chandra" and "Jeremy Bowers"
as suspect. To further clarify, i will go on to check if "Tushar Chandra is a member of the "Get fit now" using the query below. 
*/
SELECT name 
from get_fit_now_member
where name = 'Tushar Chandra'

/* There was no return on the above query, therefore "JEREMY BOWERS" is the MURDERER. 


