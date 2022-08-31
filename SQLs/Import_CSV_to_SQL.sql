CREATE DATABASE Chicago_taxi;
GO

USE Chicago_taxi;

SELECT *
INTO rides
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
	'Text;
	Database=G:\Programowanie\Analiza\Power BI\Moje\Projekt_Chicago_taxi\Data; ',
	'SELECT * FROM millionrows_taxi_chicago.csv');