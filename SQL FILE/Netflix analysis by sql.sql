SELECT * FROM netflix;
--What is the Month-over-Month (MoM) revenue growth rate by subscription plan and region?
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', subscription_start_date) AS month,
        subscription_plan,
        region,
        SUM(monthly_fee) AS total_revenue
    FROM netflix
    GROUP BY 1, 2, 3
),
revenue_with_lag AS (
    SELECT
        month,
        subscription_plan,
        region,
        total_revenue,
        LAG(total_revenue) OVER (
            PARTITION BY subscription_plan, region
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    subscription_plan,
    region,
    total_revenue,
    previous_month_revenue,
    CASE 
        WHEN previous_month_revenue IS NULL 
             OR previous_month_revenue = 0
        THEN NULL
        ELSE ((total_revenue - previous_month_revenue)
              / previous_month_revenue) * 100
    END AS mom_growth_percentage
FROM revenue_with_lag
ORDER BY subscription_plan, region, month;
--What is the Year-over-Year (YoY) revenue growth by country, and which countries are driving the highest expansion?
WITH yearly_revenue AS (
    SELECT
        DATE_TRUNC('year', subscription_start_date) AS year,
        country,
        SUM(monthly_fee) AS total_revenue
    FROM netflix
    GROUP BY 1, 2
),
revenue_with_lag AS (
    SELECT
        year,
        country,
        total_revenue,
        LAG(total_revenue) OVER (
            PARTITION BY country
            ORDER BY year
        ) AS previous_year_revenue
    FROM yearly_revenue
)
SELECT
    year,
    country,
    total_revenue,
    previous_year_revenue,
    CASE
        WHEN previous_year_revenue IS NULL
             OR previous_year_revenue = 0
        THEN NULL
        ELSE ((total_revenue - previous_year_revenue)
              / previous_year_revenue) * 100
    END AS yoy_growth_percentage
FROM revenue_with_lag
ORDER BY country, year;
--What is the Average Revenue Per User (ARPU) by subscription plan and how does it vary across regions?
SELECT
    subscription_plan,
    region,
    SUM(monthly_fee) AS total_revenue,
    COUNT(DISTINCT user_id) AS total_users,
    SUM(monthly_fee) / COUNT(DISTINCT user_id) AS arpu
FROM netflix
GROUP BY subscription_plan, region
ORDER BY subscription_plan, region;
--What percentage of total revenue comes from users who received discounts vs. those who did not?
WITH revenue_data AS (
    SELECT
        discount_applied,
        SUM(monthly_fee) AS total_revenue
    FROM netflix
    GROUP BY discount_applied
),
total_revenue AS (
    SELECT SUM(monthly_fee) AS overall_revenue
    FROM netflix
)
SELECT
    r.discount_applied,
    r.total_revenue,
    (r.total_revenue / t.overall_revenue) * 100 AS revenue_percentage
FROM revenue_data r
CROSS JOIN total_revenue t
ORDER BY revenue_percentage DESC;
--What is the monthly churn rate by subscription plan, and which plan shows the highest customer instability?
WITH monthly_churn AS (
    SELECT
        DATE_TRUNC('month', subscription_end_date) AS month,
        subscription_plan,
        COUNT(DISTINCT user_id) AS churned_users
    FROM netflix
    WHERE is_churned = 1
    GROUP BY 1, 2
),
plan_totals AS (
    SELECT
        subscription_plan,
        COUNT(DISTINCT user_id) AS total_users
    FROM netflix
    GROUP BY subscription_plan
)
SELECT
    mc.month,
    mc.subscription_plan,
    mc.churned_users,
    pt.total_users,
    (mc.churned_users::decimal / pt.total_users) * 100 AS monthly_churn_rate
FROM monthly_churn mc
JOIN plan_totals pt
    ON mc.subscription_plan = pt.subscription_plan
ORDER BY mc.subscription_plan, mc.month;
--Which demographic segments (age group, region, gender) show the highest churn probability?
---Churn Probability by Age Group
SELECT
    age_group,
    COUNT(DISTINCT CASE WHEN is_churned = 1 THEN user_id END)::decimal
    / COUNT(DISTINCT user_id) * 100 AS churn_rate_percentage
FROM netflix
GROUP BY age_group
ORDER BY churn_rate_percentage DESC;
---Churn Probability by Gender
SELECT
    gender,
    COUNT(DISTINCT CASE WHEN is_churned = 1 THEN user_id END)::decimal
    / COUNT(DISTINCT user_id) * 100 AS churn_rate_percentage
FROM netflix
GROUP BY gender
ORDER BY churn_rate_percentage DESC;
---Churn Probability by Region
SELECT
    region,
    COUNT(DISTINCT CASE WHEN is_churned = 1 THEN user_id END)::decimal
    / COUNT(DISTINCT user_id) * 100 AS churn_rate_percentage
FROM netflix
GROUP BY region
ORDER BY churn_rate_percentage DESC;
--What is the average watch engagement difference between churned and retained users before churn?
SELECT
    is_churned,
    AVG(watch_time_minutes) AS avg_watch_time,
    AVG(session_count) AS avg_session_count,
    AVG(completion_percentage) AS avg_completion_rate,
    AVG(avg_weekly_watch_time) AS avg_weekly_watch
FROM netflix
GROUP BY is_churned
ORDER BY is_churned;
--Which genres generate the highest average watch time and completion rate, segmented by subscription plan?
SELECT
    subscription_plan,
    genre,
    AVG(watch_time_minutes) AS avg_watch_time,
    AVG(completion_percentage) AS avg_completion_rate
FROM netflix
GROUP BY subscription_plan, genre
ORDER BY subscription_plan, avg_watch_time DESC;
--What is the engagement-to-revenue ratio per content type (Movie vs Series)?
SELECT
    content_type,
    SUM(watch_time_minutes) AS total_watch_time,
    SUM(monthly_fee) AS total_revenue,
    SUM(watch_time_minutes)::decimal / SUM(monthly_fee)
        AS engagement_revenue_ratio
FROM netflix
GROUP BY content_type
ORDER BY engagement_revenue_ratio DESC;
--Which recommendation source (Trending, Algorithm, Friend, etc.) drives the highest user retention and engagement?
---Engagement by Recommendation Source
SELECT
    recommendation_source,
    AVG(watch_time_minutes) AS avg_watch_time,
    AVG(session_count) AS avg_sessions,
    AVG(completion_percentage) AS avg_completion_rate,
    AVG(rating) AS avg_rating
FROM netflix
GROUP BY recommendation_source
ORDER BY avg_watch_time DESC;
---Retention (Churn Rate by Recommendation Source)
SELECT
    recommendation_source,
    COUNT(DISTINCT CASE WHEN is_churned = 1 THEN user_id END)::decimal
        / COUNT(DISTINCT user_id) * 100 AS churn_rate_percentage
FROM netflix
GROUP BY recommendation_source
ORDER BY churn_rate_percentage ASC;
---Combined View (Engagement + Retention Together)
SELECT
    recommendation_source,
    AVG(watch_time_minutes) AS avg_watch_time,
    AVG(completion_percentage) AS avg_completion_rate,
    COUNT(DISTINCT CASE WHEN is_churned = 1 THEN user_id END)::decimal
        / COUNT(DISTINCT user_id) * 100 AS churn_rate_percentage
FROM netflix
GROUP BY recommendation_source
ORDER BY avg_watch_time DESC;
---How does device type influence average session count and content completion rate?
SELECT
    device_type,
    AVG(session_count) AS avg_session_count,
    AVG(completion_percentage) AS avg_completion_rate,
    AVG(watch_time_minutes) AS avg_watch_time
FROM netflix
GROUP BY device_type
ORDER BY avg_session_count DESC;
--What is the relationship between content diversity score and churn rate?
SELECT
    is_churned,
    AVG(content_diversity_score) AS avg_diversity_score
FROM netflix
GROUP BY is_churned
ORDER BY is_churned;

--Identify high-value users (top 10% by watch time) — what are their common behavioral and demographic traits?
-----calculate Total Watch Time per user 
WITH user_watch_time AS (
    SELECT
        user_id,
        SUM(watch_time_minutes) AS total_watch_time
    FROM netflix
    GROUP BY user_id
),
percentile_cutoff AS (
    SELECT
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_watch_time) AS top_10_threshold
    FROM user_watch_time
)
SELECT *
FROM user_watch_time
WHERE total_watch_time >= (
    SELECT top_10_threshold FROM percentile_cutoff
);
--Analyse their trait
WITH user_watch_time AS (
    SELECT
        user_id,
        SUM(watch_time_minutes) AS total_watch_time
    FROM netflix
    GROUP BY user_id
),
percentile_cutoff AS (
    SELECT
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_watch_time) AS top_10_threshold
    FROM user_watch_time
),
top_users AS (
    SELECT u.user_id
    FROM user_watch_time u
    JOIN percentile_cutoff p
        ON u.total_watch_time >= p.top_10_threshold
)
SELECT
    n.subscription_plan,
    n.region,
    n.gender,
    n.age_group,
    AVG(n.session_count) AS avg_sessions,
    AVG(n.completion_percentage) AS avg_completion,
    AVG(n.avg_weekly_watch_time) AS avg_weekly_watch,
    COUNT(DISTINCT n.user_id) AS user_count
FROM netflix n
JOIN top_users t
    ON n.user_id = t.user_id
GROUP BY
    n.subscription_plan,
    n.region,
    n.gender,
    n.age_group
ORDER BY user_count DESC;