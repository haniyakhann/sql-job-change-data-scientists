-- Haniya Khan
-- SQL Final Project
-- DATA 330

SHOW TABLES;

CREATE TABLE city (
    city VARCHAR(20) PRIMARY KEY,
    city_development_index DECIMAL(4,3)
);
CREATE TABLE train (
    enrollee_id INT PRIMARY KEY,
    city VARCHAR(20),
    gender VARCHAR(20),
    relevent_experience VARCHAR(50),
    enrolled_university VARCHAR(50),
    education_level VARCHAR(50),
    major_discipline VARCHAR(50),
    experience VARCHAR(10),
    company_size VARCHAR(20),
    company_type VARCHAR(50),
    last_new_job VARCHAR(10),
    training_hours INT,
    target INT,
    FOREIGN KEY (city) REFERENCES city(city)
);
CREATE TABLE test (
    enrollee_id INT PRIMARY KEY,
    city VARCHAR(20),
    gender VARCHAR(20),
    relevent_experience VARCHAR(50),
    enrolled_university VARCHAR(50),
    education_level VARCHAR(50),
    major_discipline VARCHAR(50),
    experience VARCHAR(10),
    company_size VARCHAR(20),
    company_type VARCHAR(50),
    last_new_job VARCHAR(10),
    training_hours INT,
    FOREIGN KEY (city) REFERENCES city(city)
);
INSERT INTO city (city, city_development_index)
SELECT DISTINCT city, city_development_index
FROM aug_train;

SELECT COUNT(*) FROM city;
SELECT * FROM city LIMIT 5;

INSERT INTO train
SELECT 
    enrollee_id,
    city,
    gender,
    relevent_experience,
    enrolled_university,
    education_level,
    major_discipline,
    experience,
    company_size,
    company_type,
    last_new_job,
    training_hours,
    target
FROM aug_train;

SELECT COUNT(*) FROM train;
SELECT * FROM train LIMIT 5;

INSERT INTO test
SELECT 
    enrollee_id,
    city,
    gender,
    relevent_experience,
    enrolled_university,
    education_level,
    major_discipline,
    experience,
    company_size,
    company_type,
    last_new_job,
    training_hours
FROM aug_test;




-- Basic Questions
-- Q1: Show the first 10 rows from the train table

SELECT *
FROM train
LIMIT 10;

-- Q2: How many total enrollees are in the train dataset?
SELECT COUNT(*) AS total_enrollees
FROM train;

-- Q3: Find all enrollees from the train table who are from 'city_103'
SELECT *
FROM train
WHERE city = 'city_103';

-- Q4: List all enrollees from the test table who have 'No relevant experience'
SELECT *
FROM test
WHERE relevent_experience = 'No relevent experience';



-- Q5: Find all enrollees in the train table who have more than 100 training_hours.
SELECT *
FROM train
WHERE training_hours > 100;

-- Q6: List all unique values for education_level.
SELECT DISTINCT education_level
FROM train;

-- Q7: What is the average city_development_index for all enrollees in the train table?
SELECT AVG(city_development_index) AS avg_city_index
FROM train
JOIN city ON train.city = city.city;

-- Q8: How many enrollees in the train table are looking for a job (where target = 1)?
SELECT COUNT(*) AS job_seekers
FROM train
WHERE target = 1;

-- Q9: Find all enrollees who are 'Female' and have a 'Graduate' education_level.
SELECT *
FROM train
WHERE gender = 'Female'
  AND education_level = 'Graduate';
  
-- Q10: List the top 5 enrollees ordered by training_hours from highest to lowest.
SELECT *
FROM train
ORDER BY training_hours DESC
LIMIT 5;

-- Q11: What is the average city_development_index for each gender?

SELECT 
    gender,
    AVG(city_development_index) AS avg_city_index
FROM train
JOIN city USING (city)
GROUP BY gender;

-- Q12: How many enrollees are there for each major_discipline?

