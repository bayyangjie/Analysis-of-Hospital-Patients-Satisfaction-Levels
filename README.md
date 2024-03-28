## Project Objectives
Analyse the last 12 months of patient survey data in the patient experience department of a hospital. The dataset is stored in twelve separate Microsoft Excel documents, one per calendar month. 

## What was done
1) Assembled a data flow using Python to read in respective sheets from each of the twelve excel documents and upload all into Tableplus SQL database.
2) Constructed MySQL query to create a new table that contains all records from the twelve imported tables
3) Input 'NULL' as the value to replace missing/non-valid values
4) Further read the SQL data into R for linear regression analysis and visualization analysis
