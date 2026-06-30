# Clean Dataset Package

This package is ready to add to the `customer-retention-revenue-assurance-audit` repository.

## Contents

- `data/processed/telco_customer_churn_clean.csv` - analysis-ready customer-level dataset
- `docs/data_dictionary.csv` - machine-readable dictionary for all 33 columns
- `docs/CLEANING_DOCUMENTATION.md` - complete cleaning decision log
- `docs/QA_RECONCILIATION.md` - KPI and segment reconciliation against the executive report
- `scripts/build_clean_dataset.py` - reproducible standard-library build script
- `MANIFEST.json` - file checksums and dataset metadata

The output retains all 7,043 source records and all 21 original fields, then adds 12 documented analytical fields. No published KPI, finding, or recommendation is changed.
