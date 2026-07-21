USE job_market_db;

-- ============================================
-- BASIC QUERIES
-- ============================================

-- 1. Total number of job postings
SELECT COUNT(*) AS total_jobs FROM jobs;

-- 2. Average salary overall
SELECT ROUND(AVG(Salary_average), 0) AS avg_salary FROM jobs;

-- 3. Highest paying jobs
SELECT `Job Title`, `Company Name`, Salary_average
FROM jobs
ORDER BY Salary_average DESC
LIMIT 10;

-- 4. Number of jobs per sector
SELECT Sector, COUNT(*) AS job_count
FROM jobs
GROUP BY Sector
ORDER BY job_count DESC;

-- 5. Average salary by state
SELECT State, ROUND(AVG(Salary_average), 0) AS avg_salary
FROM jobs
GROUP BY State
ORDER BY avg_salary DESC;

-- 6. Number of jobs requiring each skill
SELECT 
    SUM(python_job) AS python_jobs,
    SUM(sql_job) AS sql_jobs,
    SUM(excel_job) AS excel_jobs,
    SUM(tableau_job) AS tableau_jobs,
    SUM(power_bi_job) AS powerbi_jobs,
    SUM(sas_job) AS sas_jobs,
    SUM(aws_job) AS aws_jobs
FROM jobs;

-- ============================================
-- DATA CLEANING FIX (applied before further analysis)
-- ============================================

-- Found 8 rows where City and State were concatenated together
-- (e.g., State = 'Arapahoe, CO' instead of 'CO')
-- Fixed by extracting just the text after the last comma:
UPDATE jobs
SET State = TRIM(SUBSTRING_INDEX(State, ',', -1))
WHERE State LIKE '%,%';

-- ============================================
-- INTERMEDIATE QUERIES
-- ============================================

-- 7. Sectors with more than 20 job postings (NULL sector excluded)
SELECT Sector, COUNT(*) AS job_count
FROM jobs
WHERE Sector IS NOT NULL
GROUP BY Sector
HAVING COUNT(*) > 20
ORDER BY job_count DESC;

-- 8. Average salary by company size, only where rating is known
SELECT Size, ROUND(AVG(Salary_average), 0) AS avg_salary, ROUND(AVG(Rating), 2) AS avg_rating
FROM jobs
WHERE Rating IS NOT NULL
GROUP BY Size
ORDER BY avg_salary DESC;

-- 9. Categorize jobs into salary bands using CASE
SELECT 
    `Job Title`,
    Salary_average,
    CASE 
        WHEN Salary_average < 60000 THEN 'Low'
        WHEN Salary_average BETWEEN 60000 AND 100000 THEN 'Medium'
        ELSE 'High'
    END AS salary_band
FROM jobs;

-- 10. Top 5 cities with the most job postings
SELECT City, COUNT(*) AS job_count
FROM jobs
GROUP BY City
ORDER BY job_count DESC
LIMIT 5;

-- 11. Companies with above-average salary
SELECT `Company Name`, Salary_average
FROM jobs
WHERE Salary_average > (SELECT AVG(Salary_average) FROM jobs)
ORDER BY Salary_average DESC;

-- ============================================
-- ADVANCED QUERIES (window function, CTE, correlated subquery)
-- ============================================

-- 12. Rank companies by salary within each sector (window function)
SELECT 
    Sector,
    `Company Name`,
    Salary_average,
    RANK() OVER (PARTITION BY Sector ORDER BY Salary_average DESC) AS salary_rank
FROM jobs
WHERE Sector IS NOT NULL
ORDER BY Sector, salary_rank;

-- 13. Average salary per skill (CTE)
WITH skill_summary AS (
    SELECT 'Python' AS skill, AVG(Salary_average) AS avg_salary FROM jobs WHERE python_job = 1
    UNION ALL
    SELECT 'SQL', AVG(Salary_average) FROM jobs WHERE sql_job = 1
    UNION ALL
    SELECT 'Excel', AVG(Salary_average) FROM jobs WHERE excel_job = 1
    UNION ALL
    SELECT 'Power BI', AVG(Salary_average) FROM jobs WHERE power_bi_job = 1
)
SELECT skill, ROUND(avg_salary, 0) AS avg_salary
FROM skill_summary
ORDER BY avg_salary DESC;

