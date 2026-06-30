# SQL Analysis Package

These scripts reproduce the principal quality controls, executive KPIs, churn segmentation and revenue analysis used in the case study.

## SQL dialect

The queries are written for **SQLite** and use the cleaned customer-level dataset.

Import:

`data/processed/telco_customer_churn_clean.csv`

as a table named:

`telco_customer_churn_clean`

The table must retain the column names supplied in the CSV.

## Execution order

1. `01_data_quality_validation.sql`
2. `02_executive_kpis.sql`
3. `03_churn_segmentation.sql`
4. `04_priority_segment_and_revenue.sql`

Each file is read-only and can be executed independently after the table has been created.

## Expected control totals

- Customers: 7,043
- Churned customers: 1,869
- Churn rate: 26.54%
- Gross MRR: $456,116.60
- Churned-account MRR: $139,130.85
- Priority segment: 1,138 customers, 716 churns, 62.92% churn

## Validation status

The package was executed end to end against the cleaned dataset rebuilt from
`data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv`.

The rebuilt CSV matched the repository's processed dataset byte for byte. All
18 SQL result sets reconciled to the published case-study controls, including
the contract, payment, service, lifecycle, priority-segment and revenue views.

The sensitivity calculation in `04_priority_segment_and_revenue.sql` uses
integer cents and half-even rounding so the 10% monthly scenario reconciles to
the published `$13,913.08` value rather than SQLite's default `$13,913.09`.
