create database SQL_practice;
use SQL_practice;

CREATE TABLE patients (
    patient_id INT,
    first_name TEXT,
    last_name TEXT,
    gender CHAR(1),
    birth_date DATE,
    city TEXT,
    province_id CHAR(2),
    allergies TEXT,
    height INT,
    weight INT
);

CREATE TABLE admissions (
patient_id INT,
admission_date DATE,
discharge_date DATE,
diagnosis TEXT,
attending_doctor_id INT);

desc patients;
desc admissions;

------------------------------------------------------------------------------------------------------------------
-- Q.1 Show first name, last name, and gender of patients whose gender is 'M'
-- soln
SELECT first_name, last_name, gender
FROM patients
WHERE gender = 'M';

-- Q.2 Show first name and last name of patients who does not have allergies. (null)
-- soln
SELECT first_name, last_name
FROM patients
WHERE allergies IS NULL;

-- Q.3 Show first name of patients that start with the letter 'C'
-- soln
SELECT first_name
FROM patients
WHERE first_name LIKE 'c%';

-- Q.4 Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
-- soln
SELECT first_name,last_name
FROM patients 
WHERE weight BETWEEN 100 AND 120;

-- Q.5 Update the patients table for the allergies column.
--     If the patient's allergies is null then replace it with 'NKA'
-- soln
UPDATE patients 
SET allergies = 'NKA'
WHERE allergies IS NULL;

-- Q.6 Show first name and last name concatinated into one column to show their full name.
-- Soln
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;

-- Q.7 Show first name, last name, and the full province name of each patient. Example: 'Ontario' instead of 'ON'
-- Soln
SELECT first_name, last_name, province_name
FROM patients p
JOIN province_names n 
ON p.province_id = n.province_id;

-- Q.8 Show how many patients have a birth_date with 2010 as the birth year.
-- Soln
SELECT COUNT(*) AS total_patients
FROM patients
WHERE YEAR(birth_date) = 2010;

-- Q.9 Show the first_name, last_name, and height of the patient with the greatest height.
-- Soln
SELECT first_name,last_name,MAX(height)
from patients;

-- or
SELECT first_name, last_name, height
FROM patients
WHERE height = (
    SELECT max(height)
    FROM patients
  );

-- Q.10 Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
-- Soln
SELECT * 
FROM patients
WHERE patient_ids IN ( 1, 45, 534, 879, 1000);

-- Q.11 Show the total number of admissions
-- soln
SELECT COUNT(patient_id) 
FROM admissions;
-- or
SELECT COUNT(*) AS total_admissions
FROM admissions;

-- Q.12 Show all the columns from admissions where the patient was admitted and discharged on the same day.
-- soln
SELECT *
FROM admissions
WHERE admission_date = dischare_date;

-- Q.13 Show the patient id and the total number of admissions for patient_id 579.
-- Soln
SELECT patient_id, COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;

-- Q.14 Based on the cities that our patients live in, show unique cities that are in province_id 'NS'.
-- Soln
select distinct city from patients where province_id = 'NS';

-- Q.15 Write a query to find the first_name, last name and birth date of patients
--      who has height greater than 160 and weight greater than 70
-- Soln
SELECT first_name, last_name, birth_date
FROM patients
WHERE height > 160 AND weight > 70;

-- Q.16 Write a query to find list of patients first_name, last_name, and allergies
--      where allergies are not null and are from the city of 'Hamilton'
-- Soln
SELECT first_name, last_name, allergies
FROM patients
WHERE city = 'Hamilton' AND allergies IS NOT NULL;

-- Q.17 Show unique birth years from patients and order them by ascending.
-- Soln
SELECT DISTINCT YEAR(birth_date) as birth_year
FROM patients
ORDER BY birth_year;

-- Q.18 Show unique first names from the patients table which only occurs once in the list.
--      For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list.
--      If only 1 person is named 'Leo' then include them in the output. 
-- Soln
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;

-- Q.19 Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long
-- Soln
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's____%s';

-- Q.20 Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
--      Primary diagnosis is stored in the admissions table
-- Soln
SELECT patient_id, first_name, last_name
FROM patients p
JOIN admissions a 
ON p.patient_id = a.patient_id
WHERE diagnosis = 'Dementia';

-- Q.21 Display every patient's first_name. Order the list by the length of each name and then by alphabetically.
-- Soln
SELECT first_name
FROM patients
ORDER BY LEN(first_name) , first_name;

-- Q.22 Show the total amount of male patients and the total amount of female patients in the patients table. 
--      Display the two results in the same row.
-- Soln
SELECT 
    (SELECT COUNT(*) FROM patients WHERE gender = 'M') AS male_count,
    (SELECT COUNT(*) FROM patients WHERE gender = 'F') AS female_count;

-- Q.23 Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'.
--      Show results ordered ascending by allergies then by first_name then by last_name.
-- Soln
SELECT first_name, last_name, allergies
FROM patients
WHERE allergies IN ('Penicillin' OR 'Morphine')
ORDER BY allergies , first_name , last_name;