-- 14. Companies paying above their own sector's average (correlated subquery)
SELECT `Company Name`, Sector, Salary_average
FROM jobs jp
WHERE Sector IS NOT NULL
AND Salary_average > (
    SELECT AVG(Salary_average) FROM jobs WHERE Sector = jp.Sector
)
ORDER BY Sector, Salary_average DESC;

-- ============================================
-- ADDITIONAL QUERIES (business question deep-dives)
-- ============================================

-- 15. Skill demand vs skill pay side-by-side
SELECT 
    'Python' AS skill, SUM(python_job) AS demand, ROUND(AVG(CASE WHEN python_job=1 THEN Salary_average END),0) AS avg_salary
FROM jobs
UNION ALL
SELECT 'SQL', SUM(sql_job), ROUND(AVG(CASE WHEN sql_job=1 THEN Salary_average END),0) FROM jobs
UNION ALL
SELECT 'Excel', SUM(excel_job), ROUND(AVG(CASE WHEN excel_job=1 THEN Salary_average END),0) FROM jobs
UNION ALL
SELECT 'Tableau', SUM(tableau_job), ROUND(AVG(CASE WHEN tableau_job=1 THEN Salary_average END),0) FROM jobs
UNION ALL
SELECT 'Power BI', SUM(power_bi_job), ROUND(AVG(CASE WHEN power_bi_job=1 THEN Salary_average END),0) FROM jobs
UNION ALL
SELECT 'SAS', SUM(sas_job), ROUND(AVG(CASE WHEN sas_job=1 THEN Salary_average END),0) FROM jobs
UNION ALL
SELECT 'AWS', SUM(aws_job), ROUND(AVG(CASE WHEN aws_job=1 THEN Salary_average END),0) FROM jobs;

-- 16. Python + SQL combo vs individual skills
SELECT 
    CASE 
        WHEN python_job=1 AND sql_job=1 THEN 'Python + SQL'
        WHEN python_job=1 AND sql_job=0 THEN 'Python only'
        WHEN python_job=0 AND sql_job=1 THEN 'SQL only'
        ELSE 'Neither'
    END AS skill_combo,
    COUNT(*) AS job_count,
    ROUND(AVG(Salary_average),0) AS avg_salary
FROM jobs
GROUP BY skill_combo
ORDER BY avg_salary DESC;

-- 17. Volume vs pay by state
SELECT State, COUNT(*) AS job_count, ROUND(AVG(Salary_average),0) AS avg_salary
FROM jobs
GROUP BY State
ORDER BY job_count DESC;

-- 18. AWS concentration by state
SELECT State, SUM(aws_job) AS aws_job_count, COUNT(*) AS total_jobs,
       ROUND(SUM(aws_job) * 100.0 / COUNT(*), 1) AS aws_percentage
FROM jobs
GROUP BY State
HAVING COUNT(*) > 10
ORDER BY aws_percentage DESC;

-- 19. Rating band vs salary
SELECT 
    CASE 
        WHEN Rating >= 4.0 THEN 'High Rated (4+)'
        WHEN Rating BETWEEN 3.0 AND 3.9 THEN 'Mid Rated (3-3.9)'
        ELSE 'Low Rated (<3)'
    END AS rating_band,
    COUNT(*) AS company_count,
    ROUND(AVG(Salary_average),0) AS avg_salary
FROM jobs
WHERE Rating IS NOT NULL
GROUP BY rating_band
ORDER BY avg_salary DESC;

-- 20. Best sector by pay + rating
SELECT Sector, ROUND(AVG(Salary_average),0) AS avg_salary, ROUND(AVG(Rating),2) AS avg_rating, COUNT(*) AS job_count
FROM jobs
WHERE Sector IS NOT NULL AND Rating IS NOT NULL
GROUP BY Sector
HAVING COUNT(*) >= 15
ORDER BY avg_salary DESC;

-- 21. Ownership type comparison
SELECT `Type of ownership`, COUNT(*) AS job_count, ROUND(AVG(Salary_average),0) AS avg_salary
FROM jobs
GROUP BY `Type of ownership`
ORDER BY avg_salary DESC;
