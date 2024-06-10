--This is the script used to import data into the database, clean and match the data to a
--list of payments and records and stores those in separate CSV files in the shared drive
--The data is collected from calculations from staff members in the firm as well as 
--transactions recorded on the system used. Unfortunately the information cannot be
--extracted from the server used directly due to the software set up (of which is very old)
--and the company who provide the software not allowing direct acces either. Luckily most
--of the data can be extracted from the system which is what this database framework is for

USE insurer_protect_db;
GO

--Resets the tables that will have updated data added to it. The raw data is on the "Temp Tables".
--The reason for this is the algorithm checks all transactions whether they need to be on there or not
--relative to other transactions. There may be fringe cases where an entry in one instance would not be
--kept but in the next instance would be.

DELETE FROM policy_info;
DELETE FROM client_info;

--Sets up directories for backup data incase of errors
DECLARE @command NVARCHAR(1000)
DECLARE @time AS DATETIME = GETDATE();
DECLARE @today AS NVARCHAR(MAX) = FORMAT(@time,'d','no');
SELECT @today = REPLACE(''+@today+'','-','.');
SET @command = 'C:\Directory\Database Text Files\Backed Up Databases\'+@today
EXEC master.sys.xp_create_subdir @command

--Imports data into the temp client table
BULK INSERT TempClientData
FROM 'C:\Directory\Database Text Files\Client Data.csv'
WITH (
    FORMAT = 'CSV',
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',	
	TABLOCK,
    FIRSTROW = 2 -- Skips header
);

--Deletes the old text file to save space and processing
DECLARE @cmd NVARCHAR(MAX) = 'xp_cmdshell ''del "C:\Directory\Database Text Files\Client Data.csv"''';
EXEC (@cmd);

--Imports data into the temp policy table
BULK INSERT TempPolicyData
FROM 'C:\Directory\Database Text Files\Policy Data.csv'
WITH (
    FORMAT = 'CSV',
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	TABLOCK,
    FIRSTROW = 2
);

--Deletes the old text file to save space and processing
SET @cmd = 'xp_cmdshell ''del "C:\Directory\Database Text Files\Policy Data.csv"''';
EXEC (@cmd);

--Imports data into the temp insurer protect payments table
BULK INSERT TempIPPayments
FROM 'C:\Directory\Database Text Files\Payments to I-P\I-P Payments.csv'
WITH (
	FORMAT = 'CSV',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK,
	FIRSTROW = 2
);

--Imports data into the temp insurer protect payments table
BULK INSERT TempIPNPayments
FROM 'C:\Directory\Database Text Files\Payments to I-P\IPN Payments.csv'
WITH (
    FORMAT = 'CSV',
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	TABLOCK,
    FIRSTROW = 2
);
GO

--Converts the data and sends it to the main policy table as they are all imported as "VARCHAR" for an unknown reason
INSERT INTO policy_info (
	client_reference, policy_type, calc_type,
	trans_type, bd_1, bd_1_per,
	bd_2, bd_2_per, bd_3,
	bd_3_per, lia_bd_load, man_pl_per,
	man_el_per, an_turn, pl_level,
	el_level, em_num, seats,
	oil, oil_load, eq_mob,
	eq_fixed, eq_postcode, pro_value,
	pro_first_line, pro_second_line, pro_third_line,
	pro_fourth_line, pro_poco, ar_etmd,
	tracker, standard_loc_proflatrate, non_stan_loc_type,
	non_stan_loc_load, property_load_other, insurer_theft,
	eq_fixed_load, eq_mobile_load, pl_total,
	el_total, eq_mob_total, eq_fixed_total,
	pro_total, stan_excess, tmd_excess,
	sto_flo_excess, pro_excess, calculation_date,
	inception_date, renewal_date, gasbottles, deviation, cal_time)
