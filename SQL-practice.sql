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

-- Q.17 