SELECT 
    major_discipline,
    COUNT(*) AS total_enrollees
FROM train
GROUP BY major_discipline;

-- Q13: What is the average training_hours for enrollees who are looking for a job (target = 1)
--      versus those who are not (target = 0)?

SELECT 
    target,
    AVG(training_hours) AS avg_training_hours
FROM train
GROUP BY target;

-- Q14: What is the job-seeking rate (AVG(target)) for enrollees 
--      with 'Relevant experience' vs. 'No relevant experience'?

SELECT 
    relevent_experience,
    AVG(target) AS job_seeking_rate
FROM train
GROUP BY relevent_experience;

-- Q15: List the top 5 cities with the highest number of enrollees.

SELECT 
    city,
    COUNT(*) AS total_enrollees
FROM train
GROUP BY city
ORDER BY total_enrollees DESC
LIMIT 5;

-- Q16: How many enrollees are there for each company_type?

SELECT 
    company_type,
    COUNT(*) AS total_enrollees
FROM train
GROUP BY company_type;

-- Q17: Find all education_level categories where the average training_hours is greater than 80.

SELECT 
    education_level,
    AVG(training_hours) AS avg_training_hours
FROM train
GROUP BY education_level
HAVING AVG(training_hours) > 80; -- none huh returns null



-- Q18: Categorize enrollees' experience into 'Junior' (0–5 years), 
--      'Mid' (6–15 years), and 'Senior' (>15 years), 
--      then count how many enrollees fall into each category.

SELECT 
    CASE
        WHEN experience IN ('fresher', '<1', '1', '2', '3', '4', '5')
            THEN 'Junior'
        WHEN experience IN ('6','7','8','9','10','11','12','13','14','15')
            THEN 'Mid'
        WHEN experience IN ('16','17','18','19','20','>20')
            THEN 'Senior'
        ELSE 'Unknown'
    END AS experience_category,
    COUNT(*) AS total_enrollees
FROM train
GROUP BY experience_category;

-- Q19: Find the city with the highest average city_development_index.

SELECT 
    city,
    AVG(city_development_index) AS avg_index
FROM city
GROUP BY city
ORDER BY avg_index DESC
LIMIT 1;

-- Q20: What is the most common last_new_job interval (e.g., '1', '>4', 'never') among enrollees?

SELECT 
    last_new_job,
    COUNT(*) AS total
FROM train
GROUP BY last_new_job
ORDER BY total DESC
LIMIT 1;

-- Q21: List all enrollees from the train table who have a target of 1 
--      and a city_development_index below 0.6.

SELECT train.*
FROM train
JOIN city ON train.city = city.city
WHERE train.target = 1
  AND city.city_development_index < 0.6;

-- Q22: How many enrollees from the train table have an enrollee_id 
--      that is also present in the test table?

SELECT COUNT(*) AS overlapping_enrollees
FROM train
JOIN test ON train.enrollee_id = test.enrollee_id;

-- Q23: What is the job-seeking rate (AVG(target)) for each company_size?

SELECT company_size, AVG(target) AS job_seeking_rate
FROM train
GROUP BY company_size;

-- Q24: Find all enrollees in the train table who have an education_level of 'Masters' 
--      but no major_discipline listed (major_discipline IS NULL).

SELECT *
FROM train
WHERE education_level = 'Masters'
  AND major_discipline IS NULL;   -- none huh returns null
  
  -- Q25: How many total unique enrollees are there across both the train and test tables?

SELECT COUNT(DISTINCT enrollee_id) AS total_unique_enrollees
FROM (
    SELECT enrollee_id FROM train
    UNION
    SELECT enrollee_id FROM test
) AS all_enrollees;

-- Q26: Rank enrollees within each city based on their training_hours.

SELECT
    enrollee_id,
    city,
    training_hours,
    RANK() OVER (PARTITION BY city ORDER BY training_hours DESC) AS rank_in_city
FROM train;


