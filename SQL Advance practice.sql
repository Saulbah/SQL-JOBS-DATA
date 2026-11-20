/* subqueries.  i want to find jobs titles that have certain skills in them,
first, we find the speciific skill from the skill_dim table, connect it with the skills_job_dim vid the skill_id.

then displaying the job id, and the job_title_short, we connect to the skill_job_dim table.

Finally displaying the job title short with the skills required
*/

SELECT
    job_id,
    job_title_short
FROM
    job_postings_fact
WHERE
    job_id IN (       
       
        SELECT
            job_id
        FROM
        skills_job_dim
        WHERE
        skill_id IN(
                SELECT skill_id
                FROM skills_dim
                where skills IN ('Pythin','sql','Exel')
        )
    )

/* Now, we want to find companies with the total number of jobs that they advertise.        
1st, we find the job postings count, relating it with company_id

then using a CTE, we get the company names as well
*/

WITH company_job_count AS(
        SELECT
            company_id,
            COUNT(*) AS Job_count
        FROM
            job_postings_fact
        GROUP BY
            company_id
)

SELECT
   name,
    Job_count
FROM
    company_dim
LEFT JOIN company_job_count ON company_dim.company_id = company_job_count.company_id


/* I will add some notes
*/

WITH remote_job_skills AS(
        SELECT
            skills_job_dim.skill_id,
            COUNT(*) AS skill_count
        FROM
            skills_job_dim
        LEFT JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
        WHERE
            job_work_from_home = TRUE 
         
        GROUP BY
            skill_id
)
SELECT
    remote_job_skills.skill_id,
    skills_dim.skills as skill_name,
    skill_count

FROM
    remote_job_skills
INNER JOIN skills_dim ON skills_dim.skill_id = remote_job_skills.skill_id

-- HERE WAS JUST A REPEAT OF WHAT WAS DONE

WITH total_skill_count AS(
        SELECT
            skills_job_dim.skill_id,
            COUNT(*) AS Skill_count
        FROM
            skills_job_dim 
        INNER JOIN job_postings_fact ON job_postings_fact.job_id = skillS_job_dim.skill_id
        WHERE
            job_work_from_home = TRUE 
        GROUP BY 
            skill_id
)
SELECT
    total_skill_count.skill_id,
    skills_dim.skills AS skill_name,
    Skill_count

FROM
    total_skill_count
INNER JOIN skills_dim ON skills_dim.skill_id = total_skill_count.skill_id
ORDER BY skill_count DESC
LIMIT 5


/* UNNIONS to join Jan, Feb and March tables
first, do the union ll
second a new SELECT, FROM(ALL THE FIRST STEP), DEFINE YOUR WHERE 
For SELECT, WHAT DO YOU WANT TO SHOW*/
SELECT
quarter1_job_postings.job_title_short,
quarter1_job_postings.job_location,
quarter1_job_postings.job_via,
quarter1_job_postings.job_posted_date::DATE,
quarter1_job_postings.salary_year_avg
FROM(  
    SELECT*
    FROM january_jobs
    UNION ALL
    SELECT*
    FROM february_jobs
    UNION ALL
    SELECT*
    FROM march_jobs
)   AS quarter1_job_postings
WHERE
quarter1_job_postings.salary_year_avg > 70000
    