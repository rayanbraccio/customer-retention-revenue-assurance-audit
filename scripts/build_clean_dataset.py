#!/usr/bin/env python3
"""Build the case-study-aligned cleaned IBM Telco churn dataset."""

from __future__ import annotations

import argparse
import csv
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
from pathlib import Path

SOURCE_COLUMNS = [
    "customerID", "gender", "SeniorCitizen", "Partner", "Dependents", "tenure",
    "PhoneService", "MultipleLines", "InternetService", "OnlineSecurity",
    "OnlineBackup", "DeviceProtection", "TechSupport", "StreamingTV",
    "StreamingMovies", "Contract", "PaperlessBilling", "PaymentMethod",
    "MonthlyCharges", "TotalCharges", "Churn"
]

ENGINEERED_COLUMNS = [
    "TotalCharges_clean", "is_churned", "tenure_band", "charge_band",
    "flag_early_life_0_6", "flag_month_to_month", "flag_electronic_check",
    "flag_fiber_optic", "flag_no_tech_support",
    "flag_fiber_no_tech_support", "flag_first_12m_mtm_fiber",
    "flag_priority_segment",
]

ALLOWED = {
    "gender": {"Female", "Male"},
    "SeniorCitizen": {"0", "1"},
    "Partner": {"No", "Yes"},
    "Dependents": {"No", "Yes"},
    "PhoneService": {"No", "Yes"},
    "MultipleLines": {"No", "No phone service", "Yes"},
    "InternetService": {"DSL", "Fiber optic", "No"},
    "OnlineSecurity": {"No", "No internet service", "Yes"},
    "OnlineBackup": {"No", "No internet service", "Yes"},
    "DeviceProtection": {"No", "No internet service", "Yes"},
    "TechSupport": {"No", "No internet service", "Yes"},
    "StreamingTV": {"No", "No internet service", "Yes"},
    "StreamingMovies": {"No", "No internet service", "Yes"},
    "Contract": {"Month-to-month", "One year", "Two year"},
    "PaperlessBilling": {"No", "Yes"},
    "PaymentMethod": {
        "Bank transfer (automatic)", "Credit card (automatic)",
        "Electronic check", "Mailed check"
    },
    "Churn": {"No", "Yes"},
}

def money(value: Decimal) -> str:
    return str(value.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP))

def tenure_band(value: int) -> str:
    if 0 <= value <= 6:
        return "0-6"
    if value <= 12:
        return "7-12"
    if value <= 24:
        return "13-24"
    if value <= 36:
        return "25-36"
    if value <= 48:
        return "37-48"
    if value <= 60:
        return "49-60"
    if value <= 72:
        return "61-72"
    raise ValueError(f"tenure outside expected range 0-72: {value}")

def charge_band(value: Decimal) -> str:
    if value < Decimal("35"):
        return "18-35"
    if value < Decimal("55"):
        return "35-55"
    if value < Decimal("75"):
        return "55-75"
    if value < Decimal("95"):
        return "75-95"
    return "95+"

def build(input_path: Path, output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    rows = []

    with input_path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames != SOURCE_COLUMNS:
            raise ValueError(
                f"Unexpected schema. Expected {SOURCE_COLUMNS}; got {reader.fieldnames}"
            )

        for row_number, raw in enumerate(reader, start=2):
            row = {k: (v.strip() if v is not None else "") for k, v in raw.items()}

            for column, accepted in ALLOWED.items():
                if row[column] not in accepted:
                    raise ValueError(
                        f"Row {row_number}: invalid {column}={row[column]!r}"
                    )

            if not row["customerID"]:
                raise ValueError(f"Row {row_number}: blank customerID")

            try:
                senior = int(row["SeniorCitizen"])
                tenure = int(row["tenure"])
                monthly = Decimal(row["MonthlyCharges"])
            except (ValueError, InvalidOperation) as exc:
                raise ValueError(f"Row {row_number}: invalid numeric value") from exc

            total_raw = row["TotalCharges"]
            if total_raw == "":
                if tenure != 0:
                    raise ValueError(
                        f"Row {row_number}: blank TotalCharges with tenure={tenure}"
                    )
                total_clean = Decimal("0")
                total_source = ""
            else:
                total_clean = Decimal(total_raw)
                total_source = money(total_clean)

            is_churned = int(row["Churn"] == "Yes")
            is_mtm = int(row["Contract"] == "Month-to-month")
            is_echeck = int(row["PaymentMethod"] == "Electronic check")
            is_fiber = int(row["InternetService"] == "Fiber optic")
            is_no_support = int(row["TechSupport"] == "No")
            is_early = int(tenure <= 6)

            cleaned = dict(row)
            cleaned["SeniorCitizen"] = str(senior)
            cleaned["tenure"] = str(tenure)
            cleaned["MonthlyCharges"] = money(monthly)
            cleaned["TotalCharges"] = total_source
            cleaned.update({
                "TotalCharges_clean": money(total_clean),
                "is_churned": str(is_churned),
                "tenure_band": tenure_band(tenure),
                "charge_band": charge_band(monthly),
                "flag_early_life_0_6": str(is_early),
                "flag_month_to_month": str(is_mtm),
                "flag_electronic_check": str(is_echeck),
                "flag_fiber_optic": str(is_fiber),
                "flag_no_tech_support": str(is_no_support),
                "flag_fiber_no_tech_support": str(int(is_fiber and is_no_support)),
                "flag_first_12m_mtm_fiber": str(
                    int(tenure <= 12 and is_mtm and is_fiber)
                ),
                "flag_priority_segment": str(
                    int(is_mtm and is_echeck and is_fiber and is_no_support)
                ),
            })
            rows.append(cleaned)

    if len(rows) != 7043:
        raise AssertionError(f"Expected 7,043 rows; found {len(rows):,}")

    ids = [row["customerID"] for row in rows]
    if len(set(ids)) != 7043:
        raise AssertionError("Expected 7,043 unique customer IDs")

    blanks = [row for row in rows if row["TotalCharges"] == ""]
    if len(blanks) != 11 or any(int(row["tenure"]) != 0 for row in blanks):
        raise AssertionError(
            "Expected 11 blank TotalCharges values, all with tenure=0"
        )

    churned = sum(int(row["is_churned"]) for row in rows)
    gross_mrr = sum(Decimal(row["MonthlyCharges"]) for row in rows)
    churned_mrr = sum(
        Decimal(row["MonthlyCharges"])
        for row in rows
        if row["is_churned"] == "1"
    )
    priority = [row for row in rows if row["flag_priority_segment"] == "1"]
    priority_churned = sum(int(row["is_churned"]) for row in priority)
    priority_mrr = sum(
        Decimal(row["MonthlyCharges"])
        for row in priority
        if row["is_churned"] == "1"
    )

    assert churned == 1869
    assert gross_mrr == Decimal("456116.60")
    assert churned_mrr == Decimal("139130.85")
    assert len(priority) == 1138
    assert priority_churned == 716
    assert priority_mrr == Decimal("61358.05")

    with output_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=SOURCE_COLUMNS + ENGINEERED_COLUMNS,
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    build(args.input, args.output)

if __name__ == "__main__":
    main()
