## Project Objectives
- Analyse the last 12 months of patient survey data in the patient experience department of a hospital.
- Dataset is a set of twelve excel files with each file containing multiple sheets. Each file corresponds to each month in the year.
- Assemble a data flow by creating a single python program that reads in specific sheets in each of the twelve excel documents and upload them into MySQL database
- Construct a single MySQL query to create a table that contains the required sheets from the twelve excel documents with each field name in the tbale following specified naming conventions
- Perform the necessary data cleaning/processing on the data in MySQL table

## Learning points
1) Assembled a data flow using Python to read in respective sheets from each of the twelve excel documents and upload all into Tableplus SQL database.
2) Constructed MySQL query to create a new table that contains all records from the twelve imported tables
3) Input 'NULL' as the value to replace missing/non-valid values
4) Further read the SQL data into R for linear regression analysis and visualization analysis <br> <br>

### Python: Combining data from multiple sources and creating connection to MySQL database

Combining selected sheets from each of the 12 excel files:
```
# Create a list of the different file paths where the excel sheets are stored
file_paths = ['/Users/ASUS/Desktop/raw/Jan.xlsx',
               '/Users/ASUS/Desktop/raw/Feb.xlsx',
               '/Users/ASUS/Desktop/raw/Mar.xlsx',
               '/Users/ASUS/Desktop/raw/Apr.xlsx',
               '/Users/ASUS/Desktop/raw/May.xlsx',
               '/Users/ASUS/Desktop/raw/Jun.xlsx',
               '/Users/ASUS/Desktop/raw/Jul.xlsx',
               '/Users/ASUS/Desktop/raw/Aug.xlsx',
               '/Users/ASUS/Desktop/raw/Sep.xlsx',
               '/Users/ASUS/Desktop/raw/Oct.xlsx',
               '/Users/ASUS/Desktop/raw/Nov.xlsx',
               '/Users/ASUS/Desktop/raw/Dec.xlsx']

sheet_names=['INPATIENT','ip','INP','WARDED','IN','warded','IN','WARDED','in','IN','InP','Inpatient']
```
Created a connection to MySQL database and imported the raw data into Tableplus:
```
# Create a MySQL connection
engine = create_engine(db_uri)
```

Created 12 custom table names to feed in the 12 respective excel files after importing:
```
# Create a list of custom tables names
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
```

Iterating through the three lists created:
```
# Iterate through the 3 lists using zip
for file_path, sheet_name, custom_table_name in zip(file_paths, sheet_names, custom_table_names):
    # Read data from the Excel sheet
    data = pd.read_excel(file_path, sheet_name=sheet_name) 
    # Upload data to MySQL using the custom table name
    data.to_sql(custom_table_name, con=engine, if_exists="replace", index=False)
```

Combined the data from all the 12 imported tables under a new table:
```
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

INSERT INTO doc_survey
SELECT * FROM in01
UNION ALL
SELECT * FROM in02_1
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

## Data cleaning

Checking for NULL values:
```
SELECT *
FROM doc_survey
WHERE (X1 IS NULL OR X2 IS NULL OR X3 IS NULL OR X4 IS NULL OR X5 IS NULL OR Y IS NULL OR AGE IS NULL OR GENDER IS NULL OR WTYPE IS NULL)
```

Checking if each column contains invalid values:
```
SELECT *
FROM doc_survey
WHERE
  X1 NOT IN ('1', '2', '3', '4', '5', '99')
  OR X2 NOT IN ('1', '2', '3', '4', '5', '99')
  OR X3 NOT IN ('1', '2', '3', '4', '5', '99')
  OR X4 NOT IN ('1', '2', '3', '4', '5', '99')
  OR X5 NOT IN ('1', '2', '3', '4', '5', '99')
  OR Y NOT IN ('1', '2', '3', '4', '5', '99')
  OR AGE NOT IN ('1', '2', '3', '4', '5','6','7','8','99')
  OR GENDER NOT IN ('1','2')
  OR WTYPE NOT IN ('1','2','3','4')
```

Updating the table to replace the empty/invalid values with NULL input:
```
UPDATE doc_survey
SET
  AGE = CASE WHEN AGE IS NULL THEN NULL ELSE AGE END,
  GENDER = CASE WHEN GENDER IS NULL OR GENDER IN ('99','4') THEN NULL ELSE GENDER END,
  WTYPE = CASE WHEN WTYPE IS NULL OR WTYPE='99' THEN NULL ELSE WTYPE END;
```
<br>

## R - Linear regression

Establishing connection between R and MySQL database and reading in the dataframe:
```
con <- dbConnect(MySQL(), user = "root", password = "bay123456", dbname = "ANL503")

dataframe <- dbReadTable(con, "doc_survey")
```

Running linear regression model and determining the magnitude of correlation of each response variable to variable 'Y' which represents overall satisfaction:
```
lm(Y ~ X1 + X2 + X3 + X4 + X5 + AGE + GENDER + WTYPE , dataframe) -> lm_sat
summary(lm_sat)
```
![Image 1](https://github.com/bayyangjie/Data-Wrangling/blob/main/Images/regression.png?raw=true)