SELECT
	CAST(client_reference AS INT) AS client_reference,
	CAST(policy_type AS VARCHAR(255)) AS policy_type,
	COALESCE(CAST(calc_type AS VARCHAR(255)),'Standard') AS calc_type,
	COALESCE(CAST(trans_type AS VARCHAR(255)),'Quotation') AS trans_type,
	CAST(bd_1 AS VARCHAR(255)) AS bd_1,
	CAST(ROUND(ROUND(bd_1_per,2),2,1) AS DECIMAL(8, 4)) AS bd_1_per,
	CAST(bd_2 AS VARCHAR(255)) AS bd_2,
	CAST(ROUND(ROUND(bd_2_per,2),2,1) AS DECIMAL(8, 4)) AS bd_2_per,
	CAST(bd_3 AS VARCHAR(255)) AS bd_3,
	CAST(ROUND(ROUND(bd_3_per,2),2,1) AS DECIMAL(8, 4)) AS bd_3_per,
	CAST(ROUND(ROUND(lia_bd_load,2),2,1) AS DECIMAL(8, 4)) AS lia_bd_load,
	CAST(ROUND(ROUND(man_pl_per,2),2,1) AS DECIMAL(8, 4)) AS man_pl_per,
	CAST(ROUND(ROUND(man_el_per,2),2,1) AS DECIMAL(8, 4)) AS man_el_per,
	CAST(an_turn AS BIGINT) AS an_turn, CAST(pl_level AS BIGINT) AS pl_level,
	COALESCE(CAST(el_level AS VARCHAR(255)), 'No') AS el_level,
	CAST(em_num AS INT) AS em_num,
	COALESCE(CAST(seats AS VARCHAR(255)), 'No') AS seats,
	CAST(oil AS VARCHAR(255)) AS oil,
	CAST(ROUND(ROUND(oil_load,2),2,1) AS DECIMAL(5, 4)) AS oil_load,
	CAST(eq_mob AS BIGINT) AS eq_mob,
	CAST(eq_fixed AS BIGINT) AS eq_fixed,
	CAST(eq_postcode AS VARCHAR(255)) AS eq_postcode,
	CAST(pro_value AS BIGINT) AS pro_value,
	COALESCE(CAST(pro_first_line AS VARCHAR(255)), 'N/a') AS pro_first_line,
	CAST(pro_second_line AS VARCHAR(255)) AS pro_second_line,
	CAST(pro_third_line AS VARCHAR(255)) AS pro_third_line,
	CAST(pro_fourth_line AS VARCHAR(255)) AS pro_fourth_line,
	COALESCE(CAST(pro_poco AS VARCHAR(255)), 'N/a') AS pro_poco,
	COALESCE(CAST(ar_etmd AS VARCHAR(255)), 'N/a') AS ar_etmd,
	COALESCE(CAST(tracker AS VARCHAR(255)), 'No') AS tracker,
	COALESCE(CAST(standard_loc_proflatrate AS VARCHAR(255)), 'Yes') AS standard_loc_proflatrate,
	CAST(non_stan_loc_type AS VARCHAR(255)) AS non_stan_loc_type,
	CAST(ROUND(ROUND(non_stan_loc_load,2),2,1) AS DECIMAL(8, 4)) AS non_stan_loc_load,
	CAST(ROUND(ROUND(property_load_other,2),2,1) AS DECIMAL(8, 4)) AS property_load_other,
	CAST(insurer_theft AS VARCHAR(255)) AS insurer_theft,
	CAST(ROUND(ROUND(eq_fixed_load,2),2,1) AS DECIMAL(8, 4)) AS eq_fixed_load,
	CAST(ROUND(ROUND(eq_mobile_load,2),2,1) AS DECIMAL(8, 4)) AS eq_mobile_load,
	CAST(ROUND(ROUND(pl_total,2),2,1) AS MONEY) AS pl_total,
	CAST(ROUND(ROUND(el_total,2),2,1) AS MONEY) AS el_total,
	CAST(ROUND(ROUND(eq_mob_total,2),2,1) AS MONEY) AS eq_mob_total,
	CAST(ROUND(ROUND(eq_fixed_total,2),2,1) AS MONEY) AS eq_fixed_total,
	CAST(ROUND(ROUND(pro_total,2),2,1) AS MONEY) AS pro_total,
	CAST(stan_excess AS INT) AS stan_excess,
	CAST(tmd_excess AS INT) AS tmd_excess,
	CAST(sto_flo_excess AS INT) AS sto_flo_excess,
	CAST(pro_excess AS INT) AS pro_excess,
	CAST(CONVERT(DATE, calculation_date, 103) AS DATE) AS calculation_date,
	CAST(CONVERT(DATE, inception_date, 103) AS DATE) AS inception_date,
	CAST(CONVERT(DATE, renewal_date, 103) AS DATE) AS renewal_date,
	CAST(gasbottles AS VARCHAR(255)) AS gasbottles,
	CAST(deviation AS DECIMAL(8,4)) AS deviation,
	CAST(cal_time AS TIME) AS cal_time FROM TempPolicyData;

