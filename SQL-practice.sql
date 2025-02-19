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

desc patients;

------------------------------------------------------------------------------------------------------------------
-- Q.1 Show first name, last name, and gender of patients whose gender is 'M'
-- soln
SELECT 
    first_name, last_name, gender
FROM
    patients
WHERE
    gender = 'M';

-- Q.2 Show first name and last name of patients who does not have allergies. (null)
-- soln
SELECT 
    first_name, last_name
FROM
    patients
WHERE
    allergies IS NULL;

-- Q.3 Show first name of patients that start with the letter 'C'

select first_name from patients where first_name like 'c%';

-- Q.4 Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)