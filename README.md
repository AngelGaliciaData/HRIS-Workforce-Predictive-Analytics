# Enterprise HRIS & Predictive Workforce Analytics Framework

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Data_Analysis_Expressions-blue?style=for-the-badge)
![Power Query](https://img.shields.io/badge/Power_Query-M_Code-green?style=for-the-badge)
![Governance](https://img.shields.io/badge/Governance-ISO_30414-purple?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-brightgreen?style=for-the-badge)

## Executive Summary
This enterprise repository contains an end-to-end **HRIS Data Governance & Predictive Analytics Framework** designed to bridge core workforce master data (SAP HCM / Employee Central) with advanced BI modeling. 

The architecture tackles structural attrition risks, HC variance tracking, and predictive flight-risk modeling by enforcing strict ETL data quality protocols, star-schema data modeling, and robust DAX logic aligned with ISO 30414 human capital reporting guidelines.

---
## Technical Architecture

```text
HRIS-Workforce-Predictive-Analytics/
├── architecture/
│   ├── Cloud_Pipeline_Specs.md             # Target Azure/Databricks Medallion Architecture
│   └── User_Stories_Backlog.md             # Data Product Agile Backlog (Jira User Stories)
├── data/
│   ├── Data_Dictionary.csv                 # Standardized HRIS Data Catalog & Metadata Definitions
│   └── HR_Simulated_Dataset.csv            # 3,000-Row Operational HRIS Dataset
├── docs/
│   └── Architecture_Blueprint.md           # Data Lineage, Security & RACI Governance Matrix
├── src/
│   ├── powerquery_m/
│   │   ├── ETL_Employee_Master.m           # M-Code: Data Hygiene, Deduplication & Type Casting
│   │   └── ETL_Dim_Tables.m                # M-Code: Dynamic Calendar & Org Hierarchy Dimensions
│   ├── dax_measures/
│   │   ├── 01_Base_Metrics.dax             # Active HC, Frictional Turnover & FTE Ratios
│   │   ├── 02_Risk_Predictive.dax          # Early-Flight Risk Index & Tenure Vulnerability
│   │   ├── 03_Governance_Metadata.dax      # Data Quality Metrics & Row-Level Audit Flags
│   │   └── 04_Financial_Performance_Matrix.dax # High-Performer Risk & Pay Parity Matrix
│   ├── rls/
│   │   └── Row_Level_Security_Roles.dax    # Dynamic Row-Level Security Rules (USERPRINCIPALNAME)
│   └── sql/
│       ├── 01_HRIS_Core_Data_Extraction.sql  # SQL: Active Headcount & $6M Attrition Risk Modeling
│       └── 02_Workday_Pipeline_Debugging_CTE.sql # SQL: Window Functions & Data Quality Audit
├── .gitignore                              # BI Cache & PBIX Exclusion Policy
├── LICENSE                                 # MIT Open Source License
└── README.md                               # Master Project Documentation
```

---
## Security & Governance Architecture (RLS)

```
// =================================================================
// ROLE 1: HR Business Partner (HRBP)
// Restricts data visibility to the HRBP's assigned Department
// =================================================================
[Department_Code] = LOOKUPVALUE(
    User_Security[Department_Code],
    User_Security[UserPrincipalName],
    USERPRINCIPALNAME()
)

// =================================================================
// ROLE 2: Regional Director
// Restricts data visibility by Country / Geographical Region
// =================================================================
[Country_Code] = LOOKUPVALUE(
    User_Security[Country_Code],
    User_Security[UserPrincipalName],
    USERPRINCIPALNAME()
)

// =================================================================
// ROLE 3: C-Suite / Executive (Full Access)
// No DAX filter applied (Unrestricted global access across the org)
// =================================================================
```


---
## ☁️ Enterprise Cloud Target Architecture (Azure / Databricks / Power BI)

While this framework contains a fully functional local Power BI & M-Code engine, it is designed to seamlessly scale into cloud-native enterprise environments:

```text
[ SAP S/4HANA / Workday ] 
           │
           ▼ (Azure Data Factory)
[ ADLS Gen2 Data Lake ] ──► [ Databricks Delta Lake ] ──► [ Power BI Gold Layer ]
  (Bronze: Raw Ingestion)     (Silver: PySpark Cleaning)    (Gold: Star Schema & RLS)

```
📌 **Architectural Specifications & Product Backlog:**

* [Technical Cloud Pipeline Specs](architecture/Cloud_Pipeline_Specs.md)
* [Product Owner Agile Backlog (User Stories)](architecture/User_Stories_Backlog.md)

---

## 🗄️ Relational SQL Engine & Data Quality Audit (Workday / SAP Staging)

To ensure total data parity and bridge relational database extractions with executive BI models, this framework embeds native ANSI SQL scripts for high-volume delta loads:

```sql
-- Workday Delta Load Debugging & Deduplication via Window Functions
WITH RankedWorkdayIngestion AS (
    SELECT EmpID, ADEmail, DepartmentCode, LastModifiedDate,
           ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY LastModifiedDate DESC) AS RowNum
    FROM staging.Workday_Daily_Delta_Extract
)
SELECT * FROM RankedWorkdayIngestion WHERE RowNum = 1;

```


📌 Functional SQL Modules:

📄 [01_HRIS_Core_Data_Extraction.sql — Active Headcount & $6M Attrition Risk Modeling.](sql/01_HRIS_Core_Data_Extraction.sql)


📄 [02_Workday_Pipeline_Debugging_CTE.sql — Window Functions (ROW_NUMBER) & Data Quality Audit.](src\02_Workday_Pipeline_Debugging_CTE.sql)

---
## Core HRIS Engine Capabilities

* **Data Governance & Hygiene:** Native M-Code pipelines handling null imputation, structural key validation, and historical snapshotting.
* **Predictive Risk Modeling:** Custom DAX measures computing multi-factor risk scores based on tenure thresholds, performance-to-pay ratios, and historical attrition patterns.
* **Workforce Auditability:** Built-in metadata measures designed to audit row-level integrity and source-to-target reconciliation directly within Power BI dashboards.

---
## Author & Governance
**Ángel Galicia**  
*HRIS Operations, Data Governance & People Analytics Specialist*  
[GitHub Profile](https://github.com/JgaliciaH) | [LinkedIn](https://linkedin.com)
