# ☁️ Target Enterprise Cloud Architecture Specifications

## Executive Overview
This document outlines the target cloud-native architecture for scaling the **HRIS Workforce Predictive Analytics & Data Governance Framework** to enterprise volume using the Microsoft Azure & Databricks ecosystem, aligned with ISO 30414 reporting standards.

---

## 🏗️ End-to-End Data Pipeline Architecture (Medallion Pattern)

```text
[ SAP HCM / Workday ] 
          │
          ▼  (Batch ETL via Azure Data Factory)
[ BRONZE LAYER: Raw Data Lake ] ──> Azure Data Lake Storage Gen2 (Parquet / Uncleaned CSV)
          │
          ▼  (PySpark / M-Code Cleansing Pipelines)
[ SILVER LAYER: Curated & Standardized ] ──> Databricks Delta Lake (Validated Schema & Data Quality SLAs)
          │
          ▼  (Semantic Star-Schema & DAX Risk Modeling)
[ GOLD LAYER: Enterprise Analytics ] ──> Power BI Service (Import / DirectQuery + Dynamic RLS via Azure AD)

🛠️ Technical Layer Breakdown
1. Ingestion Layer (Azure Data Factory / Synapse)
Source Systems: SAP S/4HANA HCM, Workday, and regional CSV flat files.

Orchestration: Scheduled daily incremental refresh at 02:00 UTC via Azure Data Factory Integration Runtime.

Storage: Azure Data Lake Storage (ADLS) Gen2 in compressed Apache Parquet format for optimal storage cost and query speed.

2. Processing & Transformation Layer (Databricks / Delta Lake)
Bronze to Silver: Automated null imputation, structural key validation, and deduplication executed via PySpark jobs.

Data Quality SLAs: Automated validation rules asserting data completeness ($>98.5\%$) before promoting records to Gold layer.

3. Semantic & Serving Layer (Power BI Gold Layer)
Data Modeling: Star-Schema design with partitioned fact tables (Fact_Tenure, Fact_Compensation) and standardized dimensions (Dim_Employee, Dim_Organization).

Governance & RLS: Dynamic Row-Level Security bound to USERPRINCIPALNAME(), fully synchronized with Azure Active Directory (Microsoft Entra ID) security groups.

---