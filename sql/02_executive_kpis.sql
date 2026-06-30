/*
02_executive_kpis.sql
Purpose: Reproduce the principal case-study KPIs from the cleaned dataset.

Dialect: SQLite
Input table: telco_customer_churn_clean
*/

-- 1. Executive KPI summary
SELECT
    COUNT(*) AS total_customers,
    SUM(CAST(is_churned AS INTEGER)) AS churned_customers,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(SUM(CAST(MonthlyCharges AS REAL)), 2) AS gross_mrr,
    ROUND(
        SUM(
            CASE
                WHEN CAST(is_churned AS INTEGER) = 1
                THEN CAST(MonthlyCharges AS REAL)
                ELSE 0
            END
        ),
        2
    ) AS churned_account_mrr,
    ROUND(
        12.0 * SUM(
            CASE
                WHEN CAST(is_churned AS INTEGER) = 1
                THEN CAST(MonthlyCharges AS REAL)
                ELSE 0
            END
        ),
        2
    ) AS annualized_exposure
FROM telco_customer_churn_clean;

-- Expected:
-- 7,043 customers
-- 1,869 churned customers
-- 26.54% churn
-- $456,116.60 gross MRR
-- $139,130.85 churned-account MRR
-- $1,669,570.20 annualized exposure


-- 2. Active versus churned customer profile
SELECT
    Churn,
    COUNT(*) AS customers,
    ROUND(AVG(CAST(tenure AS REAL)), 2) AS average_tenure_months,
    ROUND(AVG(CAST(MonthlyCharges AS REAL)), 2) AS average_monthly_charge,
    ROUND(SUM(CAST(MonthlyCharges AS REAL)), 2) AS monthly_charges
FROM telco_customer_churn_clean
GROUP BY Churn
ORDER BY Churn DESC;


-- 3. Median tenure by churn status
WITH ordered AS (
    SELECT
        Churn,
        CAST(tenure AS INTEGER) AS tenure,
        ROW_NUMBER() OVER (
            PARTITION BY Churn
            ORDER BY CAST(tenure AS INTEGER)
        ) AS row_num,
        COUNT(*) OVER (PARTITION BY Churn) AS group_size
    FROM telco_customer_churn_clean
)
SELECT
    Churn,
    ROUND(AVG(tenure), 1) AS median_tenure_months
FROM ordered
WHERE row_num IN (
    CAST((group_size + 1) / 2 AS INTEGER),
    CAST((group_size + 2) / 2 AS INTEGER)
)
GROUP BY Churn
ORDER BY Churn DESC;

-- Expected median tenure: 10 months for churned customers; 38 months for active.
