# Patient Experience Study 
This project analyse the latest 12 months of patient survey data regarding the quality of service and medical treatment provided by the doctors. The first objective is to analyse which are the measurement metrics that are most influential on the overall patient satisfaction at the hospital. Secondly, the analysis aims to determine  <br>

# Dataset
* The timeline for the data used is over a period of 12 months each stored respectively in 12 excel document. All the documents also contain the same column headers. Each document also contains different spreadsheets.
* The column headers represent different quality metrics that are measured, for example overall satisfaction, level of empathy, doctor competency etc. The metrics have different rating levels. For example, the metric "respectful" has ratings from 1 to 5 and 99 (1:Very Poor to 5:Excellent, and 99:NA which refers to no response recorded)

# Tools used
* Rstudio
* Tableplus
* VSCode

# Data pipeline creation

## Setting up connection to SQL server
In this project,a data flow is assembled by creating a single Python program that reads in the 12 excel documents into the MySQL database. Only spreadsheets with the labels 'Inpatient', 'ip', 'warded', 'inp' and 'ip' are required to be extracted from the excel documents.

Variables are first created to store the list of the excel file paths, list of the required sheet names across the excel documents and a list of custom table names assigned to each excel document.

The for loop iterates through each file path, the sheets in each document and the custom table names. Once the loop is completed, the custom tables will each be populated with the data from the required spreadsheets.

```SQL
# Create a list of the different file paths where the excel sheets are stored
file_paths = ['//Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Jan.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Feb.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Mar.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Apr.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/May.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Jun.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Jul.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Aug.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Sep.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Oct.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Nov.xlsx',
               '/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw/Dec.xlsx']

sheet_names=['INPATIENT ','ip','INP ','WARDED','IN','warded','IN','WARDED','in','IN','InP','Inpatient']

# Create a MySQL connection
engine = create_engine(db_uri)

# Create a list of custom table names
custom_table_names = [
    "in01",
    "in02",
    "in03",
    "in04",
    "in05",
    "in06",
    "in07",
    "in08",
    "in09",
    "in10",
    "in11",
    "in12"
]

# Iterate through the three lists using zip
for file_path, sheet_name, custom_table_name in zip(file_paths, sheet_names, custom_table_names):
    # Read data from the Excel sheet
    data = pd.read_excel(file_path, sheet_name=sheet_name) 
    # Upload data to MySQL using the custom table name
    data.to_sql(custom_table_name, con=engine, if_exists="replace", index=False)
```

## Inserting data into SQL table
Once the loop is completed, the 12 tables are created in the SQL database server and each populated with data only from the selected spreadsheets ('Inpatient', 'ip', 'warded', 'inp' and 'ip').

<img src="https://github.com/bayyangjie/Patient-Experience-Study/blob/main/Images/tableplus_in01_in12.png?raw=true" width="25%">

<br>

# Data Cleaning
Prior to merging the tables, each table was first checked for data quality issues such as additional unknown columns and table 'in02' was found to contain many additional columns under the label 'Unnamed: ' and containing null values. Those columns were then dropped using ALTER TABLE and DROP functions.

```SQL
# Verify each table to check for data inconsistencies
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'in02'
AND COLUMN_NAME NOT IN (
    SELECT COLUMN_NAME
    FROM in02
    WHERE COLUMN_NAME IS NOT NULL
);
```
<br>

Table 'in02' with the additional unknown columns with the label 'Unnamed: ":

<img src="https://github.com/bayyangjie/Patient-Experience-Study/blob/main/Images/in02_unknown_columns.png?raw=true" width="100%">

<br>

Return the list of string outputs that indicate the column headers named 'Unnamed:' with purely NULL values in the table 'in02'

```SQL
SELECT CONCAT('ALTER TABLE in02 DROP COLUMN `', COLUMN_NAME, '`;')
FROM INFORMATION_SCHEMA.COLUMNS	   -- contains metadata about the columns inside table 'in02' within database 'ANL503_ECA'
WHERE TABLE_NAME = 'in02'		   -- filters the results to only columns that belong to the in02 table.
AND TABLE_SCHEMA = 'ANL503_ECA'		
AND COLUMN_NAME LIKE 'Unnamed:%';  -- includes columns where the name starts with 'Unnamed:'
```
<br>

