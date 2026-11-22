/*Question:
-What skills are required for the top paying data analyst jobs?
-I use the top 10 highest paying Data Analyst jobs from the first query.
-Then i add the specific skills required for the roles.
Why?
It provides a detailed look at which high paying jobs demand certain skills,
and helps job seekers understand which skills to develop and salary expectations 
*/




WITH top_paying_jobs AS(
    SELECT
        job_postings_fact.job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL 
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)
SELECT
-- (.*) auto selects all the columns from the above, top paying jobs
top_paying_jobs.*,
skills_dim.skills AS skill_name

FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC