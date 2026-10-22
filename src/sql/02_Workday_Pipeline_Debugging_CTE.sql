-- =================================================================
-- WORKDAY INTEGRATION DEBUGGING & DATA QUALITY AUDIT
-- Resolves: Overnight Delta Load Errors & Duplicate Employee Records
-- =================================================================

WITH RankedWorkdayIngestion AS (
    SELECT 
        EmpID,
        ADEmail,
        DepartmentCode,
        EmployeeStatus,
        LastModifiedDate,
        -- Window function to keep only the latest record sent by Workday API
        ROW_NUMBER() OVER (
            PARTITION BY EmpID 
            ORDER BY LastModifiedDate DESC
        ) AS RowNum
    FROM staging.Workday_Daily_Delta_Extract
),
CleanedDeltaIngest AS (
    SELECT 
        EmpID,
        ADEmail,
        DepartmentCode,
        EmployeeStatus,
        LastModifiedDate
    FROM RankedWorkdayIngestion
    WHERE RowNum = 1 -- Eliminate duplicate extracts sent during overnight refresh
)
-- Data Quality Audit Check before promoting to Gold Layer
SELECT 
    c.EmpID,
    c.ADEmail,
    c.DepartmentCode,
    CASE 
        WHEN c.DepartmentCode IS NULL THEN 'ORPHAN_DEPARTMENT'
        WHEN c.ADEmail IS NULL THEN 'MISSING_CORPORATE_EMAIL'
        ELSE 'AUDIT_PASSED'
    END AS Data_Quality_Flag
FROM CleanedDeltaIngest c
WHERE c.DepartmentCode IS NULL OR c.ADEmail IS NULL;