--saves all data in a backup incase of processing errors and for error finding
DECLARE @command NVARCHAR(1000)
DECLARE @time AS DATETIME = GETDATE();
DECLARE @today AS NVARCHAR(MAX) = FORMAT(@time,'d','no');
SELECT @today = REPLACE(''+@today+'','-','.');
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM TempPolicyData" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\TempPolicyData '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--updates fields that do not have correct data in fields
UPDATE policy_info
SET 
    bd_1_per = COALESCE(bd_1_per, 1),
    bd_2_per = COALESCE(bd_2_per, 0),
    bd_3_per = COALESCE(bd_3_per, 0),
    lia_bd_load = COALESCE(lia_bd_load, 0),
    man_pl_per = COALESCE(man_pl_per, 0),
    man_el_per = COALESCE(man_el_per, 0),
    an_turn = COALESCE(an_turn, 0),
    pl_level = COALESCE(pl_level, 0),
    em_num = COALESCE(em_num, 0),
    oil = COALESCE(oil, 0),
    oil_load = COALESCE(oil_load, 0),
    eq_mob = COALESCE(eq_mob, 0),
    eq_fixed = COALESCE(eq_fixed, 0),
    pro_value = COALESCE(pro_value, 0),
    non_stan_loc_load = COALESCE(non_stan_loc_load, 0),
    property_load_other = COALESCE(property_load_other, 0),
    eq_fixed_load = COALESCE(eq_fixed_load, 0),
    eq_mobile_load = COALESCE(eq_mobile_load, 0),
    pl_total = COALESCE(pl_total, 0),
    el_total = COALESCE(el_total, 0),
    eq_mob_total = COALESCE(eq_mob_total, 0),
    eq_fixed_total = COALESCE(eq_fixed_total, 0),
    pro_total = COALESCE(pro_total, 0),
    stan_excess = COALESCE(stan_excess, 250),
    tmd_excess = COALESCE(tmd_excess, 0),
    sto_flo_excess = COALESCE(sto_flo_excess, 0),
    pro_excess = COALESCE(pro_excess, 0),
	pro_first_line = REPLACE(pro_first_line, pro_poco, '');

--Converts the data and sends it to the second client table as they are all imported as "VARCHAR" for an unknown reason
--and so it can remove all duplicate client references as this is the ID for this table
INSERT INTO TempClientData2 (
	client_reference, entity_type, full_name,
	last_name, first_name, address_first_line,
	address_second_line, address_third_line, address_fourth_line,
	address_postcode, n_membership, ern,
	experience, last_updated)
SELECT
	COALESCE(CAST(client_reference AS INT),'1') AS client_reference,
	CAST(entity_type AS VARCHAR(255)) AS entity_type,
	CAST(full_name AS VARCHAR(255)) AS full_name,
	CAST(last_name AS VARCHAR(255)) AS last_name,
	CAST(first_name AS VARCHAR(255)) AS first_name,
	CAST(address_first_line AS VARCHAR(255)) AS address_first_line,
	COALESCE(CAST(address_second_line AS VARCHAR(255)), NULL) AS address_second_line,
	COALESCE(CAST(address_third_line AS VARCHAR(255)), NULL) AS address_third_line,
	COALESCE(CAST(address_fourth_line AS VARCHAR(255)), NULL) AS address_fourth_line,
	CAST(address_postcode AS VARCHAR(255)) AS address_postcode,
	COALESCE(CAST(n_membership AS VARCHAR(255)), 'N/a') AS n_membership,
	COALESCE(CAST(ern AS VARCHAR(255)), 'N/a') AS ern,
	COALESCE(CAST(experience AS INT), 0) AS experience,
	CAST(CONVERT(DATE, last_updated, 103) AS DATE) AS last_updated FROM TempClientData;

