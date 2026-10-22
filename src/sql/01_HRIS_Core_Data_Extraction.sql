-- =================================================================
-- ENTERPRISE HRIS DATA EXTRACTION & ATTRICTION ANALYSIS
-- Target: Relational Database Extraction (SAP HCM / Workday Staging)
-- =================================================================

WITH ActiveWorkforce AS (
    SELECT 
        e.EmpID,
        e.FirstName,
        e.LastName,
        e.BusinessUnit,
        e.DepartmentType,
        e.JobLevel,
        e.StartDate,
        e.BaseSalary,
        e.CompaRatio,
        e.PerformanceScore,
        d.DepartmentName,
        d.CostCenter
    FROM dbo.Employee_Master e
    LEFT JOIN dbo.Dim_Department d ON e.DepartmentCode = d.DepartmentCode
    WHERE e.EmployeeStatus = 'Active'
),
HighRiskFlightTalent AS (
    SELECT 
        EmpID,
        BusinessUnit,
        DepartmentName,
        BaseSalary,
        CompaRatio,
        PerformanceScore,
        -- High Performer & Underpaid Flag
        CASE 
            WHEN PerformanceScore >= 4 AND CompaRatio < 0.85 THEN 'CRITICAL_RETENTION_RISK'
            WHEN CompaRatio < 0.80 THEN 'HIGH_PAY_DISPARITY'
            ELSE 'STABLE'
        END AS Flight_Risk_Category
    FROM ActiveWorkforce
)
SELECT 
    BusinessUnit,
    DepartmentName,
    COUNT(EmpID) AS Total_Active_Headcount,
    ROUND(AVG(BaseSalary), 2) AS Avg_Base_Salary,
    ROUND(AVG(CompaRatio), 2) AS Avg_Compa_Ratio,
    SUM(CASE WHEN Flight_Risk_Category = 'CRITICAL_RETENTION_RISK' THEN 1 ELSE 0 END) AS High_Po_At_Risk_Count,
    -- Financial Exposure Estimate (1.5x Base Salary multiplier)
    SUM(CASE WHEN Flight_Risk_Category = 'CRITICAL_RETENTION_RISK' THEN BaseSalary * 1.5 ELSE 0 END) AS Attrition_Cost_Exposure
FROM HighRiskFlightTalent
GROUP BY BusinessUnit, DepartmentName
ORDER BY Attrition_Cost_Exposure DESC;
