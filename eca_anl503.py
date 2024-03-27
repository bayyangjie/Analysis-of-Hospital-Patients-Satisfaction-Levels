import pymysql
from sqlalchemy import create_engine
import pandas as pd

mysqlid = 'root'
mysqlpw = 'bay123456'
mysqldb = 'anl503'
db_uri = "mysql+pymysql://{0}:{1}@localhost:3306/{2}".format(mysqlid, mysqlpw,
mysqldb)

engine = create_engine(db_uri)

files_and_sheets = [
    {'/Users/ASUS/Library/CloudStorage/OneDrive-Personal/Desktop/SUSS/ANL503/ECA/raw': 'Jan.xlsx', 'INPATIENT': 'Sheet1'}, 
    # Add more files and sheet names as needed
]

dataframes=[] 

for item in files_and_sheets:
    file_name = item['file']
    sheet_name = item['sheet']
    df = pd.read_excel(file_name, sheet_name=sheet_name)
    dataframes.append(df) 