--saves all data in a backup incase of processing errors and for error finding
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM TempClientData" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\TempClientData Unclean '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--removes all manual entries that were added as they do not contain enough data to be useful
DELETE FROM TempClientData2 WHERE address_first_line = 'N/a' OR address_first_line = NULL;
WITH CTE AS (
	SELECT client_reference, entity_type, full_name,
	last_name, first_name, address_first_line,
	address_second_line, address_third_line, address_fourth_line,
	address_postcode, n_membership, ern,
	experience, last_updated,
	ROW_NUMBER() OVER(PARTITION BY client_reference ORDER BY last_updated DESC) AS RowNum FROM TempClientData2)
DELETE FROM CTE WHERE RowNum>1;
DELETE FROM TempClientData2 WHERE client_reference = 1;

--saves all data in a backup incase of processing errors and for error finding
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM TempClientData2" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\TempClientData No Duplicates '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--Converts the data and sends it to the main client table
INSERT INTO client_info (
	client_reference,
	entity_type,
	full_name,
	last_name,
	first_name,
	address_first_line,
	address_second_line,
	address_third_line,
	address_fourth_line,
	address_postcode,
	n_membership,
	ern,
	experience,
	last_updated)
SELECT
	COALESCE(CAST(client_reference AS INT),'1') AS client_reference,
	CAST(entity_type AS VARCHAR(255)) AS entity_type,
	CAST(full_name AS VARCHAR(255)) AS full_name,
	CAST(last_name AS VARCHAR(255)) AS last_name,
	CAST(first_name AS VARCHAR(255)) AS first_name,
	CAST(address_first_line AS VARCHAR(255)) AS address_first_line,
	COALESCE(CAST(address_second_line AS VARCHAR(255)), NULL) AS address_second_line,
	COALESCE(CAST(address_third_line AS VARCHAR(255)), NULL) AS address_third_line,
	COALESCE(CAST(address_fourth_line AS VARCHAR(255)), NULL) AS address_fourth_line,
	CAST(address_postcode AS VARCHAR(255)) AS address_postcode, COALESCE(CAST(n_membership AS VARCHAR(255)), 'N/a') AS n_membership,
	COALESCE(CAST(ern AS VARCHAR(255)), 'N/a') AS ern,
	COALESCE(CAST(experience AS INT), 0) AS experience,
	CAST(CONVERT(DATE, last_updated, 103) AS DATE) AS last_updated FROM TempClientData2;
GO

--removing entries that have no usable data
UPDATE policy_info
SET 
    pl_total = CASE WHEN pl_total >= 0 AND trans_type LIKE '%Cancellation%' THEN pl_total * -1 ELSE pl_total END,
    el_total = CASE WHEN el_total >= 0 AND trans_type LIKE '%Cancellation%' THEN el_total * -1 ELSE el_total END,
    eq_mob_total = CASE WHEN eq_mob_total >= 0 AND trans_type LIKE '%Cancellation%' THEN eq_mob_total * -1 ELSE eq_mob_total END,
    eq_fixed_total = CASE WHEN eq_fixed_total >= 0 AND trans_type LIKE '%Cancellation%' THEN eq_fixed_total * -1 ELSE eq_fixed_total END,
    pro_total = CASE WHEN pro_total >= 0 AND trans_type LIKE '%Cancellation%' THEN pro_total * -1 ELSE pro_total END,
    cal_time = COALESCE(cal_time, '00:00:00');
DELETE FROM policy_info WHERE pl_total = 0 AND el_total = 0 AND eq_mob_total = 0 AND eq_fixed_total = 0 AND pro_total = 0 AND calc_type <> 'Cancellation NB';
DELETE FROM policy_info WHERE policy_type = 'N/a';

