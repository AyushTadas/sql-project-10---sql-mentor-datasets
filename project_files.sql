-- SQL Mini Project  
-- SQL Mentor User Performance  

-- DROP TABLE user_submissions;  

CREATE TABLE user_submissions (  
    id SERIAL PRIMARY KEY,  
    user_id BIGINT,  
    question_id INT,  
    points INT,  
    submitted_at TIMESTAMP,  
    username VARCHAR(50)  
);  

-- Q1: List all distinct users and their stats (return user_name, total_submissions, points earned)  
SELECT  
    username,  
    COUNT(*) AS total_submissions,  
    SUM(points) AS points_earned  
FROM user_submissions  
GROUP BY username  
ORDER BY total_submissions DESC;  

-- Q2: Calculate the daily average points for each user.  
SELECT  
    DATE_FORMAT(submitted_at, '%d-%m') AS day,  
    username,  
    AVG(points) AS daily_avg_points  
FROM user_submissions  
GROUP BY day, username  
ORDER BY username;  

-- Q3: Find the top 3 users with the most correct submissions for each day.  
WITH daily_submissions AS (  
    SELECT  
        DATE_FORMAT(submitted_at, '%d-%m') AS daily,  
        username,  
        SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions  
    FROM user_submissions  
    GROUP BY daily, username  
),  
users_rank AS (  
    SELECT  
        daily,  
        username,  
        correct_submissions,  
        DENSE_RANK() OVER(PARTITION BY daily ORDER BY correct_submissions DESC) AS rank  
    FROM daily_submissions  
)  
SELECT  
    daily,  
    username,  
    correct_submissions  
FROM users_rank  
WHERE rank <= 3;  

-- Q4: Find the top 5 users with the highest number of incorrect submissions.  
SELECT  
    username,  
    SUM(CASE WHEN points < 0 THEN 1 ELSE 0 END) AS incorrect_submissions,  
    SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions,  
    SUM(CASE WHEN points < 0 THEN points ELSE 0 END) AS incorrect_submissions_points,  
    SUM(CASE WHEN points > 0 THEN points ELSE 0 END) AS correct_submissions_points_earned,  
    SUM(points) AS points_earned  
FROM user_submissions  
GROUP BY username  
ORDER BY incorrect_submissions DESC  
LIMIT 5;  

-- Q5: Find the top 10 performers for each week.  
WITH weekly_performance AS (  
    SELECT  
        WEEK(submitted_at) AS week_no,  
        username,  
        SUM(points) AS total_points_earned,  
        DENSE_RANK() OVER(PARTITION BY WEEK(submitted_at) ORDER BY SUM(points) DESC) AS rank  
    FROM user_submissions  
    GROUP BY week_no, username  
)  
SELECT  
    week_no,  
    username,  
    total_points_earned  
FROM weekly_performance  
WHERE rank <= 10  
ORDER BY week_no, total_points_earned DESC;  
