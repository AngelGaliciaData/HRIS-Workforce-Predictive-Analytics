let
    // ================================================
    // 1. DYNAMIC CALENDAR DIMENSION (ISO Standard)
    // ================================================
    StartDate = #date(2020, 1, 1),
    EndDate = Date.From(DateTime.LocalNow()),
    DayCount = Duration.Days(EndDate - StartDate) + 1,
    DateList = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),
    
    TableFromIndex = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
    #"Typed Date" = Table.TransformColumnTypes(TableFromIndex, {{"Date", type date}}),
    
    // Calendar Attributes for HR Snapshot Aggregations
    #"Added Year" = Table.AddColumn(#"Typed Date", "Year", each Date.Year([Date]), Int64.Type),
    #"Added Month" = Table.AddColumn(#"Added Year", "Month", each Date.Month([Date]), Int64.Type),
    #"Added Month Name" = Table.AddColumn(#"Added Month", "Month_Name", each Date.MonthName([Date]), type text),
    #"Added YearMonth" = Table.AddColumn(#"Added Month Name", "YearMonth", each ([Year] * 100) + [Month], Int64.Type),
    #"Added Quarter" = Table.AddColumn(#"Added YearMonth", "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),

    // ================================================
    // 2. ORGANIZATIONAL HIERARCHY DIMENSION
    // ================================================
    // Standardizing Business Units & Cost Center Structures
    OrgSource = Table.FromRecords({
        [Department_Code = "HR-001", Department_Name = "People Operations", Business_Unit = "Corporate"],
        [Department_Code = "IT-002", Department_Name = "Enterprise Architecture", Business_Unit = "Technology"],
        [Department_Code = "FIN-003", Department_Name = "Financial Planning", Business_Unit = "Corporate"]
    }),
    #"Typed Org" = Table.TransformColumnTypes(OrgSource, {
        {"Department_Code", type text}, 
        {"Department_Name", type text}, 
        {"Business_Unit", type text}
    })
in
    #"Typed Org"