--Removing all exact duplicates
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY
            client_reference, policy_type, calc_type, trans_type,
            bd_1, bd_1_per, bd_2, bd_2_per, bd_3, bd_3_per,
            lia_bd_load, man_pl_per, man_el_per, an_turn, pl_level,
            el_level, em_num, seats, oil, oil_load, eq_mob,
            eq_fixed, eq_postcode, pro_value, pro_first_line,
            pro_second_line, pro_third_line, pro_fourth_line, pro_poco,
            ar_etmd, tracker, standard_loc_proflatrate, non_stan_loc_type,
            non_stan_loc_load, property_load_other, insurer_theft, eq_fixed_load,
            eq_mobile_load, pl_total, el_total, eq_mob_total, eq_fixed_total,
            pro_total, stan_excess, tmd_excess, sto_flo_excess, pro_excess,
            calculation_date, inception_date, renewal_date, gasbottles, deviation, cal_time
        ORDER BY calculation_date, cal_time DESC
        ) AS RowNum FROM policy_info)
DELETE FROM CTE WHERE RowNum > 1;

--saves all data in a backup incase of processing errors and for error finding
DECLARE @command NVARCHAR(1000)
DECLARE @time AS DATETIME = GETDATE();
DECLARE @today AS NVARCHAR(MAX) = FORMAT(@time,'d','no');
SELECT @today = REPLACE(''+@today+'','-','.');
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\policy_info no duplicates '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--Removes quotation entries if they fit certain conditions
--(where the unique reference, premium breakdown and policy
--type all match up and they are within 30 days of each other)
--and deletes the earlier one as it is assumed the later one has the correct information
WITH CTE AS (
    SELECT
            client_reference,
			policy_type,
			pl_total,
			el_total,
			eq_mob_total,
			eq_fixed_total,
			pro_total,
			calculation_date,
			trans_type,
			ROW_NUMBER() OVER (PARTITION BY
            client_reference, policy_type, pl_total, el_total, eq_mob_total, eq_fixed_total, pro_total
        ORDER BY calculation_date DESC) AS RowNum
    FROM policy_info
    WHERE trans_type = 'Quotation'
)
DELETE FROM CTE
WHERE RowNum > 1
    AND EXISTS (
        SELECT 1
        FROM CTE AS C2
        WHERE CTE.client_reference = C2.client_reference
            AND CTE.policy_type = C2.policy_type
            AND CTE.pl_total = C2.pl_total
            AND CTE.el_total = C2.el_total
            AND CTE.eq_mob_total = C2.eq_mob_total
            AND CTE.eq_fixed_total = C2.eq_fixed_total
            AND CTE.pro_total = C2.pro_total
			AND CTE.trans_type = 'Quotation'
            AND ABS(DATEDIFF(DAY, CTE.calculation_date, C2.calculation_date)) <= 30
    );

--saves all data in a backup incase of processing errors and for error finding
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\policy_info no duplicate quotations '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--Removes renewal invitation entries if they fit certain conditions
--(where the unique reference, premium breakdown and policy type all
--match up and they are within 30 days of each other)
--and deletes the earlier one as it is assumed the later one has the correct information
WITH CTE AS (SELECT
        client_reference,
        policy_type,
        pl_total,
        el_total,
        eq_mob_total,
        eq_fixed_total,
        pro_total,
        calculation_date,
        trans_type,
        ROW_NUMBER() OVER (PARTITION BY
            client_reference, policy_type, pl_total, el_total, eq_mob_total, eq_fixed_total, pro_total
        ORDER BY calculation_date ASC) AS RowNum
    FROM policy_info
    WHERE trans_type = 'Renewal Invitation'
)
DELETE FROM CTE
WHERE RowNum > 1 OR EXISTS (
    SELECT 1
    FROM CTE AS C2
    WHERE CTE.client_reference = C2.client_reference
      AND CTE.policy_type = C2.policy_type
      AND CTE.pl_total = C2.pl_total
      AND CTE.el_total = C2.el_total
      AND CTE.eq_mob_total = C2.eq_mob_total
      AND CTE.eq_fixed_total = C2.eq_fixed_total
      AND CTE.pro_total = C2.pro_total
	  AND CTE.trans_type = C2.trans_type
      AND ABS(DATEDIFF(DAY, CTE.calculation_date, C2.calculation_date)) >= 30
);

