--This is where the data for the live insurance policies is extracted and added to the database
--It is also used to give statistics for how many live policies we have at any point, including
--the split between each policy type and when the most and least amount of policies are due for
--renewal. In combination with other tables it is used to see what months are the most and least
--profitable and renewal retention

--Sets the database
USE insurer_protect_db;
GO

--Resets the data in the tables affected so updated data can be added in
DELETE FROM tempinsurerprotectlivepolicies;
DELETE FROM tempinsurerprotect_nonstan_livepolicies;
GO

--Sets the variables used for getting the data files dynamically
DECLARE @time AS DATETIME = GETDATE();
DECLARE @today AS NVARCHAR(MAX) = FORMAT(@time,'d','no');
SELECT @today = REPLACE(''+@today+'','-','.');
DECLARE @month AS NVARCHAR(MAX) = MONTH(GETDATE());
DECLARE @year AS NVARCHAR(MAX) = YEAR(GETDATE());

--Goes through each file saved relating to the list of live policies and inserts the data into the
--Live Policy tables
DECLARE @i INT = 1
DECLARE @a VARCHAR(MAX) = ''
DECLARE @b VARCHAR(MAX) = ''
WHILE @i < 5
	BEGIN
		SET @b = 'C:\Directory\Database Text Files\Policy Lists\'+ @year +'\'+ @month +'\I-P '+ @i +' Policy List '+ @today +'.csv'
		SET @a = 'BULK INSERT tempinsurerprotectlivepolicies FROM '+@b+' WITH (FORMAT = ''CSV'', FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', TABLOCK, FIRSTROW = 2);'
		EXEC sys.sp_executesql @a
		SET @i = @i + 1
	END
--Checks data has been inserted
SELECT * FROM tempinsurerprotectlivepolicies;

SET @i = 1
SET @a = ''
SET @b = ''
WHILE @i < 5
	BEGIN
		SET @b = 'C:\Directory\Database Text Files\Policy Lists\'+ @year +'\'+ @month +'\IPN '+ @i +' Policy List '+ @today +'.csv'
		SET @a = 'BULK INSERT tempinsurerprotect_nonstan_livepolicies FROM '+@b+' WITH (FORMAT = ''CSV'', FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', TABLOCK, FIRSTROW = 2);'
		EXEC sys.sp_executesql @a
		SET @i = @i + 1
	END

SELECT * FROM tempinsurerprotect_nonstan_livepolicies;

--Converts data into correct datatypes while adding it into the main table
INSERT INTO insurerprotectlivepolicies(
	surname,
	firstname,
	companyname,
	client_reference,
	policy_type,
	policy_number,
	insurer,
	scheme,
	inception_date,
	renewal_date)
SELECT
	CAST(surname AS VARCHAR(MAX)) AS surname,
	CAST(firstname AS VARCHAR(MAX)) AS firstname,
	CAST(companyname AS VARCHAR(MAX)) AS companyname,
	CAST(client_reference AS INT) AS client_reference,
	CAST(policy_type AS VARCHAR(MAX)) AS policy_type,
	CAST(policy_number AS VARCHAR(MAX)) AS policy_number,
	CAST(insurer AS VARCHAR(MAX)) AS insurer,
	CAST(scheme AS VARCHAR(MAX)) AS scheme,
	CAST(inception_date AS DATE) AS inception_date,
	CAST(renewal_date AS DATE) AS renewal_date FROM tempinsurerprotectlivepolicies;
GO

INSERT INTO insurerprotect_nonstan_livepolicies(
	surname,
	firstname,
	companyname,
	client_reference,
	policy_type,
	policy_number,
	insurer,
	scheme,
	inception_date,
	renewal_date)
SELECT
	CAST(surname AS VARCHAR(MAX)) AS surname,
	CAST(firstname AS VARCHAR(MAX)) AS firstname,
	CAST(companyname AS VARCHAR(MAX)) AS companyname,
	CAST(client_reference AS INT) AS client_reference,
	CAST(policy_type AS VARCHAR(MAX)) AS policy_type,
	CAST(policy_number AS VARCHAR(MAX)) AS policy_number,
	CAST(insurer AS VARCHAR(MAX)) AS insurer,
	CAST(scheme AS VARCHAR(MAX)) AS scheme,
	CAST(inception_date AS DATE) AS inception_date,
	CAST(renewal_date AS DATE) AS renewal_date FROM tempinsurerprotect_nonstan_livepolicies;

SELECT * FROM insurerprotectlivepolicies;
SELECT * FROM insurerprotect_nonstan_livepolicies;