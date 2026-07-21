# Dataset Info

**Source:** Kaggle — [Data Analyst Jobs](https://www.kaggle.com/datasets/andrewmvd/data-analyst-jobs) by andrewmvd

**Rows:** 2,252 job postings

**Columns:** 27, including:
- Job Title, Salary Estimate, Job Description, Rating
- Company Name, Location, Headquarters, Size, Founded
- Type of ownership, Industry, Sector, Revenue, Competitors
- Salary_minimum, Salary_maximum, Salary_average
- Skill flags: python_job, sql_job, excel_job, tableau_job, power_bi_job, sas_job, aws_job
- City, State

**Preparation:**
Raw data was cleaned using Python (handling missing values, splitting Location into City/State, creating binary skill flag columns from the Job Description text) before being loaded into MySQL for SQL analysis.

The original CSV is not included in this repo due to size/licensing — download it directly from the Kaggle link above if you want to reproduce the analysis.
