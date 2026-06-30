/*
03_churn_segmentation.sql
Purpose: Reproduce the principal commercial, billing, service and lifecycle
segment views used in the case study.

Dialect: SQLite
Input table: telco_customer_churn_clean
*/

-- 1. Contract-level churn and MRR exposure
SELECT
    Contract,
    COUNT(*) AS accounts,
    SUM(CAST(is_churned AS INTEGER)) AS churned_accounts,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / COUNT(*),
        2
    ) AS churn_rate_pct,
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
        100.0 * SUM(CAST(is_churned AS INTEGER))
        / SUM(SUM(CAST(is_churned AS INTEGER))) OVER (),
        2
    ) AS share_of_all_churn_pct
FROM telco_customer_churn_clean
GROUP BY Contract
ORDER BY churn_rate_pct DESC;


-- 2. Payment-method churn
SELECT
    PaymentMethod,
    COUNT(*) AS accounts,
    SUM(CAST(is_churned AS INTEGER)) AS churned_accounts,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / COUNT(*),
        2
    ) AS churn_rate_pct,
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
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;


-- 3. Internet-service churn
SELECT
    InternetService,
    COUNT(*) AS accounts,
    SUM(CAST(is_churned AS INTEGER)) AS churned_accounts,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / COUNT(*),
        2
    ) AS churn_rate_pct,
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
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;


-- 4. Fiber optic and Tech Support association
SELECT
    CASE
        WHEN TechSupport = 'Yes' THEN 'Tech Support'
        ELSE 'No Tech Support'
    END AS support_status,
    COUNT(*) AS accounts,
    SUM(CAST(is_churned AS INTEGER)) AS churned_accounts,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / COUNT(*),
        2
    ) AS churn_rate_pct,
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
WHERE InternetService = 'Fiber optic'
GROUP BY support_status
ORDER BY churn_rate_pct DESC;


-- 5. Lifecycle-band churn
SELECT
    tenure_band,
    COUNT(*) AS accounts,
    SUM(CAST(is_churned AS INTEGER)) AS churned_accounts,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / COUNT(*),
        2
    ) AS churn_rate_pct,
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
GROUP BY tenure_band
ORDER BY
    CASE tenure_band
        WHEN '0-6' THEN 1
        WHEN '7-12' THEN 2
        WHEN '13-24' THEN 3
        WHEN '25-36' THEN 4
        WHEN '37-48' THEN 5
        WHEN '49-60' THEN 6
        WHEN '61-72' THEN 7
        ELSE 99
    END;


-- 6. Monthly charge-band churn
SELECT
    charge_band,
    COUNT(*) AS accounts,
    SUM(CAST(is_churned AS INTEGER)) AS churned_accounts,
    ROUND(
        100.0 * SUM(CAST(is_churned AS INTEGER)) / COUNT(*),
        2
    ) AS churn_rate_pct,
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
GROUP BY charge_band
ORDER BY
    CASE charge_band
        WHEN '18-35' THEN 1
        WHEN '35-55' THEN 2
        WHEN '55-75' THEN 3
        WHEN '75-95' THEN 4
        WHEN '95+' THEN 5
        ELSE 99
    END;
