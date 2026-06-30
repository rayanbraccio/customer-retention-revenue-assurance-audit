# Data Cleaning Documentation

## Purpose

This package creates the analysis-ready customer-level dataset used by the executive case study **Customer Churn Analysis - IBM Telco Customer Churn Dataset**. The output preserves the report's published KPIs, findings, segment definitions, and recommendations without reinterpretation.

## Inputs and output grain

- Source CSV: `WA_Fn-UseC_-Telco-Customer-Churn.csv`
- Executive report: `CS3.pdf`
- Source shape: **7,043 rows x 21 source columns**
- Output shape: **7,043 rows x 33 columns**
- Grain: **one row per customer**
- Primary key: `customerID`
- Rows removed: **0**
- Source columns dropped: **0**

## Cleaning decisions

### 1. Schema validation

The input header must match the 21 published source fields exactly and in the expected order. The build fails on schema drift rather than silently accepting missing, renamed, or extra fields.

### 2. Whitespace normalization

Leading and trailing whitespace is removed from every source field. This converts the 11 whitespace-only `TotalCharges` values into explicit blanks while leaving all categorical labels unchanged.

### 3. Primary-key integrity

`customerID` is required and must be unique. The source contains 7,043 unique IDs and zero duplicates. No deduplication rule was needed and no records were discarded.

### 4. Numeric typing and formatting

- `SeniorCitizen` is parsed as an integer restricted to 0 or 1.
- `tenure` is parsed as an integer and must fall within the published 0-72 month range.
- `MonthlyCharges` is parsed as a decimal and written with two decimal places.
- Nonblank `TotalCharges` values are parsed as decimals and written with two decimal places.

Decimal arithmetic is used for revenue reconciliation to avoid binary floating-point rounding drift.

### 5. `TotalCharges` treatment

The source contains exactly 11 blank `TotalCharges` values. Every affected record has `tenure = 0`.

- `TotalCharges` is retained as blank for audit traceability.
- `TotalCharges_clean` is set to `0.00` for those 11 records.
- All other values are converted directly to numeric decimals.
- No mean, median, model-based, or neighboring-record imputation is used.

This preserves the report's stated interpretation: zero-tenure customers have no historical cumulative spend recorded.

### 6. Churn standardization

`is_churned` is derived as:

- `1` when `Churn = Yes`
- `0` when `Churn = No`

The original `Churn` field is retained.

### 7. Lifecycle bands

`tenure_band` uses the seven published ranges:

| Band | Rule |
|---|---|
| 0-6 | 0 <= tenure <= 6 |
| 7-12 | 7 <= tenure <= 12 |
| 13-24 | 13 <= tenure <= 24 |
| 25-36 | 25 <= tenure <= 36 |
| 37-48 | 37 <= tenure <= 48 |
| 49-60 | 49 <= tenure <= 60 |
| 61-72 | 61 <= tenure <= 72 |

### 8. Monthly charge bands

`charge_band` uses the five published business-readable ranges:

| Band | Rule |
|---|---|
| 18-35 | MonthlyCharges < 35 |
| 35-55 | 35 <= MonthlyCharges < 55 |
| 55-75 | 55 <= MonthlyCharges < 75 |
| 75-95 | 75 <= MonthlyCharges < 95 |
| 95+ | MonthlyCharges >= 95 |

The labels mirror the report; the left boundary of the first band reflects the observed minimum of 18.25.

### 9. Rule-based flags

The dataset contains transparent binary flags that reproduce only the report's published segmentation logic:

- `flag_early_life_0_6`
- `flag_month_to_month`
- `flag_electronic_check`
- `flag_fiber_optic`
- `flag_no_tech_support`
- `flag_fiber_no_tech_support`
- `flag_first_12m_mtm_fiber`
- `flag_priority_segment`

`flag_priority_segment` is exactly:

`Contract = Month-to-month`  
AND `PaymentMethod = Electronic check`  
AND `InternetService = Fiber optic`  
AND `TechSupport = No`

These are deterministic diagnostic rules, not predictive-model outputs or causal claims.

### 10. Category preservation

No category is merged, renamed, translated, or inferred. Values such as `No phone service` and `No internet service` remain distinct from `No`.

## Explicitly not performed

- No row deletion
- No duplicate suppression
- No outlier trimming or winsorization
- No average-value imputation
- No target leakage features
- No predictive score
- No change to any published KPI, finding, recommendation, or causal limitation

## Recommended analytical fields

Use `TotalCharges_clean` rather than `TotalCharges` for numeric aggregation. Use `is_churned` for rate calculations. Treat all risk flags as transparent segment membership indicators only.

## Reproducibility

Run:

```bash
python scripts/build_clean_dataset.py \
  --input data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv \
  --output data/processed/telco_customer_churn_clean.csv
```

The script validates schema, categories, key integrity, missing-value treatment, and the case-study reconciliation totals before writing the output.
