# HRIS Data Architecture & Governance Blueprint

## 1. Data Lineage & Pipeline Overview
* **Source Systems:** SAP HCM (Core Master Data), SuccessFactors Employee Central.
* **ETL Engine:** Power Query (M-Code) executing structural key creation, null imputation, and data type casting.
* **Data Model:** Star Schema (Fact Table: `Fact_Employee_Snapshot`, Dimensions: `Dim_Calendar`, `Dim_Organization`).
* **Consumption Layer:** Power BI Enterprise Dashboard with Row-Level Security (RLS).

---

## 2. RACI Governance Matrix

| HRIS Lifecycle Stage | HR Operations | Data Analytics Engineer | Business Unit Lead | System Admin |
| :--- | :--- | :--- | :--- | :--- |
| **Data Capture & Entry** | Responsible | Accountable | Informed | Consulted |
| **ETL & Transformation** | Informed | Responsible | Informed | Accountable |
| **DAX Modeling & Metrics** | Consulted | Responsible | Accountable | Informed |
| **RLS & Security Access** | Consulted | Responsible | Informed | Accountable |

---

## 3. Security & Data Protection Policy
* **PII Anonymization:** Employee identifiers masked via internal hash keys before model processing.
* **Granular Access Control:** Dynamic RLS restricting salary and flight-risk visibility based on organizational hierarchy roles.
* **Data Retention:** Historical snapshots retained in accordance with enterprise workforce audit compliance.