--saves all data in a backup incase of processing errors and for error finding
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\policy_info no duplicate renewal invites '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--Removes new business entries if they fit certain conditions
--(where the unique reference, premium breakdown, date and
--policy type all match up and they are within 300 days of each other,
--meaning they relate to the same entry)
--and deletes the earlier one as it is assumed the later one has the correct information
WITH CTE AS (
    SELECT
        client_reference,
        policy_type,
        pl_total,
        el_total,
        eq_mob_total,
        eq_fixed_total,
        pro_total,
        calculation_date,
        trans_type,
		cal_time,
        ROW_NUMBER() OVER (PARTITION BY
            client_reference, policy_type, trans_type
        ORDER BY
            CASE WHEN trans_type = 'New Business' THEN 1 ELSE 2 END,  -- Sort 'New Business' first
            calculation_date DESC,
			cal_time DESC -- Sort by calculation_date in descending order then by time
        ) AS RowNum
    FROM policy_info
    WHERE trans_type = 'New Business'
)
DELETE FROM CTE
WHERE RowNum > 1 OR EXISTS (
    SELECT 1
    FROM CTE AS C2
    WHERE CTE.client_reference = C2.client_reference
      AND CTE.policy_type = C2.policy_type
      AND CTE.trans_type = 'New Business'
      AND ABS(DATEDIFF(DAY, CTE.calculation_date, C2.calculation_date)) <= 300
);

--saves all data in a backup incase of processing errors and for error finding
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\policy_info no duplicate new business '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--Removes rebroked entries if they fit certain conditions
--(where the unique reference, premium breakdown, date and
--policy type all match up and they are within 300 days of
--each other, meaning they probably relate to the same entry)
--and deletes the earlier one as it is assumed the later one
--has the correct information
WITH CTE AS (
    SELECT
        client_reference,
        policy_type,
        pl_total,
        el_total,
        eq_mob_total,
        eq_fixed_total,
        pro_total,
        calculation_date,
        trans_type,
		cal_time,
        ROW_NUMBER() OVER (PARTITION BY
            client_reference, policy_type, trans_type
        ORDER BY
            CASE WHEN trans_type = 'Rebroked' THEN 1 ELSE 2 END,  -- Sort 'Rebroked' first
            calculation_date DESC,
			cal_time DESC -- Sort by calculation_date in descending order then by time
        ) AS RowNum
    FROM policy_info
    WHERE trans_type = 'Rebroked'
)
DELETE FROM CTE
WHERE RowNum > 1 OR EXISTS (
    SELECT 1
    FROM CTE AS C2
    WHERE CTE.client_reference = C2.client_reference
      AND CTE.policy_type = C2.policy_type
      AND CTE.trans_type = 'Rebroked'
      AND ABS(DATEDIFF(DAY, CTE.calculation_date, C2.calculation_date)) >= 300
);

--saves all data in a backup incase of processing errors and for error finding
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\policy_info no duplicate rebroked '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--Removes renewal entries if they fit certain conditions
--(where the unique reference, premium breakdown, date
--and policy type all match up and they are more than
--300 days away from each other so they pull through
--the correct renewal date) and deletes the earlier
--one as it is assumed the later one has the correct information
WITH CTE AS (
    SELECT
        client_reference,
        policy_type,
        pl_total,
        el_total,
        eq_mob_total,
        eq_fixed_total,
        pro_total,
        calculation_date,
        trans_type,
		cal_time,
        ROW_NUMBER() OVER (PARTITION BY
            client_reference, policy_type
        ORDER BY
            CASE WHEN trans_type = 'Renewal' THEN 1 ELSE 2 END,  -- Sort 'Renewal' first
            calculation_date DESC,
			cal_time DESC -- Sort by calculation_date in descending order then by time
        ) AS RowNum
    FROM policy_info
	WHERE trans_type = 'Renewal'
)
DELETE FROM CTE
WHERE RowNum > 1 OR EXISTS (
    SELECT 1
    FROM CTE AS C2
    WHERE CTE.client_reference = C2.client_reference
      AND CTE.policy_type = C2.policy_type
	  AND CTE.trans_type = 'Renewal'
      AND ABS(DATEDIFF(DAY, CTE.calculation_date, C2.calculation_date)) >= 300
);

