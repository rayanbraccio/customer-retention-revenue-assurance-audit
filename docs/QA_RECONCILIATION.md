# QA and KPI Reconciliation

All checks below were calculated directly from `telco_customer_churn_clean.csv`.

## Dataset controls

| Control | Result | Status |
|---|---:|---|
| Rows retained | 7,043 | Pass |
| Source columns | 21 | Pass |
| Output columns | 33 | Pass |
| Unique customer IDs | 7,043 | Pass |
| Duplicate customer IDs | 0 | Pass |
| Blank source `TotalCharges` | 11 | Pass |
| Blank `TotalCharges` with tenure other than 0 | 0 | Pass |
| Numeric `TotalCharges_clean` coverage | 100.00% | Pass |

## Executive KPI reconciliation

| KPI | Recalculated result | Published result | Status |
|---|---:|---:|---|
| Total customers | 7,043 | 7,043 | Pass |
| Churned customers | 1,869 | 1,869 | Pass |
| Churn rate | 26.54% | 26.54% | Pass |
| Gross MRR | $456,116.60 | $456,116.60 | Pass |
| Churned-account MRR | $139,130.85 | $139,130.85 | Pass |
| Annualized exposure | $1,669,570.20 | $1,669,570.20 | Pass |
| Churned-customer median tenure | 10 months | 10 months | Pass |
| Active-customer median tenure | 38.0 months | 38 months | Pass |
| Churned average monthly charge | $74.44 | $74.44 | Pass |
| Active average monthly charge | $61.27 | $61.27 | Pass |

## Contract reconciliation

| Contract | Accounts | Churned | Churn rate | Churned-account MRR | Status |
|---|---:|---:|---:|---:|---|
| Month-to-month | 3,875 | 1,655 | 42.71% | $120,847.10 | Pass |
| One year | 1,473 | 166 | 11.27% | $14,118.45 | Pass |
| Two year | 1,695 | 48 | 2.83% | $4,165.30 | Pass |

## Lifecycle-band reconciliation

| Tenure band | Accounts | Churned | Churn rate | Churned-account MRR | Status |
|---|---:|---:|---:|---:|---|
| 0-6 | 1,481 | 784 | 52.94% | $49,896.10 | Pass |
| 7-12 | 705 | 253 | 35.89% | $19,058.15 | Pass |
| 13-24 | 1,024 | 294 | 28.71% | $23,081.65 | Pass |
| 25-36 | 832 | 180 | 21.63% | $15,167.95 | Pass |
| 37-48 | 762 | 145 | 19.03% | $12,294.55 | Pass |
| 49-60 | 832 | 120 | 14.42% | $10,581.90 | Pass |
| 61-72 | 1,407 | 93 | 6.61% | $9,050.55 | Pass |

## Published segment checks

| Segment | Accounts | Churned | Churn rate | Churned-account MRR | Status |
|---|---:|---:|---:|---:|---|
| Fiber optic without Tech Support | 2,230 | 1,101 | 49.37% | $94,900.80 | Pass |
| Fiber optic with Tech Support | 866 | 196 | 22.63% | $19,399.25 | Pass |
| First 12 months + Month-to-month + Fiber optic | 916 | 643 | 70.20% | $53,178.30 | Pass |
| Priority rule-based segment | 1,138 | 716 | 62.92% | $61,358.05 | Pass |

The priority segment's churned-account MRR is **$61,358.05**, its customer-base share is **16.16%**, and its share of all churn is **38.31%**. These reproduce the published case study.

## Interpretation boundary

These validations establish arithmetic and segmentation consistency. They do not convert observational associations into causal evidence and do not alter the report's recommendations.
