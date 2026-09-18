let
    // Source Ingestion from HRIS Master
    Source = Csv.Document(File.Contents("data/Data_Dictionary.csv"), [Delimiter=",", Columns=5, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    
    // Type Casting & Structural Key Hygiene
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{
        {"Field_Name", type text}, 
        {"Data_Type", type text}, 
        {"Source_System", type text}, 
        {"Governance_Rule", type text}, 
        {"Description", type text}
    }),
    
    // Data Cleaning Protocols
    #"Trimmed Text" = Table.TransformColumns(#"Changed Type", {{"Field_Name", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text", {{"Field_Name", Text.Clean, type text}})
in
    #"Cleaned Text"