-- Q27: Combine train and test, then find overall average city_development_index.

WITH combined AS (
    SELECT city FROM train
    UNION ALL
    SELECT city FROM test
)
SELECT AVG(c.city_development_index) AS overall_average
FROM combined cb
JOIN city c ON cb.city = c.city;


-- Q28: Show training_hours and the average for their education_level.

SELECT
    enrollee_id,
    education_level,
    training_hours,
    AVG(training_hours) OVER (PARTITION BY education_level) AS avg_for_level
FROM train;


-- Q29: Using a CTE, find the major_discipline with the highest job-seeking rate

WITH discipline_rates AS (
    SELECT 
        major_discipline,
        AVG(target) AS job_seeking_rate
    FROM train
    GROUP BY major_discipline
)
SELECT 
    major_discipline,
    job_seeking_rate
FROM discipline_rates
ORDER BY job_seeking_rate DESC
LIMIT 1;


-- Q30: Find enrollees whose training_hours is greater than their city's average.

SELECT *
FROM train outer_train
WHERE outer_train.training_hours > (
    SELECT AVG(training_hours)
    FROM train
    WHERE train.city = outer_train.city
);


-- Q31: Find the top 3 enrollees with the highest training_hours for each major_discipline.

SELECT
    enrollee_id,
    major_discipline,
    training_hours,
    rn AS rank_in_major
FROM (
    SELECT 
        enrollee_id,
        major_discipline,
        training_hours,
        ROW_NUMBER() OVER (
            PARTITION BY major_discipline
            ORDER BY training_hours DESC
        ) AS rn
    FROM train
) AS ranked
WHERE rn <= 3;

-- Q32: Calculate job-seeking rate for experience brackets.

SELECT
    CASE
        WHEN experience IN ('fresher','<1','1') THEN '0-1'
        WHEN experience IN ('2','3','4','5') THEN '2-5'
        WHEN experience IN ('6','7','8','9','10') THEN '6-10'
        WHEN experience IN ('11','12','13','14','15','16','17','18','19') THEN '11-19'
        WHEN experience IN ('20','>20') THEN '20+'
        ELSE 'Unknown'
    END AS experience_bracket,
    AVG(target) AS job_seeking_rate
FROM train
GROUP BY experience_bracket;


-- Q33: Calculate the PERCENT_RANK() for each enrollee based on their training_hours.

SELECT
    t1.enrollee_id,
    t1.training_hours,
    (
        (SELECT COUNT(*)
         FROM train t2
         WHERE t2.training_hours < t1.training_hours
        ) * 1.0
        /
        (
            (SELECT COUNT(*) FROM train) - 1
        )
    ) AS `percent_rank`
FROM train t1;


-- Q34: Return all enrollees from both train and test with dataset flag and target (NULL for test).

SELECT
    enrollee_id,
    city,
    gender,
    relevent_experience,
    enrolled_university,
    education_level,
    major_discipline,
    experience,
    company_size,
    company_type,
    last_new_job,
    training_hours,
    'train' AS dataset,
    target
FROM train

UNION ALL

SELECT
    enrollee_id,
    city,
    gender,
    relevent_experience,
    enrolled_university,
    education_level,
    major_discipline,
    experience,
    company_size,
    company_type,
    last_new_job,
    training_hours,
    'test' AS dataset,
    NULL AS target
FROM test;


-- Q35: Calculate accuracy of predictions in submission vs train.

