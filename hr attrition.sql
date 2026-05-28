-- CREATE OUR DATABASE
create database hr_attrition;

use hr_attrition;

-- IMPORT OUR TABLES USING TABLE DATA IMPORT WIZARD

-- CONFURMING OUR DATA AFTER IMPORT
SELECT 
    *
FROM
    employee;
    
SELECT 
    *
FROM
    employment;

SELECT 
    *
FROM
    compensation;

-- CLEANING AND TRAMSFORMING OUR DATASET
UPDATE employee 
SET 
    MaritalStatus = TRIM(MaritalStatus);
    
UPDATE employee 
SET 
    department = TRIM(department);
    
UPDATE employee 
SET 
    gender = CASE
        WHEN gender = 'M' THEN 'Male'
        WHEN gender = 'MALE' THEN 'Male'
        WHEN gender = 'male' THEN 'Male'
        WHEN gender = 'F' THEN 'Female'
        WHEN gender = 'FEMALE' THEN 'Female'
        WHEN gender = 'female' THEN 'Female'
        ELSE gender
    END;
    
UPDATE employee 
SET 
    MaritalStatus = CASE
        WHEN MaritalStatus = 'M' THEN 'Married'
        WHEN MaritalStatus = 'married' THEN 'Married'
        WHEN MaritalStatus = 'MARRIED' THEN 'Married'
        WHEN MaritalStatus = 'W' THEN 'Widowed'
        WHEN MaritalStatus = 'widowed' THEN 'Widowed'
        WHEN MaritalStatus = 'WIDOWED' THEN 'Widowed'
        WHEN MaritalStatus = 'S' THEN 'Single'
        WHEN MaritalStatus = 'SINGLE' THEN 'Single'
        WHEN MaritalStatus = 'single' THEN 'Single'
        WHEN MaritalStatus = 'D' THEN 'Divorced'
        WHEN MaritalStatus = 'DIVORCED' THEN 'Divorced'
        WHEN MaritalStatus = 'divorced' THEN 'Divorced'
        ELSE MaritalStatus
    END;


SELECT 
    CONCAT(firstname, ' ', lastname) AS full_name
FROM
    employee;

alter table employee add column fullname varchar (50);


UPDATE employee 
SET 
    fullname = CONCAT(firstname, ' ', lastname);

alter table employee drop firstname, drop lastname;

alter table employee modify fullname varchar(50) after employeeid;

UPDATE employee 
SET 
    department = CASE
        WHEN department = 'Hr' THEN 'HR'
        WHEN department = 'hr' THEN 'HR'
        WHEN department = 'Slaes' THEN 'Sales'
        WHEN department = 'Marketng' THEN 'Marketing'
		WHEN department = 'Maeketing' THEN 'Marketing'
        WHEN department = 'Operatoins' THEN 'Operations'
        WHEN department = 'engineering' THEN 'Engineering'
        WHEN department = 'sales' THEN 'Sales'
        WHEN department = 'Fianance' THEN 'Finance'
        WHEN department = 'finance' THEN 'Finance'
		WHEN department = 'fianance' THEN 'Finance'
        WHEN department = 'operations' THEN 'Operations'
        WHEN department = 'H R' THEN 'HR'
        WHEN department = 'SALES' THEN 'Sales'
        WHEN department = 'Enginering' THEN 'Engineering'
        ELSE department
    END;
    
UPDATE employee 
SET 
    jobrole = CASE
        WHEN jobrole = 'Jr. Analyst' THEN 'Junior Aanlyst'
        WHEN jobrole = 'Sr. Analyst' THEN 'Senior Aanlyst'
        when jobrole = 'Senior Aanlyst' then 'Senior Analyst'
        WHEN jobrole = 'associate' THEN 'Associate'
        WHEN jobrole = 'Manageer' THEN 'Manager'
		WHEN jobrole = 'director' THEN 'Director'
        WHEN jobrole = 'Direcor' THEN 'Director'
        WHEN jobrole = 'manager' THEN 'Manager'
        WHEN jobrole = 'Junor Analyst' THEN 'Junior Analyst'
        WHEN jobrole = 'Senoir Analyst' THEN 'Senior Analyst'
        WHEN jobrole = 'Assoicate' THEN 'Associate'
		WHEN jobrole = 'specialist' THEN 'Specialist'
        WHEN jobrole = 'Specialst' THEN 'Specialist'
        when jobrole = 'Junior Aanlyst' then 'Junior Analyst'
        ELSE jobrole
    END;


SELECT 
    DateOfBirth,
    CASE
        WHEN DateOfBirth REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$' THEN 'YYYY/MM/DD'
        WHEN DateOfBirth REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}$' THEN 'DD-Mon-YYYY'
        WHEN DateOfBirth REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN 'MM-DD-YYYY'
        WHEN DateOfBirth REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN 'DD/MM/YYYY or MM/DD/YYYY'
        ELSE 'Unknown'
    END AS detected_format,
    COUNT(*) AS count
