# Patient Experience Study 
This project analyse the latest 12 months of patient survey data regarding the quality of service and medical treatment provided by the doctors. The first objective is to analyse which are the measurement metrics that are most influential on the overall patient satisfaction at the hospital. Secondly, the analysis aims to determine  <br>

## Code files
Python 
* Establishing connection to MySQL <br>
https://github.com/bayyangjie/Data-Wrangling/blob/main/Python%20file <br>

SQL
* Merging the datasets and manipulating the merged database <br>
https://github.com/bayyangjie/Data-Wrangling/blob/main/SQL%20codes.sql <br>

R 
* Visualisation and Linear regression <br>
https://github.com/bayyangjie/Data-Wrangling/blob/main/RMarkdown%20file <br>

# About the data
* The timeline for the data used is over a period of 12 months and it is stored in twelve separate microsoft excel documents, one per calendar month. 
* Each column in the excel files represent different quality metrics that are measured, for example overall satisfaction, level of empathy, doctor competency etc. 
* Each metric also has different rating levels. For example, the metric "respectful" has ratings from 1 to 5 and 99 (1:Very Poor to 5:Excellent, and 99:NA which refers to no response recorded)

# Software tools used
* Rstudio
* Tableplus
* VSCode

# About the project
## Data pipeline creation
In this project, I assembled a data flow by creating a single Python program that reads in all the twelve datasets into the MySQL database. Tableplus was the database management tool used in this case. Once the datasets were imported into MySQL, I renamed each table which represents the different months with a different name. Using MySQL, I then constructed a query to create a new table that combined the data from all the twelve datasets. The data types of the column variables are then verified to ensure that they are correct. 

## Visualisation and Regression
After the data had been preprocessed in Tableplus, it was then imported into R for running a **linear regression model** as well as generating a **performance-impact bar plot**. The purpose of running a linear regression model was to evaluate which measurement metrics were the most influential to the response variable. <br>

* Regression <br>
Based on the lm() output, we can quickly infer that coefficients "X1" to "X5" are the most statistically significant and can potentially impact the response variable "Y" (overall patient satisfaction) the most. This can be seen from the *** sign of all 5 coefficients. Additionally, the p-values of all 5 coefficients are < 0.05, which represents statistical significance.

In terms of the coefficient estimate values, we can see that 'X3' (level of empathy by doctor) has the most impact on the outcome variable since it has the highest coefficient estimate value of 0.373128. This means that for every increase in rating of X3, the overall satisfaction rating improves by 0.373128.

![image](https://github.com/user-attachments/assets/862cd7d6-76e9-41f1-b412-4f3301f5a96a) <br> <br>

* Barplot visualisation <br>
The barplot is a performance-impact chart that shows the count of how well the doctors have fared in the measurement metrics X1 to X5. These were the only metrics used since the regression model has shown them to be the most impactful on the response variable. This plots provides a deeper level of insights as to how well doctors have fared in each of the performance metrics. Based on the bar plot visualisation, it shows that patients are overall very satisfied with the service provided by doctors as shown by '5' being 'Excellent' having the highest count for all five metrics.

![image](https://github.com/user-attachments/assets/71933a57-73c9-4f48-b34a-98f2abb7e644)