Executing ALTER TABLE commands of columns with all NULL values in table 'in02'

```SQL
ALTER TABLE in02 DROP COLUMN `Unnamed: 9`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 10`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 11`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 12`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 13`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 14`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 15`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 16`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 17`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 18`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 19`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 20`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 21`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 22`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 23`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 24`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 25`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 26`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 27`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 28`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 29`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 30`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 31`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 32`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 33`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 34`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 35`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 36`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 37`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 38`;
ALTER TABLE in02 DROP COLUMN `Unnamed: 39`;
```

<br>

A custom table 'doc_survey' is created in the SQL server that will store the combined data of all 12 tables

```SQL
CREATE TABLE doc_survey (
X1 INT,
X2 INT,
X3 INT,
X4 INT,
X5 INT,
Y INT,
AGE INT,
GENDER INT,
WTYPE INT
);
```

<br>

UNION ALL statementis used to merge the 12 tables (from in01 to in12) and the combined data is inserted into the created table 'doc_survey'

```SQL
INSERT INTO doc_survey
SELECT * FROM in01
UNION ALL
SELECT * FROM in02
UNION ALL
SELECT * FROM in03
UNION ALL
SELECT * FROM in04
UNION ALL
SELECT * FROM in05
UNION ALL
SELECT * FROM in06
UNION ALL
SELECT * FROM in07
UNION ALL
SELECT * FROM in08
UNION ALL
SELECT * FROM in09
UNION ALL
SELECT * FROM in10
UNION ALL
SELECT * FROM in11
UNION ALL
SELECT * FROM in12;
```

<br>

# Data quality check on merged data

Verifying if the total number of rows in each column header tally with the total number of rows added up across the 12 excel files
```SQL
SELECT 
  COUNT(X1) AS Count_X1,
  COUNT(X2) AS Count_X2,
  COUNT(X3) AS Count_X3,
  COUNT(X4) AS Count_X4,
  COUNT(X5) AS Count_X5,
  COUNT(Y) AS Count_Y,
  COUNT(AGE) AS Count_AGE,
  COUNT(GENDER) AS Count_GENDER,
  COUNT(WTYPE) AS Count_WTYPE
FROM
	doc_survey;
```
<img src="https://github.com/bayyangjie/Patient-Experience-Study/blob/main/Images/total_number_of_rows.png?raw=true" width="70%">

<br>

Check for presence of NULL values in the columns of the merged data
```SQL
SELECT *
FROM doc_survey
WHERE 
	X1 IS NULL OR
	X2 IS NULL OR
	X3 IS NULL OR
	X4 IS NULL OR
	X5 IS NULL OR
	Y IS NULL OR
	AGE IS NULL OR
	GENDER IS NULL OR
	WTYPE IS NULL;
```
<img src="https://github.com/bayyangjie/Patient-Experience-Study/blob/main/Images/check%20for%20null%20values_X1_to_Y.png?raw=true" width="70%">

<br>

Check for invalid values in each column
The columns were checked to identify if there were any invalid values that exist apart from those in the original data.
```SQL
# Checking for invalid values in all columns

## Checking columns X1 to Y since they all have the same distinct values to check for
SELECT *
FROM doc_survey
WHERE 
	X1 NOT IN ('1', '2', '3', '4', '5', '99') OR
    X2 NOT IN ('1', '2', '3', '4', '5', '99') OR 
    X3 NOT IN ('1', '2', '3', '4', '5', '99') OR
    X4 NOT IN ('1', '2', '3', '4', '5', '99') OR 
    X5 NOT IN ('1', '2', '3', '4', '5', '99') OR
    Y NOT IN ('1', '2', '3', '4', '5', '99');

## Checking columns AGE, GENDER, WTPYE independently since they have different sets of distinc values to check against 
SELECT AGE
FROM doc_survey
WHERE AGE NOT IN ('1', '2', '3', '4', '5','6','7','8','99');

