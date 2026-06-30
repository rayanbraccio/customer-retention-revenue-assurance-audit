/*
01_data_quality_validation.sql
Purpose: Validate dataset grain, key integrity, missing-value treatment
and analytical-field coverage before KPI analysis.

Dialect: SQLite
Input table: telco_customer_churn_clean
*/

-- 1. Dataset shape and unique customer count
SELECT
    COUNT(*) AS row_count,
    COUNT(DISTINCT customerID) AS unique_customer_ids,
    COUNT(*) - COUNT(DISTINCT customerID) AS duplicate_customer_ids
FROM telco_customer_churn_clean;

-- Expected: 7,043 rows; 7,043 unique customer IDs; 0 duplicates.


-- 2. Blank source TotalCharges and documented zero-tenure treatment
SELECT
    SUM(CASE
            WHEN TRIM(COALESCE(TotalCharges, '')) = '' THEN 1
            ELSE 0
        END) AS blank_source_total_charges,
    SUM(CASE
            WHEN TRIM(COALESCE(TotalCharges, '')) = ''
             AND CAST(tenure AS INTEGER) <> 0 THEN 1
            ELSE 0
        END) AS invalid_blank_total_charges,
    SUM(CASE
            WHEN TRIM(COALESCE(TotalCharges, '')) = ''
             AND CAST(TotalCharges_clean AS REAL) = 0.0 THEN 1
            ELSE 0
        END) AS blanks_converted_to_zero
FROM telco_customer_churn_clean;

-- Expected: 11 blank source values; 0 invalid blanks; 11 converted to 0.00.


-- 3. Analytical-field completeness
SELECT
    SUM(CASE WHEN TotalCharges_clean IS NULL THEN 1 ELSE 0 END)
        AS null_total_charges_clean,
    SUM(CASE WHEN is_churned IS NULL THEN 1 ELSE 0 END)
        AS null_is_churned,
    SUM(CASE WHEN tenure_band IS NULL OR TRIM(tenure_band) = '' THEN 1 ELSE 0 END)
        AS blank_tenure_band,
    SUM(CASE WHEN charge_band IS NULL OR TRIM(charge_band) = '' THEN 1 ELSE 0 END)
        AS blank_charge_band
FROM telco_customer_churn_clean;

-- Expected: 0 for every field.


-- 4. Churn-field consistency
SELECT
    SUM(CASE
            WHEN Churn = 'Yes' AND CAST(is_churned AS INTEGER) <> 1 THEN 1
            WHEN Churn = 'No'  AND CAST(is_churned AS INTEGER) <> 0 THEN 1
            ELSE 0
        END) AS churn_flag_mismatches
FROM telco_customer_churn_clean;

-- Expected: 0.


-- 5. Valid tenure-band coverage
SELECT
    tenure_band,
    COUNT(*) AS customers
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