--saves all data in a backup incase of processing errors and for error finding
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\policy_info no duplicate renewals '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--Removes cancellation entries if they fit certain conditions
--(where the unique reference, premium breakdown, date and
--policy type all match up) and deletes the earlier one as
--it is assumed the later one has the correct information
WITH CTE AS (
    SELECT
        client_reference,
        policy_type,
        pl_total,
        el_total,
        eq_mob_total,
        eq_fixed_total,
        pro_total,
        calculation_date,
        trans_type,
		cal_time,
        ROW_NUMBER() OVER (PARTITION BY
            client_reference, policy_type
        ORDER BY
            CASE WHEN trans_type = 'Cancellation' THEN 1
                ELSE 2
            END,
            calculation_date DESC,
			cal_time DESC
        ) AS RowNum
    FROM policy_info
)
DELETE FROM CTE
WHERE RowNum > 1
	AND trans_type ='Cancellation';

--saves all data in a backup incase of processing errors and for error finding
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\policy_info no duplicate cancellation '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--Removes cancellation entries if they fit certain conditions
--(where the unique reference, premium breakdown, date and
--policy type all match up) and deletes the earlier one as
--it is assumed the later one has the correct information
WITH CTE AS (
    SELECT
        client_reference,
        policy_type,
        pl_total,
        el_total,
        eq_mob_total,
        eq_fixed_total,
        pro_total,
        calculation_date,
        trans_type,
		cal_time,
        ROW_NUMBER() OVER (PARTITION BY
            client_reference, policy_type
        ORDER BY
            CASE WHEN trans_type = 'Cancellation NB' THEN 1
                ELSE 2
            END,
            calculation_date DESC,
			cal_time DESC
        ) AS RowNum
    FROM policy_info
)
DELETE FROM CTE
WHERE RowNum > 1
	AND trans_type ='Cancellation NB';

--Updates all New Business, Rebroked and Quotation entries with the correct start date
--as per the live policy list
UPDATE policy_info
	SET inception_date = (SELECT t2.insurerprotectlivepolicies FROM insurerprotectlivepolicies t2 WHERE t2.id = policy_info.client_reference)
    WHERE policy_info.trans_type = 'New Business' OR policy_info.trans_type = 'Rebroked' OR policy_info.trans_type = 'Quotation';

UPDATE policy_info
	SET inception_date = (SELECT t2.insurerprotect_nonstan_livepolicies FROM insurerprotect_nonstan_livepolicies t2 WHERE t2.id = policy_info.client_reference)
    WHERE policy_info.trans_type = 'New Business' OR policy_info.trans_type = 'Rebroked' OR policy_info.trans_type = 'Quotation';

--Final Backup for each table
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\policy_info no duplicate cancellation NB '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "C:\Directory\Database Text Files\policy_info.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM policy_info" -o "F:\Scans\Bordereaux\insurer Protect\insurer-Protect Data\policy_info.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM client_info" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\client_info no duplicates '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT * FROM client_info" -o "C:\Directory\Database Text Files\client_info.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "SELECT client_reference, entity_type, full_name, last_name, first_name, address_first_line, address_second_line, address_third_line, address_fourth_line, address_postcode, ern, experience, last_updated FROM client_info" -o "F:\Scans\Bordereaux\insurer Protect\insurer-Protect Data\client_info.csv"';
EXEC sys.xp_cmdshell @command;
GO

--Orders entries into the "Most Likely" order and removes duplicates
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY
	id
        ORDER BY id, second_check, ABS(system_dif) ASC, calculation_date DESC, cal_time DESC
        ) AS RowNum FROM [results IP])
SELECT * FROM CTE ORDER BY RowNum, id ASC;
GO

--Orders entries into the "Most Likely" order and removes duplicates
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY
	id
        ORDER BY id, second_check, ABS(system_dif) ASC, calculation_date DESC, cal_time DESC
        ) AS RowNum FROM [results IPN])
SELECT * FROM CTE ORDER BY RowNum, id ASC;
GO

