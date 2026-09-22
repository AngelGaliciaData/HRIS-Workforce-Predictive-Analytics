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
├── data/
│   ├── Data_Dictionary.csv                 # Standardized HRIS Data Catalog & Metadata Definitions
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
│   └── rls/
│       └── Row_Level_Security_Roles.dax    # Dynamic Row-Level Security Rules (USERPRINCIPALNAME)
├── .gitignore                              # BI Cache & PBIX Exclusion Policy
├── LICENSE                                 # MIT Open Source License
└── README.md                               # Master Project Documentation
```

---
## Security & Governance Architecture (RLS)

// =================================================================
// ROLE 1: HR Business Partner (HRBP)
// Restringe la visibilidad al Departamento asignado al HRBP
// =================================================================
[Department_Code] = LOOKUPVALUE(
    User_Security[Department_Code],
    User_Security[UserPrincipalName],
    USERPRINCIPALNAME()
)

// =================================================================
// ROLE 2: Regional Director
// Restringe la vista por País / Región Geográfica
// =================================================================
[Country_Code] = LOOKUPVALUE(
    User_Security[Country_Code],
    User_Security[UserPrincipalName],
    USERPRINCIPALNAME()
)

// =================================================================
// ROLE 3: C-Suite / Executive (Full Access)
// Sin filtro DAX aplicado (acceso global a toda la organización)
// =================================================================

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
