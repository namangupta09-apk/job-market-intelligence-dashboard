# Job Market Intelligence Dashboard

## About this project
This project analyzes 2,252 real data analyst job postings to answer three practical questions:
1. Which skills actually pay off?
2. Where should someone look for jobs?
3. What does a "good" employer look like?

The workflow: raw data → cleaned in Python → loaded into MySQL → analyzed with SQL → visualized in Power BI.

---

## Data Limitations
A few data quality issues were found and handled during analysis, instead of being ignored:

- **Salary cap at 150,000:** 29 postings (1.3%) show salary as exactly 150,000. This is likely because the original listings were reported as an open-ended range (e.g., "150K+") and got stored as a flat number. These values are treated as an approximate ceiling, not an exact salary.
- **Missing sector data:** 353 postings (15.7%) had no sector listed. These were excluded from all sector-based analysis to avoid misleading results.
- **City/State data entry error:** 8 rows had city and state concatenated together in the State field (e.g., "Arapahoe, CO" instead of just "CO"). This was found and corrected before running state-level analysis.

---

## Q1: Which skills actually pay off?

**SQL and Excel are needed the most, but they don't pay the most.**
SQL appears in 1,388 job postings and Excel in 1,353 — far more than any other skill. But neither has the highest average salary. Python has the highest average salary (74,734) despite appearing in only 637 postings.

**Tableau pays more than expected for how rarely it's asked for.**
Tableau appears in only 620 postings but has one of the highest average salaries (74,244), close to Python. Power BI, despite being a commonly recommended tool to learn, has the lowest average salary among the compared skills (69,844).

**Python alone pays more than SQL alone.**
Jobs asking for Python only (no SQL) have the highest average salary (78,072), even though there are very few such jobs (76). Jobs asking for SQL only pay the least (70,111) despite being the most common combination (827 jobs). So having Python as a specific skill seems to add more value than SQL by itself, even though SQL is asked for more often.

---

## Q2: Where should someone look for jobs?

**California leads in both job count and pay.**
California has both the most job postings (626) and the highest average salary (88,432) — about 22% above the overall average of 72,123. It's a strong choice on both fronts.

**More jobs in a state doesn't mean better pay.**
Texas has the second-highest number of postings (394) but a much lower average salary (58,751), well below the national average.

**New York has the most job postings by city.**
New York alone has 310 postings, more than double the next city, Chicago (130). Job postings are heavily concentrated in a few major cities rather than spread evenly.

**AWS demand is concentrated in smaller markets.**
Utah has the highest percentage of AWS-related postings (45.5% of its jobs need AWS), despite having only 33 total postings. California, despite having the most jobs overall, has a much lower AWS percentage (12.6%).

---

## Q3: What does a "good" employer look like?

**Bigger companies don't pay more.**
Companies with 10,000+ employees have the lowest average salary among size categories (69,957), while mid-sized companies (5,001–10,000 employees) pay the most (74,201). Company size alone doesn't decide salary.

**Higher-rated companies pay a bit more, but not by much.**
Companies rated 4+ have an average salary of 73,954, compared to 69,255 for companies rated below 3 — a difference of about 4,700. Rating and pay are related, but only loosely.

**Biotech & Pharmaceuticals pays the most among sectors with reliable data.**
Biotech & Pharmaceuticals has the highest average salary (83,106), though it has only 33 postings. Information Technology offers a strong overall combination: solid pay (74,302), a high average rating (3.98), and by far the most postings (558) — making it the safest strong choice.

**Private companies offer the most opportunities.**
"Company - Private" has by far the most job postings (1,272), with a solid average salary (72,500) close to the overall average. Hospitals pay the most (81,711) but have very few openings (19). Private companies are the safer bet for volume; hospitals for pay, if you can find an opening.

**Pay differs even within the same company.**
Ranking companies by salary within their sector shows that pay isn't uniform even within one employer. For example, Lorven Technologies appears at five different salary levels within the Accounting & Legal sector alone — meaning the specific role matters more than just which company is hiring.

---

## SQL Techniques Used
- Basic: `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, aggregate functions (`COUNT`, `AVG`, `SUM`)
- Intermediate: `HAVING`, `CASE` statements, simple subqueries
- Advanced: one `CTE`, one `RANK() OVER (PARTITION BY ...)` window function, one correlated subquery

21 queries total, organized around the three questions above.

---

## Tools Used
- **Python** — data cleaning
- **MySQL** — data storage and SQL analysis
- **Power BI** — dashboard and visualization *(in progress)*

---

## Next Steps
- Build a 3-page Power BI dashboard, one page per question (Skills, Location, Employer Quality)
- Add DAX measures for salary premium by skill
- Publish dashboard screenshots and a LinkedIn post summarizing key findings
