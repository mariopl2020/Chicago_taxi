USE Chicago_taxi;
GO 

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
	trip_seconds,
	trip_miles,
	fare,
	tips,
	tolls, 
	extras,
	trip_total,
	payment_type,
	ISNULL(company, 'Other companies') AS 'company'
  FROM rides