FROM
    employee
GROUP BY detected_format , DateOfBirth
ORDER BY detected_format;

ALTER TABLE employee
ADD COLUMN DateOfBirth_Clean DATE;

SELECT 
    DateOfBirth,
    SUBSTRING(DateOfBirth, 1, 2) + 0 AS first_num,
    SUBSTRING(DateOfBirth, 4, 2) + 0 AS middle_num,
    CASE
        WHEN SUBSTRING(DateOfBirth, 4, 2) + 0 > 12 THEN 'MM/DD/YYYY'
        WHEN SUBSTRING(DateOfBirth, 1, 2) + 0 > 12 THEN 'DD/MM/YYYY'
        ELSE 'Ambiguous - defaulting DD/MM/YYYY'
    END AS detected
FROM
    employee
WHERE
    DateOfBirth REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
LIMIT 20;

UPDATE employee 
SET 
    DateOfBirth_Clean = CASE
        WHEN DateOfBirth REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$' THEN STR_TO_DATE(DateOfBirth, '%Y/%m/%d')
        WHEN DateOfBirth REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}$' THEN STR_TO_DATE(DateOfBirth, '%d-%b-%Y')
        WHEN DateOfBirth REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(DateOfBirth, '%m-%d-%Y')
        WHEN
            DateOfBirth REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
                AND SUBSTRING(DateOfBirth, 4, 2) + 0 > 12
        THEN
            STR_TO_DATE(DateOfBirth, '%m/%d/%Y')
        WHEN
            DateOfBirth REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
                AND SUBSTRING(DateOfBirth, 1, 2) + 0 > 12
        THEN
            STR_TO_DATE(DateOfBirth, '%d/%m/%Y')
        WHEN DateOfBirth REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(DateOfBirth, '%d/%m/%Y')
        ELSE NULL
    END;
    
alter table employee drop column dateofbirth;
alter table employee rename column dateofbirth_clean to DOB;
alter table employee add column Age int;
alter table employee add column AgeGroup varchar(20);

UPDATE employee 
SET 
    age = TIMESTAMPDIFF(YEAR, dob, CURDATE());
    
UPDATE employee 
SET 
    agegroup = CASE
        WHEN age < 30 THEN 'Young'
        WHEN age <= 45 THEN 'Middle Aged'
        WHEN age > 44 THEN 'Old'
        ELSE age
    END;
    
-- CLEANING TABLE 2 EMPLOYMENT

UPDATE employment 
SET 
    OverTime = CASE
        WHEN LOWER(TRIM(OverTime)) IN ('yes' , 'y', '1') THEN 'Yes'
        WHEN LOWER(TRIM(OverTime)) IN ('no' , 'n', '0') THEN 'No'
        ELSE OverTime
    END;

-- CLEANING TABLE 3 COMPENSATION

select count(attrition) from compensation where Attrition = '1';
SELECT Attrition, count(*) FROM compensation group by Attrition;

UPDATE compensation 
SET 
    Attrition = CASE
        WHEN LOWER(TRIM(Attrition)) IN ('yes' , 'y', '1') THEN 'Yes'
        WHEN LOWER(TRIM(Attrition)) IN ('no' , 'n', '0') THEN 'No'
        ELSE Attrition
    END;
    
    
UPDATE compensation 
SET 
    jobsatisfaction = NULL
WHERE
    jobsatisfaction NOT BETWEEN 1 AND 4;
    
alter table compensation add column satisfactionlevel varchar(20);

alter table compensation add column balancelevel varchar(20);

UPDATE compensation 
SET 
    satisfactionlevel = CASE
        WHEN JobSatisfaction = 1 THEN 'Unhappy'
        WHEN JobSatisfaction = 2 THEN 'Neutral'
        WHEN JobSatisfaction = 3 THEN 'Happy'
        WHEN JobSatisfaction = 4 THEN 'Very Happy'
        ELSE JobSatisfaction
    END;

UPDATE compensation 
SET 
    balancelevel = CASE
        WHEN WorkLifeBalance = 1 THEN 'Burned Out'
        WHEN WorkLifeBalance = 2 THEN 'Moderate'
        WHEN WorkLifeBalance = 3 THEN 'Healthy'
        ELSE WorkLifeBalance
    END;

alter table compensation modify column balancelevel varchar(20) after worklifebalance;

alter table compensation modify column satisfactionlevel varchar(20) after jobsatisfaction;

-- CORRECTING AN ERROR I NONTICED ON THE VISUALS

UPDATE employee 
SET 
    maritalstatus = CASE
        WHEN maritalstatus = 'Divorcedd' THEN 'Divorced'
        WHEN maritalstatus = 'Marriied' THEN 'Married'
        WHEN maritalstatus = 'Sinlge' THEN 'Single'
        ELSE maritalstatus
    END;





















