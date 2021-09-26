-- murder mistery
SELECT * FROM crime_scene_report
WHERE city = 'SQL City' AND date = '2018-01-15' AND type = 'Murder' 
/*
Security footage shows that there were 2 witnesses. 
The first witness lives at the last house on "Northwestern Dr". 
The second witness, named Annabel, lives somewhere on "Franklin Ave".
*/

SELECT * FROM person
WHERE address_street_name LIKE 'Northwestern Dr'
ORDER BY address_number DESC
-- ID 14887 - Morty Schapiro
/*
I heard a gunshot and then saw a man run out. 
He had a "Get Fit Now Gym" bag. 
The membership number on the bag started with "48Z". 
Only gold members have those bags. 
The man got into a car with a plate that included "H42W".
*/

SELECT * FROM person
WHERE name LIKE 'Annabel%' and address_street_name LIKE 'Franklin Ave'
-- ID 16371 - Annabel Miller
/*
I saw the murder happen, and I recognized the killer from my 
gym when I was working out last week on January the 9th.
*/

SELECT * FROM interview
WHERE person_id IN (14887,16371)

SELECT person.id, person.name FROM get_fit_now_member 
INNER JOIN person ON get_fit_now_member.person_id = person.id
INNER JOIN drivers_license ON person.license_id = drivers_license.id
INNER JOIN get_fit_now_check_in ON get_fit_now_member.id = get_fit_now_check_in.membership_id
WHERE (get_fit_now_member.id LIKE '48Z%' AND get_fit_now_member.membership_status = 'gold'
AND drivers_license.plate_number LIKE '%H42W%') 
AND get_fit_now_check_in.check_in_date = '2018-01-09'
--UBOJICA JE Jeremy Bowers - 67318

--Traažimo interview sa 67318
SELECT * FROM interview WHERE person_id = 67318
/*I was hired by a woman with a lot of money. I don't know her name 
but I know she's around 5'5" (65") or 5'7"(67"). She has red hair and 
she drives a Tesla Model S. I know that she attended the SQL Symphony 
Concert 3 times in December 2017. */
SELECT person.id, person.name FROM person INNER JOIN drivers_license ON
person.license_id = drivers_license.id INNER JOIN facebook_event_checkin ON
person.id = facebook_event_checkin.person_id WHERE height BETWEEN 65 AND 67
AND hair_color='red' AND gender = 'female' AND car_make = 'Tesla' AND car_model = 'Model S'
AND facebook_event_checkin.event_name = 'SQL Symphony Concert' 
AND facebook_event_checkin.date BETWEEN '2017-12-01' AND '2017-12-31'
GROUP BY person.id, person.name
HAVING COUNT(*) = 3 
-- NARUCILA Miranda Priestly - 99716