--generates the final "bordereaux" and creates a report of each entry that is obviously wrong as well as backing it up
DECLARE @command NVARCHAR(1000)
DECLARE @time AS DATETIME = GETDATE();
DECLARE @month AS NVARCHAR(MAX) = MONTH(GETDATE());
DECLARE @year AS NVARCHAR(MAX) = YEAR(GETDATE());
DECLARE @today AS NVARCHAR(MAX) = FORMAT(@time,'d','no');
SELECT @today = REPLACE(''+@today+'','-','.');
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id, ABS(system_dif), second_check ASC, calculation_date DESC, cal_time DESC) AS RowNum FROM [results IP]) SELECT * FROM CTE WHERE RowNum = 1" -o "F:\Scans\Bordereaux\insurer Protect\Data Filtered from Calculator Data\'+@year+'\'+@month+'\bord I-P results '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id, ABS(system_dif), second_check ASC, calculation_date DESC, cal_time DESC) AS RowNum FROM [results IP]) SELECT * FROM CTE WHERE RowNum = 1 AND system_dif > 0.05 OR RowNum = 1 AND system_dif < -0.05 OR RowNum = 1 AND calculation_date IS NULL OR ABS(DATEDIFF(day, Effective_date, posting_date)) > 30 AND RowNum = 1" -o "F:\Scans\Bordereaux\insurer Protect\Data Filtered from Calculator Data\'+@year+'\'+@month+'\bord I-P INCORRECT results '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id, ABS(system_dif), second_check ASC, calculation_date DESC, cal_time DESC) AS RowNum FROM [results IP]) SELECT * FROM CTE WHERE RowNum = 1 AND Trans2 = ""NB"" AND trans_type = ""Quotation""" -o "F:\Scans\Bordereaux\insurer Protect\Data Filtered from Calculator Data\'+@year+'\'+@month+'\bord I-P New Business Incorrect Date results '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id ASC) AS RowNum FROM [results IP]) SELECT * FROM CTE ORDER BY RowNum" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\bord I-P ALL results '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id, ABS(system_dif), second_check ASC, calculation_date DESC, cal_time DESC) AS RowNum FROM [results IPN]) SELECT * FROM CTE WHERE RowNum = 1" -o "F:\Scans\Bordereaux\insurer Protect\Data Filtered from Calculator Data\'+@year+'\'+@month+'\bord IPN results '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id, ABS(system_dif), second_check ASC, calculation_date DESC, cal_time DESC) AS RowNum FROM [results IPN]) SELECT * FROM CTE WHERE RowNum = 1 AND system_dif > 0.05 OR RowNum = 1 AND system_dif < -0.05 OR RowNum = 1 AND calculation_date IS NULL OR ABS(DATEDIFF(day, Effective_date, posting_date)) > 30 AND RowNum = 1" -o "F:\Scans\Bordereaux\insurer Protect\Data Filtered from Calculator Data\'+@year+'\'+@month+'\bord IPN INCORRECT results '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id, ABS(system_dif), second_check ASC, calculation_date DESC, cal_time DESC) AS RowNum FROM [results IPN]) SELECT * FROM CTE WHERE RowNum = 1 AND Trans2 = ""NB"" AND trans_type = ""Quotation""" -o "F:\Scans\Bordereaux\insurer Protect\Data Filtered from Calculator Data\'+@year+'\'+@month+'\bord IPN New Business Incorrect Date results '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;
SET @command = 'sqlcmd -S ComputerName\SERVER1 -d insurer_protect_db -E -s"," -W -Q "WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id ASC) AS RowNum FROM [results IPN]) SELECT * FROM CTE ORDER BY RowNum" -o "C:\Directory\Database Text Files\Backed Up Databases\'+@today+'\bord IPN ALL results '+@today+'.csv"';
EXEC sys.xp_cmdshell @command;

--resets variables to '' and empties tables to save space as data is alreday saved on csv documents
SET @command = ''

--All Back Up Tables are stored as CSVs to save space on the shared drive and are archived for 6 months
--before being deleted as to not keep unnecessary data

--One issue that I had was matching the payment entries with the calculation entry as there is no direct
--way of linking them within the system we have and all "return premium" entries are labled as just that
--but they could reference a Cancellation or a Mid-Term Adjustment. This is why the entries are matched
--based on how likely they are to be.