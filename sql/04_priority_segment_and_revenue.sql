/*
04_priority_segment_and_revenue.sql
Purpose: Quantify the published priority segment and translate observed
churned-account MRR into transparent sensitivity scenarios.

Dialect: SQLite
Input table: telco_customer_churn_clean
*/

-- 1. Priority rule-based segment
WITH totals AS (
    SELECT
        COUNT(*) AS total_customers,
        SUM(CAST(is_churned AS INTEGER)) AS total_churned
    FROM telco_customer_churn_clean
),
priority_segment AS (
    SELECT *
    FROM telco_customer_churn_clean
    WHERE CAST(flag_priority_segment AS INTEGER) = 1
)
SELECT
    COUNT(*) AS segment_customers,
    SUM(CAST(is_churned AS INTEGER)) AS segment_churned,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / COUNT(*),
        2
    ) AS segment_churn_rate_pct,
    ROUND(
        100.0 * COUNT(*) / totals.total_customers,
        2
    ) AS share_of_customer_base_pct,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / totals.total_churned,
        2
    ) AS share_of_all_churn_pct,
    ROUND(
        SUM(
            CASE
                WHEN CAST(is_churned AS INTEGER) = 1
                THEN CAST(MonthlyCharges AS REAL)
                ELSE 0
            END
        ),
        2
    ) AS churned_account_mrr
FROM priority_segment
CROSS JOIN totals;

-- Expected:
-- 1,138 customers
-- 716 churns
-- 62.92% churn
-- 16.16% of the customer base
-- 38.31% of all churn
-- $61,358.05 churned-account MRR


-- 2. First 12 months + month-to-month + Fiber optic
SELECT
    COUNT(*) AS segment_customers,
    SUM(CAST(is_churned AS INTEGER)) AS segment_churned,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / COUNT(*),
        2
    ) AS segment_churn_rate_pct,
    ROUND(
        SUM(
            CASE
                WHEN CAST(is_churned AS INTEGER) = 1
                THEN CAST(MonthlyCharges AS REAL)
                ELSE 0
            END
        ),
        2
    ) AS churned_account_mrr
FROM telco_customer_churn_clean
WHERE CAST(flag_first_12m_mtm_fiber AS INTEGER) = 1;

-- Expected: 916 customers; 643 churns; 70.20% churn; $53,178.30 MRR.


-- 3. Observed monthly revenue composition
SELECT
    ROUND(SUM(CAST(MonthlyCharges AS REAL)), 2) AS gross_mrr,
    ROUND(
        SUM(
            CASE
                WHEN CAST(is_churned AS INTEGER) = 0
                THEN CAST(MonthlyCharges AS REAL)
                ELSE 0
            END
        ),
        2
    ) AS active_account_mrr,
    ROUND(
        SUM(
            CASE
                WHEN CAST(is_churned AS INTEGER) = 1
                THEN CAST(MonthlyCharges AS REAL)
                ELSE 0
            END
        ),
        2
    ) AS churned_account_mrr
FROM telco_customer_churn_clean;


-- 4. Retention sensitivity scenarios
-- MonthlyCharges is converted to integer cents first. The final conversion uses
-- half-even rounding so the outputs reconcile exactly to the published case study.
WITH exposure AS (
    SELECT
        SUM(
            CASE
                WHEN CAST(is_churned AS INTEGER) = 1
                THEN CAST(ROUND(CAST(MonthlyCharges AS REAL) * 100.0, 0) AS INTEGER)
                ELSE 0
            END
        ) AS churned_account_mrr_cents
    FROM telco_customer_churn_clean
),
scenarios(reduction_rate) AS (
    VALUES (0.01), (0.03), (0.05), (0.10)
),
scenario_values AS (
    SELECT
        reduction_rate,
        churned_account_mrr_cents * reduction_rate AS monthly_cents_exact,
        churned_account_mrr_cents * reduction_rate * 12.0 AS annual_cents_exact
    FROM exposure
    CROSS JOIN scenarios
),
rounded_values AS (
    SELECT
        reduction_rate,
        CASE
            WHEN ABS(
                monthly_cents_exact
                - CAST(monthly_cents_exact AS INTEGER)
                - 0.5
            ) < 0.000001
            THEN (
                CAST(monthly_cents_exact AS INTEGER)
                + (CAST(monthly_cents_exact AS INTEGER) % 2)
            ) / 100.0
            ELSE ROUND(monthly_cents_exact, 0) / 100.0
        END AS monthly_mrr_retained,
        CASE
            WHEN ABS(
                annual_cents_exact
                - CAST(annual_cents_exact AS INTEGER)
                - 0.5
            ) < 0.000001
            THEN (
                CAST(annual_cents_exact AS INTEGER)
                + (CAST(annual_cents_exact AS INTEGER) % 2)
            ) / 100.0
            ELSE ROUND(annual_cents_exact, 0) / 100.0
        END AS annualized_revenue_retained
    FROM scenario_values
)
SELECT
    printf('%.2f%%', reduction_rate * 100.0) AS relative_reduction,
    monthly_mrr_retained,
    annualized_revenue_retained
FROM rounded_values
ORDER BY reduction_rate;

-- Expected monthly / annualized values:
-- 1.00%:  $1,391.31 / $16,695.70
-- 3.00%:  $4,173.93 / $50,087.11
-- 5.00%:  $6,956.54 / $83,478.51
-- 10.00%: $13,913.08 / $166,957.02
-- These are opportunity-sizing sensitivities, not forecasts or profit estimates.
