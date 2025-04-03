# SQL Mentor User Performance Analysis 



## Project Overview 

This project uses SQL Querying for performance analysis using real-time data from SQL Mentor datasets. In this project, I analyzed user performance by creating and querying a table of user submissions. The goal is to solve a series of SQL problems to extract meaningful insights from user data.

## Objectives

- Understanding how to use SQL for data analysis tasks such as aggregation, filtering, and ranking.
- Understanding how to calculate and manipulate data in a real-world dataset.
- Gaining hands-on experience with SQL functions like `COUNT`, `SUM`, `AVG`, and `DENSE_RANK()`.
- Develop skills for performance analysis using SQL by solving different types of data problems related to user performance.

## SQL Mentor User Performance Dataset

The dataset consists of information about user submissions for an online learning platform. Each submission includes:
- **User ID**
- **Question ID**
- **Points Earned**
- **Submission Timestamp**
- **Username**

This data allows us to analyze user performance in terms of correct and incorrect submissions, total points earned, and daily/weekly activity.

## SQL Problems and Questions

Here are the SQL problems that I solved as part of this project:

### Q1. List All Distinct Users and Their Stats
- **Description**: Return the user name, total submissions, and total points earned by each user.
- **Expected Output**: A list of users with their submission count and total points.

### Q2. Calculate the Daily Average Points for Each User
- **Description**: For each day, calculate the average points earned by each user.
- **Expected Output**: A report showing the average points per user for each day.

### Q3. Find the Top 3 Users with the Most Correct Submissions for Each Day
- **Description**: Identify the top 3 users with the most correct submissions for each day.
- **Expected Output**: A list of users and their correct submissions, ranked daily.

### Q4. Find the Top 5 Users with the Highest Number of Incorrect Submissions
- **Description**: Identify the top 5 users with the highest number of incorrect submissions.
- **Expected Output**: A list of users with the count of incorrect submissions.

### Q5. Find the Top 10 Performers for Each Week
- **Description**: Identify the top 10 users with the highest total points earned each week.
- **Expected Output**: A report showing the top 10 users ranked by total points per week.

## Key SQL Concepts used

- **Aggregation**: Using `COUNT`, `SUM`, `AVG` to aggregate data.
- **Date Functions**: Using `EXTRACT()` and `TO_CHAR()` for manipulating dates.
- **Conditional Aggregation**: Using `CASE WHEN` to handle positive and negative submissions.
- **Ranking**: Using `DENSE_RANK()` to rank users based on their performance.
- **Group By**: Aggregating results by groups (e.g., by user, by day, by week).

## SQL Queries Solutions

Below are the solutions for each question in this project:

### Q1: List All Distinct Users and Their Stats
```sql
SELECT 
    username,
    COUNT(*) AS total_submissions,  -- Counts all rows, including those where `id` might be NULL
    SUM(points) AS points_earned
FROM user_submissions
GROUP BY username
ORDER BY total_submissions DESC;

```

### Q2: Calculate the Daily Average Points for Each User
```sql
SELECT 
    DATE_FORMAT(submitted_at, '%d-%m') AS day,
    username,
    AVG(points) AS daily_avg_points
FROM user_submissions
GROUP BY day, username  -- Replaced "GROUP BY 1, 2" with explicit column names
ORDER BY username;
```

### Q3: Find the Top 3 Users with the Most Correct Submissions for Each Day
```sql
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
```

### Q4: Find the Top 5 Users with the Highest Number of Incorrect Submissions
```sql
SELECT 
    username,
    SUM(CASE WHEN points < 0 THEN 1 ELSE 0 END) AS incorrect_submissions,
    SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions,
    SUM(CASE WHEN points < 0 THEN points ELSE 0 END) AS incorrect_submissions_points,
    SUM(CASE WHEN points > 0 THEN points ELSE 0 END) AS correct_submissions_points_earned,
    SUM(points) AS points_earned
FROM user_submissions
GROUP BY username  -- Explicit column name instead of "GROUP BY 1"
ORDER BY incorrect_submissions DESC;

```

### Q5: Find the Top 10 Performers for Each Week
```sql
SELECT *  
FROM (
    SELECT 
        WEEK(submitted_at) AS week_no,
        username,
        SUM(points) AS total_points_earned,
        DENSE_RANK() OVER(PARTITION BY WEEK(submitted_at) ORDER BY SUM(points) DESC) AS rank
    FROM user_submissions
    GROUP BY week_no, username
) ranked_data
WHERE rank <= 10
ORDER BY week_no, total_points_earned DESC;

```

## Conclusion

This project provided an excellent opportunity for me to apply my SQL knowledge to solve practical data problems. By working through these SQL queries, I gained hands-on experience with data aggregation, ranking, date manipulation, and conditional logic.
