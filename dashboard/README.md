# Tableau Executive Dashboard

Interactive Tableau Public dashboard supporting the Customer Retention & Revenue Assurance case study.

## Live Dashboard

[View the interactive dashboard on Tableau Public](https://public.tableau.com/app/profile/rayan.braccio/viz/CustomerRetentionRevenueAssuranceDashboard/ExecutiveDashboard)

## Dashboard Scope

The dashboard provides an executive view of customer churn, recurring-revenue exposure and the highest-priority operational risk segments.

It includes:

- Total customer base
- Overall churn rate
- Gross monthly recurring revenue
- Churned-account monthly recurring revenue
- Annualized revenue exposure
- Highest-risk customer segment
- Churn rate by contract type
- Churn rate by payment method
- Churn rate by tenure band
- Fiber optic churn by Tech Support status

## Verified Executive Metrics

| KPI | Result |
|---|---:|
| Total Customers | 7,043 |
| Overall Churn Rate | 26.54% |
| Gross MRR | $456,116.60 |
| Churned-Account MRR | $139,130.85 |
| Annualized Exposure | $1,669,570.20 |
| Highest-Risk Segment Churn Rate | 62.92% |

## Priority Segment

The highest-risk segment combines:

- Month-to-month contract
- Electronic check payment
- Fiber optic internet
- No Tech Support

This segment contains 1,138 customers, 716 churned customers and represents 38.31% of all observed churn.

## Data Source

The dashboard uses the repository's analysis-ready dataset:

[View the cleaned dataset](../data/processed/telco_customer_churn_clean.csv)

## Dashboard Preview

![Customer Retention and Revenue Assurance Dashboard](dashboard_preview.png)
