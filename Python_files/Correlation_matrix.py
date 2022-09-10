#Import za pomocą sqlalchemy i pyodbc
import pandas as pd
from sqlalchemy import create_engine

#Creating SQL connection
my_engine = create_engine("mssql+pyodbc://@./Chicago_taxi?driver=SQL Server Native Client 11.0")

filepath = r"./output/correlation_matrix_output.xlsx"
rides_query = '''
    SELECT unique_key,
    taxi_id,
    CONVERT(DATETIME,
    	LEFT(trip_start_timestamp,
    		CHARINDEX(' UTC', trip_start_timestamp )-1)
    	) AS 'trip_start_timestamp',
    CONVERT(DATETIME, 
    	LEFT(trip_end_timestamp,
    		CHARINDEX(' UTC', trip_end_timestamp )-1)
    	) AS 'trip_end_timestamp',
    ISNULL(trip_seconds/60, 0) AS 'trip_minutes',
    ISNULL(trip_miles, 0) AS 'trip_miles',
    ISNULL(fare, 0) AS 'fare',
    ISNULL(tips, 0) AS 'tips',
    ISNULL(tolls, 0) AS 'tolls',
    ISNULL(extras, 0) AS 'extras',
    ISNULL(trip_total, 0) AS 'trip_total',
    CASE
    	WHEN ISNULL(trip_seconds/60, 0) = 0 THEN NULL
    	ELSE ISNULL(trip_total, 0)/ISNULL(trip_seconds/60, 0)
    	END AS 'rate per minute',
    CASE
    	WHEN ISNULL(trip_miles, 0) = 0 THEN NULL
    	ELSE ISNULL(trip_total, 0)/ISNULL(trip_miles, 0)
    	END AS 'rate per mile',
    CASE
    	WHEN ISNULL(CONVERT(FLOAT, trip_seconds)/(60*60), 0) = 0 THEN NULL
    	ELSE  ISNULL(trip_miles, 0)/ISNULL(CONVERT(FLOAT, trip_seconds)/(60*60), 0)
    	END AS 'speed [mil/h]',
    payment_type,
    ISNULL(company, 'Other companies') AS 'company'
    FROM rides
'''    

#Creation dataframe from sql query output
df_rides = pd.read_sql_query(rides_query, my_engine)
#Reduced dataframe only with metrics to be used in correlation matrix
df_rides2 = df_rides[['trip_minutes', 'trip_total', 'trip_miles', 'rate per minute',
                      'rate per mile', 'speed [mil/h]', 'company']]   
#Creation of dataframe with correlation matrix
rides_corr_matrix = df_rides2.corr()
#Save correlation matrix in xlsx file
rides_corr_matrix.to_excel(excel_writer=filepath)


