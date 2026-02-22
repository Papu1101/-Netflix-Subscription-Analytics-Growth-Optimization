# -Netflix-Subscription-Analytics-Growth-Optimization
An End - to - End Project Using Python,Machine Learning,Stastitics,SQL and Power BI

📖 Project Overview

This project presents an end-to-end analytics framework for a subscription-based streaming platform. The objective is to analyze user behavior, predict churn, evaluate revenue sustainability, and provide data-driven strategic recommendations.

The analysis integrates:

Python (EDA, Machine Learning, Forecasting)

Statistical Testing (ANOVA)

SQL (Advanced Business Intelligence Queries)

Power BI (Executive Dashboard)

This project simulates real-world subscription analytics used in digital streaming platforms.

🎯 Business Objective

Streaming platforms face critical challenges:

Increasing customer churn

Revenue volatility

Engagement inconsistency

Content investment uncertainty

The goal of this project was to:

Predict customer churn

Analyze engagement behavior

Evaluate content performance

Forecast revenue trends

Identify high-value users

Deliver executive-ready business insights

📊 Dataset Description

The dataset represents realistic user behavior and subscription operations and includes:

👤 Demographics

Age Group

Gender

Country

Region

💳 Subscription Attributes

Subscription Plan

Monthly Fee

Discount Applied

Subscription Start & End Date

📺 Engagement Metrics

Watch Time (Minutes)

Session Count

Completion Percentage

Rating

Time of Day

🧠 Behavioral Signals

Days Since Last Watch

Average Weekly Watch Time

Content Diversity Score

🔁 Business Indicators

Churn Status

Recommendation Source

🔍 Exploratory Data Analysis (Python)

Initial data exploration revealed:

Premium subscribers demonstrate higher engagement intensity.

Higher watch time and session frequency correlate strongly with retention.

Series content generates higher engagement compared to movies.

Users with higher content diversity tend to churn less frequently.

EDA provided foundational behavioral understanding prior to modeling.

🧪 Statistical Testing — Recommendation Effectiveness

Hypothesis:

Does recommendation source significantly impact engagement?

Metrics Tested:

Watch Time

Completion Percentage

Rating

Method:

One-Way ANOVA

Result:

No statistically significant difference was found (p > 0.05).

Conclusion:

User engagement is influenced more by content relevance than discovery channel.

🤖 Machine Learning — Customer Churn Prediction
Objective

Predict users likely to cancel subscription.

Features Used

Watch time

Session frequency

Completion rate

Recency (days since last watch)

Subscription plan

Key Drivers Identified

Low engagement intensity

High inactivity

Reduced weekly watch behavior

Business Impact

The model enables proactive retention campaigns targeting high-risk users before revenue loss occurs.

📈 Revenue & Subscription Forecasting

Time-series modeling was performed using Prophet to forecast:

Monthly revenue trends

Subscription growth patterns

Net revenue (Revenue – Churn Impact)

Key Insight:

Revenue sustainability depends on managing churn growth alongside acquisition efforts.

🗄 Advanced SQL Business Intelligence

Comprehensive SQL analysis included:

Month-over-Month (MoM) revenue growth

Year-over-Year (YoY) revenue growth by country

ARPU by subscription plan and region

Retention rate (3, 6, 12 months)

Churn probability by demographic segments

Engagement difference (Churned vs Retained users)

High-value user identification (Top 10% by watch time)

Engagement-to-revenue ratio (Movies vs Series)

This provided granular financial and behavioral insights.

📊 Power BI Executive Dashboard

An interactive dashboard was developed with four sections:

Executive Overview

Revenue & Growth Drivers

Retention & Risk Analysis

Content & Engagement Insights

The dashboard provides real-time strategic visibility into:

Business health

Growth sustainability

Retention risk

Revenue efficiency

💡 Key Insights

Engagement intensity is the strongest predictor of churn.

Premium users contribute higher ARPU and engagement.

Recommendation source does not significantly influence engagement.

Content diversity appears to improve retention stability.

Revenue sustainability depends on churn control, not just acquisition.

🚀 Strategic Recommendations

Strengthen engagement-based retention programs.

Improve personalization effectiveness beyond current recommendation mechanisms.

Prioritize investment in high-performing content genres.

Reduce dependency on discount-driven revenue models.

Protect and nurture high-value power users.

🛠 Tech Stack

Python (Pandas, NumPy, Scikit-learn, Prophet, Matplotlib)

Statistical Testing (SciPy)

PostgreSQL (Advanced SQL queries)

Power BI (DAX, Dashboard Development)
