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

## R - Linear regression/Visual plot

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

Based on the lm() output, we can infer that coefficients "X1" to "X5" are the most statistically significant and can potentially impact the outcome variable "Y" the most. This can be seen from the *** sign of all 5 coefficients. Additionally, the p-values of all 5 coefficients are < 0.05, which represents statistical significance.

In terms of the coefficient estimate values, we can see that 'X3' has the most impact on the outcome variable since it has the highest coefficient estimate value of 0.373128. This means that for every increase in rating of X3, the overall satisfaction rating improves by 0.373128.

Regarding 'AGE' coefficient, it has a very low statistical significance as seen by the presence of one asterisk '*' symbol. Despite a p-value of < 0.05, the p-value is still significantly higher than those of 'X1' to 'X5'. The coefficient estimate of 'AGE' is also very small (0.010321) as compared to 'X1' to 'X5' coefficients, which suggests it has the smallest impact on the outcome amongst the statistically significant coefficients. 

On the other hand for GENDER/WTYPE, they are not statistically significant at all due to their p-values > 0.05. Logically, this makes sense as well because the survey data of these two coefficients is not related to the satisfaction levels. <br> <br>

Checking correlation level between outcome variable and each independent variable
```
cor(dataframe$X1 , dataframe$Y) 
cor(dataframe$X2 , dataframe$Y) 
cor(dataframe$X3 , dataframe$Y) 
cor(dataframe$X4 , dataframe$Y) 
cor(dataframe$X5 , dataframe$Y) 
cor(dataframe$AGE , dataframe$Y) 
``
[1] 0.8652688
[1] 0.8915433
[1] 0.9129154
[1] 0.8973897
[1] 0.9105011
[1] NA
```
From the correlation output, we can also see that ‘X3’ has the highest correlation coefficient of 0.9129154 which further supports that it has the most impact on the outcome variable ‘Y’.

Performance impact bar plot visualisation
```
# Create a bar plot without default x-axis labels
# xaxt='n' removes the default axis so that a custom x-axis with labels can be added
# axes = FALSE remove the top and right borders while keeping the y-axis
plot(results$Count ~ seq_along(results$Column), type = "h", lwd = 10 ,col = "blue", xlab = "Field Names", ylab = "Count" , xaxt = "n", ylim=c(8900,9600), axes=FALSE)

# Adding main and sub titles
title(main = "Performance Impact Chart\nNumber of excellent (5) ratings for X1 to X5", line = 1, cex.main = 1)

# Add custom x-axis labels
axis(1, at = seq_along(results$Column), labels = results$Column)

# axis(2, ...) specifies that you're customizing the y-axis
# las = 2 specifies the orientation of the labels on the y-axis. In this case, las = 2 indicates vertical orientation
# tick = TRUE specifies that you want to display tick marks on the y-axis. By default, tick is set to TRUE.
axis(2, tick = TRUE, las = 2)  

# Add labels on top of each bar
text(seq_along(results$Column), results$Count, labels = results$Count, pos = ifelse(results$Count > 0, 3, 1), cex = 0.8, col = "red")
```
![R_performance_impact_plot](https://github.com/bayyangjie/Data-Wrangling/assets/153354426/13e167e2-5fb2-4286-bfa7-f91db9fbe9e1)

Based on the performance-impact bar plot shown below, it shows that warded patients have rated their doctors very highly with an 'excellent' rating of '5' in terms of performance areas of respectfulness(X1), competency(X2), empathy(X3), listens well(X4), explains and update well(X5). The 'Good' rating '4' is the next highest in each performance area. Both of these ratings also form the bulk of ratings as compared to the other rating levels of 1,2,3,4,99. Thus, this suggests that patients have had a good overall impression of doctors in the hospital when they were warded. 

```{r, fig.width=22, fig.height=12}
# Define data
data <- data.frame(
  X1 = c(20, 31, 748, 6544, 9475, 890),
  X2 = c(18, 38, 787, 6477, 9381, 1007),
  X3 = c(34, 52, 918, 6570, 9185, 949),
  X4 = c(36, 72, 976, 6682, 8910, 1032),
  X5 = c(37, 69, 992, 6638, 8976, 996)
)

# Define colors for each row label
colors <- c("red", "green", "blue", "orange", "purple" , "grey")

# Set plot margins
par(mar = c(5, 5, 4, 2) + 0.1)

# Plot
plot(1, type = "n", xlim = c(0.5, ncol(data) + 0.5), ylim = c(0, max(data)), ylab = "Count", main = "Counts of distinct ratings for each field name" , xaxt = "n" , cex.lab = 1.8 , cex.axis = 1.5 , cex.main = 1.9)

# Loop through each column
for (i in 1:ncol(data)) {
  # Get counts for the current column
  counts <- data[, i]
  
  # Calculate the number of bars to plot
  num_bars <- length(counts)
  
  # Calculate the width of each bar
  bar_width <- 0.8 / num_bars  # Adjust width as needed
  
  # Calculate the x-positions for the bars
  x_positions <- i - 0.4 + (1:num_bars) * bar_width
  
  # Plot bars for each value in the current column
  for (j in 1:num_bars) {
    bar_height <- counts[j]
    rect(x_positions[j], 0, x_positions[j] + bar_width, bar_height, col = colors[j], border = "black")
    text(x_positions[j] + bar_width / 2, bar_height, labels = counts[j], pos = 3, cex = 1.4)
  }
}

# Add x-axis labels as column names
# The 'cex.axis' argument here adjusts the text size of the x-axis tick mark labels separately
axis(1, at = 1:ncol(data), labels = paste0("X", 1:ncol(data)), cex.axis = 1.5)  

# Define legend labels
legend_labels <- c("1", "2", "3", "4", "5", "99")

# Add legend with adjusted position and custom labels
legend("topleft", legend = legend_labels, fill = colors, bg = "white", cex = 1.4)
```

![r_plot](https://github.com/bayyangjie/Data-Wrangling/assets/153354426/5de4c741-13ef-40d2-8bf0-c213dcfca6b1)