SELECT GENDER
FROM doc_survey
WHERE GENDER NOT IN ('1','2');

SELECT WTYPE
FROM doc_survey
WHERE WTYPE NOT IN ('1','2','3','4');
```
<br>

All the columns contained valid values except for the columns 'GENDER' and 'WTYPE'. The column 'GENDER' had values such as '99' and '4' while the column 'WTYPE' had invalid values such as '99'. These invalid values in both columns were cleaned up by converting them to NULLs.
```SQL
# Update columns GENDER, WTYPE to replace invalid values with NULL
SET SQL_SAFE_UPDATES = 0;

UPDATE doc_survey
SET
    GENDER = CASE WHEN GENDER IN ('99','4') THEN NULL ELSE GENDER END,
    WTYPE = CASE WHEN WTYPE IN ('99') THEN NULL ELSE WTYPE END;
```
<br>

The columns 'GENDER' and 'WTYPE' were verified again to ensure that only the valid values are present.
```SQL
SELECT DISTINCT(WTYPE)
FROM doc_survey;

SELECT DISTINCT(GENDER)
FROM doc_survey;
```
<img src="https://github.com/bayyangjie/Patient-Experience-Study/blob/main/Images/GENDER_distinct_values_verify.png?raw=true" width="25%">

<img src="https://github.com/bayyangjie/Patient-Experience-Study/blob/main/Images/WTYPE_distinct_values_verify.png?raw=true" width="25%">

# Linear Regression
A linear regresion model was ran using R and with the variable 'Y' (overall satisfaction by patients) set as the response variable and other variables as the predictor variables. The purpose was to understand the metrics that were most influential on the response variable 'Y'.

Out of all the other variables (X1/X2/X3/X4/X5/AGE/GENDER/WTYPE), X1 to X5 were selected as the predictor variables. The lm model results showed that they were the most impactful on the response variable 'Y' (patient overall satisfaction). 

## Establishing MySQL-R connection
A connection was established between MySQL and R using the RMySQL package to allow querying on the database in MySQL to be done in R.

Based on the regression output, it could be inferred that coefficients "X1" to "X5" are the most statistically significant and can potentially impact the response variable "Y" (overall patient satisfaction) the most. This can be seen from the *** sign of all 5 coefficients. Additionally, the p-values of all 5 coefficients are < 0.05, which represents statistical significance.

```R
# Establishing connnection to MySQL Databas
con <- dbConnect(MySQL(), user = "root", password = "123456", dbname = "ANL503")

# Reading "'doc_survey" table into R dataframe and naming the dataframe ‘dataframe’
dataframe <- dbReadTable(con, "doc_survey")
dataframe
```
## Analysis
In terms of the coefficient estimate values, it can be seen that 'X3' (level of empathy by doctor) has the most impact on the outcome variable since it has the highest coefficient estimate value of 0.373128. This means that for every increase in rating of X3, the overall satisfaction rating improves by 0.373128.

Regarding 'AGE' coefficient, it has a very low statistical significance as seen by the presence of one * . Although it has a p-value of < 0.05, the p-value is still significantly higher than those of 'X1' to 'X5'. The coefficient estimate of 'AGE' is also very small (0.010321) as compared to 'X1' to 'X5' coefficients, which suggests it has the smallest impact on the outcome amongst the statistically significant coefficients. 

On the other hand for GENDER/WTYPE, they are not statistically significant at all due to their p-values > 0.05. Logically, this makes sense as well because the survey data of these two coefficients is not related to the satisfaction levels.

<img src="https://github.com/bayyangjie/Patient-Experience-Study/blob/main/Images/regresssion_output.png?raw=true" width="50%"> 

# Performance-Impact Chart
The purpose of the performance-impact chart was to provide a deeper level of insights into how well doctors have fared in each of the performance metrics. Based on the bar plot, it shows that patients are overall satisfied with the service provided by doctors. This is shown by each of the performance metric X1 to X5 having high counts in the positive ratings of '4' (Good) and '5' (Excellent).

![image](https://github.com/user-attachments/assets/71933a57-73c9-4f48-b34a-98f2abb7e644)