SELECT
    COUNT(*) AS total_predictions,
    SUM(CASE WHEN train.target = ss.target THEN 1 ELSE 0 END) AS correct_predictions,
    SUM(CASE WHEN train.target = ss.target THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS accuracy
FROM train
JOIN sample_submission ss
    ON train.enrollee_id = ss.enrollee_id;

    
-- Q36: For each enrollee, difference between their CDI and the median CDI for their enrolled_university.

WITH cdi_values AS (
    SELECT
        t.enrolled_university,
        c.city_development_index,
        ROW_NUMBER() OVER (
            PARTITION BY t.enrolled_university
            ORDER BY c.city_development_index
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY t.enrolled_university
        ) AS cnt
    FROM train t
    JOIN city c
        ON t.city = c.city
),
median_cdi AS (

    SELECT
        enrolled_university,
        AVG(city_development_index) AS median_cdi
    FROM cdi_values
    WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2))
    GROUP BY enrolled_university
)
SELECT
    t.enrollee_id,
    t.enrolled_university,
    c.city_development_index,
    m.median_cdi,
    c.city_development_index - m.median_cdi AS diff_from_median
FROM train t
JOIN city c
    ON t.city = c.city
JOIN median_cdi m
    ON t.enrolled_university = m.enrolled_university;

-- Q37: Company_type with lowest job-seeking rate for 'No relevent experience'.

SELECT
    company_type,
    AVG(target) AS job_seeking_rate
FROM train
WHERE relevent_experience = 'No relevent experience'
GROUP BY company_type
ORDER BY job_seeking_rate ASC
LIMIT 1;

-- Q38: For each city, find the gender with the highest average training_hours.

WITH avg_hours AS (
    SELECT
        city,
        gender,
        AVG(training_hours) AS avg_training_hours,
        ROW_NUMBER() OVER (
            PARTITION BY city
            ORDER BY AVG(training_hours) DESC
        ) AS rn
    FROM train
    GROUP BY city, gender
)
SELECT
    city,
    gender,
    avg_training_hours
FROM avg_hours
WHERE rn = 1;

-- Q39: Identify "at-risk" enrollees.

WITH overall_cdi AS (
    SELECT
        AVG(c.city_development_index) AS overall_avg_cdi
    FROM train t
    JOIN city c
        ON t.city = c.city
)
SELECT
    t.*
FROM train t
JOIN city c
    ON t.city = c.city
CROSS JOIN overall_cdi o
WHERE t.target = 1
  AND t.relevent_experience = 'Has relevent experience'
  AND t.education_level IN ('High School', 'Primary School', 'No formal education')
  AND c.city_development_index < o.overall_avg_cdi;


-- Q40: Total enrollees + job-seeking rate for those who have never had a job.

SELECT
    COUNT(*) AS total_enrollees_never_had_job,
    AVG(target) AS job_seeking_rate_never_had_job
FROM train
WHERE experience = '<1'
   OR last_new_job = 'never';


-- Q41 (Basic): How many enrollees in the train table have no major_discipline listed (NULL)?

SELECT COUNT(*) AS enrollees_without_major
FROM train
WHERE major_discipline IS NULL;

-- Q42 (Intermediate): What is the average training_hours for each gender
--                     among enrollees who are looking for a job (target = 1)?

SELECT
    gender,
    AVG(training_hours) AS avg_training_hours
FROM train
WHERE target = 1
GROUP BY gender;

-- Q43 (Intermediate): For each education_level, how many enrollees have 'No relevent experience'?

SELECT
    education_level,
    COUNT(*) AS total_no_relevant_experience
FROM train
WHERE relevent_experience = 'No relevent experience'
GROUP BY education_level;

-- Q44 (Intermediate): Which city has the highest number of job seekers (target = 1)?

SELECT
    city,
    COUNT(*) AS total_job_seekers
FROM train
WHERE target = 1
GROUP BY city
ORDER BY total_job_seekers DESC
LIMIT 1;

-- Q45 (Advanced): Compare job-seeking rates for low vs high development cities.
--                 'Low development' = city_development_index < 0.7
--                 'High development' = city_development_index >= 0.7

SELECT
    CASE
        WHEN city.city_development_index < 0.7 THEN 'Low development'
        ELSE 'High development'
    END AS development_group,
    AVG(train.target) AS job_seeking_rate
FROM train
JOIN city
    ON train.city = city.city
GROUP BY development_group;


