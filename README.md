# Customer Retention & Revenue Assurance Audit

> End-to-End Business Operations & Data Analytics Case Study

A complete business analytics project focused on customer churn, recurring-revenue exposure and operational decision-making using the IBM Telco Customer Churn dataset.

The project combines **Python, SQL, Excel and Tableau** to transform a public customer-level dataset into a reproducible analysis, an executive case study and an interactive decision-support dashboard.

[View the full case study](Case_Study_01_Customer_Churn_Analysis.pdf) · [Explore the interactive Tableau dashboard](https://public.tableau.com/app/profile/rayan.braccio/viz/CustomerRetentionRevenueAssuranceDashboard/ExecutiveDashboard)

---

## Executive Summary

Customer retention has a direct impact on recurring revenue and long-term profitability.

This case study investigates the operational drivers associated with customer churn across a telecommunications customer base of **7,043 subscribers**.

The analysis identifies the contract structures, payment behaviours, service combinations and customer lifecycle stages associated with the highest observed churn rates and recurring-revenue exposure.

Rather than focusing only on descriptive statistics, the project translates the analytical findings into actionable operational recommendations covering retention workflows, customer onboarding, billing journeys, contract migration and customer-support interventions.

---

## Business Objectives

The project addresses five principal business questions:

- Which customer segments exhibit the highest churn rates?
- Which operational factors are associated with customer churn?
- How much monthly recurring revenue is exposed through churned accounts?
- Which customer segments should be prioritised for intervention?
- Which business actions could deliver the highest operational impact?

---

## Executive KPIs

| KPI | Value |
|---|---:|
| Customers Analysed | 7,043 |
| Churned Customers | 1,869 |
| Overall Churn Rate | 26.54% |
| Gross MRR | $456,116.60 |
| Churned-Account MRR | $139,130.85 |
| Annualized Exposure | $1,669,570.20 |
| Highest-Risk Segment Churn Rate | 62.92% |

---

## Interactive Tableau Dashboard

[![Customer Retention and Revenue Assurance Dashboard](dashboard/dashboard_preview.png)](https://public.tableau.com/app/profile/rayan.braccio/viz/CustomerRetentionRevenueAssuranceDashboard/ExecutiveDashboard)

The interactive Tableau dashboard consolidates the principal customer-retention, recurring-revenue and operational-risk metrics used throughout the case study.

It includes:

- Executive retention and revenue KPIs
- Churn rate by contract type
- Churn rate by payment method
- Churn rate by tenure band
- Fiber optic churn by Tech Support status
- Highest-risk customer segment identification

[View the interactive dashboard on Tableau Public](https://public.tableau.com/app/profile/rayan.braccio/viz/CustomerRetentionRevenueAssuranceDashboard/ExecutiveDashboard)

---

## Project Workflow

```text
Raw Dataset
    ↓
Data Cleaning
    ↓
Data Validation
    ↓
SQL Reconciliation
    ↓
Exploratory Data Analysis
    ↓
Customer Segmentation
    ↓
Financial Impact Assessment
    ↓
Operational Recommendations
    ↓
Executive Reporting
    ↓
Interactive Tableau Dashboard
```

---

## Tools and Methods

### Tools

- Python
- SQL
- Tableau
- Microsoft Excel
- Git and GitHub
- Google Sheets
- Google Docs

### Analytical Methods

- Data Cleaning
- Data Validation
- Exploratory Data Analysis
- Customer Segmentation
- KPI Reporting
- Revenue Analysis
- Data Visualization
- Sensitivity Analysis
- Executive Reporting
- Business Recommendation Development

---

## Key Insights

### 1. Contract Structure

Customers on month-to-month contracts represent the largest concentration of observed churn.

- Churn Rate: **42.71%**
- Contribution to Total Churn: **88.55%**

Customers on one-year and two-year contracts exhibit substantially lower churn rates, suggesting that contract structure is one of the strongest retention signals in the dataset.

---

### 2. Payment Behaviour

Customers using Electronic Check exhibit the highest observed churn rate.

- Electronic Check Churn Rate: **45.29%**
- Mailed Check Churn Rate: **19.11%**
- Automatic Bank Transfer Churn Rate: **16.71%**
- Automatic Credit Card Churn Rate: **15.24%**

This result highlights potential billing-journey friction and supports testing targeted AutoPay migration initiatives.

The analysis identifies an association between payment method and churn; it does not establish that the payment method itself causes churn.

---

### 3. Fiber Optic and Tech Support

Among Fiber optic customers, the observed churn rate differs substantially depending on whether Tech Support is present.

- Fiber Optic without Tech Support: **49.37%**
- Fiber Optic with Tech Support: **22.63%**

This association supports testing structured Fiber onboarding, proactive support activation and early-life customer assistance.

The dataset does not establish a causal relationship between Tech Support and retention.

---

### 4. Customer Lifecycle

Churn is most concentrated during the earliest stages of the customer lifecycle.

| Tenure Band | Churn Rate |
|---|---:|
| 0–6 months | 52.94% |
| 7–12 months | 35.89% |
| 13–24 months | 28.71% |
| 25–36 months | 21.63% |
| 37–48 months | 19.03% |
| 49–60 months | 14.42% |
| 61–72 months | 6.61% |

The progressive decline in churn across tenure bands supports the use of early-life retention triggers and onboarding interventions.

---

### 5. Highest-Risk Segment

The highest-risk customer segment combines:

- Month-to-month contract
- Electronic Check payment
- Fiber optic internet
- No Tech Support

| Segment KPI | Value |
|---|---:|
| Customers | 1,138 |
| Churned Customers | 716 |
| Segment Churn Rate | 62.92% |
| Share of Total Customer Base | 16.16% |
| Share of Total Churn | 38.31% |
| Churned-Account MRR | $61,358.05 |

This segment represents a relatively concentrated intervention population while accounting for more than one-third of all observed churn.

---

## Business Recommendations

| Recommendation | Priority |
|---|---|
| Launch early-life retention triggers for customers in their first 12 months | High |
| Test annual-contract migration journeys for month-to-month customers | High |
| Introduce structured Fiber onboarding and proactive Tech Support activation | High |
| Operationalise a targeted intervention queue for the highest-risk segment | High |
| Test AutoPay migration campaigns and review Electronic Check billing friction | Medium |
| Track retention outcomes through controlled experiments and cohort reporting | Medium |

---

## Business Impact

The sensitivity analysis estimates the potential annualized revenue protection associated with retaining a proportion of the observed churned-account MRR exposure.

| Retained Exposure Scenario | Estimated Annualized Revenue Protected |
|---|---:|
| 1% | $16,695.70 |
| 3% | $50,087.11 |
| 5% | $83,478.51 |
| 10% | $166,957.02 |

Retaining **3% of the observed churned-account MRR exposure** could protect approximately **$50,087 in annualized revenue**, while retaining **5%** could protect approximately **$83,479**.

These figures are opportunity-sizing scenarios rather than forecasts. They do not account for intervention costs, discounts, contribution margin or customer lifetime value.

---

## Repository Structure

```text
customer-retention-revenue-assurance-audit/
├── README.md
├── Case_Study_01_Customer_Churn_Analysis.pdf
├── MANIFEST.json
├── dashboard/
│   ├── README.md
│   └── dashboard_preview.png
├── data/
│   ├── raw/
│   │   └── WA_Fn-UseC_-Telco-Customer-Churn.csv
│   └── processed/
│       └── telco_customer_churn_clean.csv
├── docs/
│   ├── DATA_PACKAGE_README.md
│   ├── CLEANING_DOCUMENTATION.md
│   ├── QA_RECONCILIATION.md
│   └── data_dictionary.csv
├── scripts/
│   └── build_clean_dataset.py
└── sql/
    ├── README.md
    ├── 01_data_quality_validation.sql
    ├── 02_executive_kpis.sql
    ├── 03_churn_segmentation.sql
    └── 04_priority_segment_and_revenue.sql
```

---

## Project Deliverables

### Executive Reporting and Visualization

- [Executive case study](Case_Study_01_Customer_Churn_Analysis.pdf)
- [Interactive Tableau dashboard](https://public.tableau.com/app/profile/rayan.braccio/viz/CustomerRetentionRevenueAssuranceDashboard/ExecutiveDashboard)
- [Dashboard documentation](dashboard/README.md)

### Data

- [Source dataset](data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv)
- [Analysis-ready cleaned dataset](data/processed/telco_customer_churn_clean.csv)
- [Data dictionary](docs/data_dictionary.csv)
- [Dataset manifest](MANIFEST.json)

### Data Quality and Documentation

- [Data cleaning documentation](docs/CLEANING_DOCUMENTATION.md)
- [QA and KPI reconciliation](docs/QA_RECONCILIATION.md)
- [Dataset package overview](docs/DATA_PACKAGE_README.md)

### Reproducible Analysis

- [Dataset build script](scripts/build_clean_dataset.py)
- [Verified SQL analysis package](sql/README.md)
- [Data quality validation queries](sql/01_data_quality_validation.sql)
- [Executive KPI queries](sql/02_executive_kpis.sql)
- [Churn segmentation queries](sql/03_churn_segmentation.sql)
- [Priority-segment and revenue queries](sql/04_priority_segment_and_revenue.sql)

---

## Reproducibility

The cleaned dataset can be rebuilt from the original source file using Python:

```bash
python scripts/build_clean_dataset.py \
  --input data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv \
  --output data/processed/telco_customer_churn_clean.csv
```

The build script validates:

- Source schema
- Customer ID uniqueness
- Row-count preservation
- Missing-value treatment
- Analytical field generation
- Principal KPI reconciliation

The SQL scripts reproduce the core data-quality controls, executive KPIs, churn segmentations, priority-segment metrics and revenue sensitivity scenarios used in the case study.

---

## Skills Demonstrated

- Business Operations
- Business Analytics
- SQL
- Python
- Tableau
- Microsoft Excel
- Data Cleaning
- Data Validation
- Exploratory Data Analysis
- Customer Segmentation
- Revenue Analysis
- Dashboard Design
- Data Visualization
- Executive Reporting
- Data Storytelling
- Business Recommendations
- Stakeholder Communication
- Reproducible Analytics
- GitHub Project Documentation

---

## About the Author

**Rayan Braccio**

Business Operations and Data Analytics professional with experience supporting large-scale platform operations.

Following several years in Trust & Safety Operations, this portfolio demonstrates a transition toward Business Operations, Business Analytics and Data Analytics by combining operational expertise with structured analysis, data validation and decision-oriented reporting.

[Connect with me on LinkedIn](https://www.linkedin.com/in/rayan-braccio-94a70a166)

---

## Portfolio

This repository is part of a growing Business Analytics portfolio.

Planned portfolio projects include:

- Sales Performance Analytics
- Product Operations Dashboard
- Marketing Campaign Performance
- Fraud and Risk Analytics
- Supply Chain Analytics

---

If you found this project relevant, feel free to [connect with me on LinkedIn](https://www.linkedin.com/in/rayan-braccio-94a70a166).
