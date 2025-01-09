-- Cleaning up table 'in02' to remove the extra columns that have blank data and some columns also have unknown data in some of the cells --
-- Extracted only the required columns and created a new table from 'in02' --
CREATE TABLE in02_1 AS 
SELECT X1,X2,X3,X4,X5,Y,AGE,GENDER,WTYPE
FROM in02;

-- Creating "doc_survey" table by using UNION ALL to include duplicates in the count --
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

-- Verifying number of records per column in 'doc_survey' table --
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

-- retrieving the sum of records of each column of all 12 imported tables --
-- purpose to confirm that new ‘doc_survey' table contains the correct number of records per column --
SELECT
  COUNT(X1) AS X1_Count,
  COUNT(X2) AS X2_Count,
  COUNT(X3) AS X3_Count,
  COUNT(X4) AS X4_Count,
  COUNT(X5) AS X5_Count,
  COUNT(Y) AS Y_Count,
  COUNT(AGE) AS AGE_Count,
  COUNT(GENDER) AS GENDER_Count,
  COUNT(WTYPE) AS WTYPE_Count
FROM (
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
  SELECT * FROM in12
) AS count_per_col;

-- Checking for NULL values in 'doc_survey' TABLE --
SELECT *
FROM doc_survey
WHERE (X1 IS NULL OR X2 IS NULL OR X3 IS NULL OR X4 IS NULL OR X5 IS NULL OR Y IS NULL OR AGE IS NULL OR GENDER IS NULL OR WTYPE IS NULL);

-- Checking if each column contains values that are not from the specified options in Table 1 --
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
  OR WTYPE NOT IN ('1','2','3','4');

-- Checking the invalid values in ‘GENDER’ and ‘WTYPE’ columns --
SELECT GENDER
FROM doc_survey
WHERE GENDER NOT IN ('1','2');

SELECT WTYPE
FROM doc_survey
WHERE WTYPE NOT IN ('1','2','3','4');

-- Count number of NULL records in AGE/GENDER/WTYPE columns --
SELECT
    COUNT(CASE WHEN AGE IS NULL THEN 1 END) AS AGE,
    COUNT(CASE WHEN GENDER IS NULL THEN 1 END) AS GENDER,
    COUNT(CASE WHEN WTYPE IS NULL THEN 1 END) AS WTYPE
FROM doc_survey;

-- Count number of records in ‘GENDER’ & ‘WTYPE’ columns with value = 99 --
SELECT
    COUNT(CASE WHEN GENDER = '99' THEN 1 END) AS GENDER,
    COUNT(CASE WHEN WTYPE = '99' THEN 1 END) AS WTYPE
FROM doc_survey;

-- Updating doc_survey table to replace empty/invalid values with NULL in AGE/GENDER/WTYPE columns --
UPDATE doc_survey
SET
  AGE = CASE WHEN AGE IS NULL THEN NULL ELSE AGE END,
  GENDER = CASE WHEN GENDER IS NULL OR GENDER IN ('99','4') THEN NULL ELSE GENDER END,
  WTYPE = CASE WHEN WTYPE IS NULL OR WTYPE='99' THEN NULL ELSE WTYPE END;

-- Checking the data type of the values in AGE/GENBDER/WTYPE columns --
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA ="ANL503"
  AND TABLE_NAME = 'doc_survey'
  AND COLUMN_NAME IN ('X1','X2','X3','X4','X5','Y','AGE','GENDER','WTYPE');

-- Verifying the number of NULL values in AGE/GENDER/WTYPE columns --
SELECT
  SUM(CASE WHEN AGE IS NULL THEN 1 ELSE 0 END) AS NULL_AGE_count,
  SUM(CASE WHEN GENDER IS NULL THEN 1 ELSE 0 END) AS NULL_GENDER_count,
  SUM(CASE WHEN WTYPE IS NULL THEN 1 ELSE 0 END) AS NULL_WTYPE_count
FROM doc_survey;

-- Verifying that all values = 99 are replaced --
SELECT GENDER, WTYPE
FROM doc_survey
WHERE '99' IN (GENDER, WTYPE);

-- Checking if there are non-integer data types in each column --
SELECT DISTINCT X1,X2,X3,X4,X5,Y,AGE,GENDER,WTYPE
FROM doc_survey
WHERE 
	X1 NOT REGEXP '^[0-9]+$'
	OR X2 NOT REGEXP '^[0-9]+$'
	OR X3 NOT REGEXP '^[0-9]+$'
	OR X4 NOT REGEXP '^[0-9]+$'
	OR X5 NOT REGEXP '^[0-9]+$'
	OR Y NOT REGEXP '^[0-9]+$'
	OR AGE NOT REGEXP '^[0-9]+$'
	OR GENDER NOT REGEXP '^[0-9]+$'
	OR WTYPE NOT REGEXP '^[0-9]+$';