-- Q.24 Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
-- Soln
SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id , diagnosis
HAVING COUNT(*) > 1;

-- Q.25 Show the city and the total number of patients in the city.
--      Order from most to least patients and then by city name ascending.
-- Soln
SELECT city, COUNT(patient_id)
FROM patients
GROUP BY city
ORDER BY COUNT(patient_id) DESC , city ASC;

-- Q.26 Show first name, last name and role of every person that is either patient or doctor.The roles are either "Patient" or "Doctor"
-- Soln
SELECT first_name, last_name, 'Patient' AS Role FROM patients 
UNION ALL 
SELECT first_name, last_name, 'Doctor' AS role FROM doctors;

-- Q.27 Show all allergies ordered by popularity. Remove NULL values from query.
-- Soln
SELECT allergies, COUNT(*) AS total_diagnosis
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC;

-- Q.28 Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade.
--      Sort the list starting from the earliest birth_date.
-- Soln
SELECT first_name, last_name, birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date;

-- Q.29 We want to display each patient's full name in a single column. Their last_name in all upper letters 
--      must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma.
--      Order the list by the first_name in decending order
-- soln
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS Full_name_format
FROM patients
ORDER BY first_name DESC;

-- Q.30 Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
-- Soln
SELECT province_id, SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;

-- Q.31 Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
-- Soln
SELECT (MAX(weight) - MIN(weight)) AS difference_weight
FROM patients
WHERE last_name = 'Maroni';

-- Q.32 Show all of the days of the month (1-31) and how many admission_dates occurred on that day.
--      Sort by the day with most admissions to least admissions
-- Soln
SELECT DAY(admission_date) AS day_number,
       COUNT(*) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC; 

-- Q.33 Show all columns for patient_id 542's most recent admission_date.
-- Soln
SELECT *
FROM admissions
WHERE patient_id = 542
ORDER BY admission_date DESC
LIMIT 1;
-- or
SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING admission_date = MAX(admission_date);

-- Q.34 Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
--      1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
--      2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
-- Soln
SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
WHERE (patient_id % 2 != 0 AND attending_doctor_id IN (1 , 5, 19))
	   OR 
	  (attending_adoctor_id LIKE '%2%' AND LEN(patient_id) = 3);

-- Q.35 Show first_name, last_name, and the total number of admissions attended for each doctor.
--      Every admission has been attended by a doctor.	
-- Soln
SELECT 
    first_name,
    last_name,
    COUNT(*) AS total_number_of_admissions
FROM admissions a
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
GROUP BY doctor_id; 

-- Q.36 For each doctor, display their id, full name, and the first and last admission date they attended.
-- soln
SELECT 
    doctor_id,
    CONCAT(first_name, ' ', last_name),
    MIN(admission_date) as first_admission_date,
    MAX(admission_date) as last_admission_date
FROM doctors d
JOIN admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY doctor_id;

-- Q.37 Display the total amount of patients for each province. Order by descending.
-- soln
SELECT province_name, COUNT(*) AS patient_count
FROM province_names p
JOIN patients q 
ON p.province_id = q.province_id
GROUP BY province_name
ORDER BY patient_count DESC;

-- Q.38 For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
-- soln
SELECT
  CONCAT(patients.first_name, ' ', patients.last_name) as patient_name,
  diagnosis,
  CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
  JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;
  
 -- Q.39 display the first name, last name and number of duplicate patients based on their first name and last name.
 --      Ex: A patient with an identical name can be considered a duplicate
 -- Soln
 SELECT first_name, last_name, COUNT(*) AS num_of_duplicates
FROM patients
GROUP BY first_name , last_name
HAVING COUNT(*) > 1;

-- Q.40 height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals,
--  birth_date, gender non abbreviated. Convert CM to feet by dividing by 30.48. Convert KG to pounds by multiplying by 2.205
-- Soln
select concat(first_name," ",last_name) as full_name,
round(height/30.48,1) as height_feet,
round(weight * 2.205,0) as weights_pounds,
birth_date,
case 
    when gender ='M' then 'Male'
    else 'Female'
end as 'gender_type'
from patients;

-- Q.41 Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table.
--      (Their patient_id does not exist in any admissions.patient_id rows.)
-- Soln
SELECT patient_id, first_name, last_name
FROM patients
WHERE patient_id NOT IN (SELECT a.patient_id FROM admissions a);

-- Q.42 Display a single row with max_visits, min_visits, average_visits where the maximum, 
--      minimum and average number of admissions per day is calculated. Average is rounded to 2 decimal places.
-- Soln
SELECT 
    MAX(visits_n) AS max_visits,
    MIN(visits_n) AS min_visits,
    ROUND(AVG(visits_n), 2) AS average_visits
FROM (SELECT admission_date, COUNT(*) AS visits_n
      FROM admissions
      GROUP BY admission_date);