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
INTO #rides_temp
FROM rides

SELECT *
FROM #rides_temp
EXCEPT
SELECT *
FROM #rides_temp
WHERE trip_miles > 0 AND
trip_minutes = 0;





	