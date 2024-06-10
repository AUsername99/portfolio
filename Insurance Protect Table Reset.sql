--This is where all the tables are listed for the database. I keep this incase there
--is something seriously wrong with the data inserted or we lose the database so it
--can be recreated a lot quicker than starting from scratch.

USE insurer_protect_db; --Use the correct database
GO

--Drops the tables so they can be recreated
DROP TABLE policy_info;
DROP TABLE client_info;
DROP TABLE TempPolicyData;
DROP TABLE TempClientData;
DROP TABLE TempIPPayments;
DROP TABLE TempIPNPayments;
DROP TABLE TempClientData2;
DROP VIEW [results IP];
DROP VIEW [results IPN];
DROP TABLE policy_types_insurer_protect;
DROP TABLE tempinsurerprotectlivepolicies;
DROP TABLE insurerprotectlivepolicies;
DROP TABLE tempinsurerprotect_nonstan_livepolicies;
DROP TABLE insurerprotect_nonstan_livepolicies;
GO

-- Creates temporary tables for I-P Payments for cleaning
CREATE TABLE TempIPPayments (
    id INT IDENTITY(1,1),
    Client_Code INT,
    Client_Name VARCHAR(255),
    Pol VARCHAR(255),
    Brkrs_Ref VARCHAR(255),
    Trans_Num INT,
    Effective_Date DATE,
    Posting_Date DATE,
    Policy_Type VARCHAR(255),
    Number VARCHAR(255),
    Trans VARCHAR(255),
    Premium MONEY,
    IPT MONEY,
    Comm MONEY,
    Net MONEY,
    Due_to_insurer MONEY,
    Paid MONEY,
    Comm_Adj MONEY,
    Comm_Due_to_Broker MONEY);

-- Create temporary tables for IPN Payments for cleaning
CREATE TABLE TempIPNPayments (
    id INT IDENTITY(1,1),
    Client_Code INT,
    Client_Name VARCHAR(255),
    Pol VARCHAR(255),
    Brkrs_Ref VARCHAR(255),
    Trans_Num INT,
    Effective_Date DATE,
    Posting_Date DATE,
    Policy_Type VARCHAR(255),
    Number VARCHAR(255),
    Trans VARCHAR(255),
    Premium MONEY,
    IPT MONEY,
    Comm MONEY,
    Net MONEY,
    Due_to_insurer MONEY,
    Paid MONEY,
    Comm_Adj MONEY,
    Comm_Due_to_Broker MONEY);

--Create temp table for Client Data so duplicates can be removed before they are placed in main table
CREATE TABLE TempClientData2 (
    client_reference INT NOT NULL,
    entity_type VARCHAR(255),
    full_name VARCHAR(255),
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    address_first_line VARCHAR(255) NOT NULL,
    address_second_line VARCHAR(255) DEFAULT NULL,
    address_third_line VARCHAR(255) DEFAULT NULL,
    address_fourth_line VARCHAR(255) DEFAULT NULL,
    address_postcode VARCHAR(255) NOT NULL,
    n_membership VARCHAR(255) DEFAULT 'N/a',
    ern VARCHAR(255) DEFAULT 'N/a',
    experience INT DEFAULT 0,
    last_updated DATE DEFAULT CURRENT_TIMESTAMP);
GO

--Creates the main table for the calculations done
CREATE TABLE policy_info(
	client_reference INT, --Reference from client system
	policy_type VARCHAR(255), --Policy Type (E/P, P/L, TLC or TRC)
	calc_type VARCHAR(255) DEFAULT 'Standard', --Calculation Type (Standard or Non-Standard)
	trans_type VARCHAR(255) DEFAULT 'QUOTE', --Type of transation (Quote, New Business, Invitation, Renewed, Mid Term Adjustment, Accepting an MTA, or Cancelling a policy)
	bd_1 VARCHAR(255) NOT NULL, --Business Description 1
	bd_1_per DECIMAL(8,4) DEFAULT 100, --Business Description 1 Percentage (default 100%)
	bd_2 VARCHAR(255), --Business Description 2
	bd_2_per DECIMAL(8,4) DEFAULT 0, --Business Description 2 Percentage
	bd_3 VARCHAR(255), --Business Description 3
	bd_3_per DECIMAL(8,4) DEFAULT 0, --Business Description 3 Percentage
	lia_bd_load DECIMAL(8,4) DEFAULT 0, --Loading on the liability from the business descriptions
	man_pl_per DECIMAL(8,4) DEFAULT 0, --Manual loading on Liability rate (default 0%)
	man_el_per DECIMAL(8,4) DEFAULT 0, --Manual loading on Employers Liability rate (default 0%)
	an_turn MONEY DEFAULT 0, --Annual Turnover
	pl_level BIGINT DEFAULT 0, --Liability Cover Level
	el_level VARCHAR(255) DEFAULT 'No', --Employers Liability included?
	em_num INT DEFAULT 0, --Number of Employees
	seats VARCHAR(255) DEFAULT 'No', --Seating Included?
	oil INT DEFAULT 0, --Amount of Oil
	oil_load DECIMAL(8,4), --Loading due to Oil?
	eq_mob MONEY DEFAULT 0, --Mobile Equipment amount
	eq_fixed MONEY DEFAULT 0, --Fixed Equipment amount
	eq_postcode VARCHAR(255), --Postcode of Equipment Storage Location
	pro_value MONEY DEFAULT 0, --property Value
	pro_first_line VARCHAR(255) DEFAULT 'N/a', --property Storage Address First Line
	pro_second_line VARCHAR(255) DEFAULT NULL, --property Storage Address Second Line
	pro_third_line VARCHAR(255) DEFAULT NULL, --property Storage Address Third Line
	pro_fourth_line VARCHAR(255) DEFAULT NULL, --property Storage Address Fourth Line
	pro_poco VARCHAR(255) DEFAULT 'N/a', --property Storage Postcode
	ar_etmd VARCHAR(255) DEFAULT 'N/a', --All Risks Cover or Excluding Theft and Malicious Damage
	tracker VARCHAR(255) DEFAULT 'No', --Is a Tracker Fitted
	standard_loc_proflatrate VARCHAR(255) DEFAULT 'Yes', --If the property Storage is a Standard Location or Not or if it is on a flat rate basis
	non_stan_loc_type VARCHAR(255), --The non-standard location type
	non_stan_loc_load DECIMAL(8,4), --The non-standard location loading on the property
	property_load_other DECIMAL(8,4), --Other loads that have been put on the property including claims and correctional loads
	hawkeye_theft VARCHAR(255), --Hawkeye Theft Rating
	eq_fixed_load DECIMAL(8,4), --Loads put onto the fixed equipment
	eq_mobile_load DECIMAL(8,4), --Loads put onto the mobile equipment
	pl_total MONEY DEFAULT 0, --Liability Rate after all loadings
	el_total MONEY DEFAULT 0, --Employers Liability Rate after all loadings
	eq_mob_total MONEY DEFAULT 0, --Mobile Equipment Rate after all loadings
	eq_fixed_total MONEY DEFAULT 0, --Fixed Equipment Rate after all loadings
	pro_total MONEY DEFAULT 0, --property Rate after all loadings
	stan_excess MONEY DEFAULT '250', --Standard Excess on the Policy
	tmd_excess MONEY DEFAULT '250', --Theft & Malicious Damage Excess on the Policy
	sto_flo_excess MONEY DEFAULT '250', --Storm & Flood Excess
	pro_excess MONEY DEFAULT '250', --property Excess
	calculation_date DATE DEFAULT CURRENT_TIMESTAMP, --Calculation Date
	inception_date DATE, --Inception date of the policy or MTA
	renewal_date DATE, --Renewal Date of policy if applicable
	gasbottles VARCHAR(255), --Gas bottles used
	deviation DECIMAL(8,4), --deviation from standard policy rate
	cal_time TIME); --time calculation done

--Creates the main table for the clients that have had calculations done
CREATE TABLE client_info (
	client_reference INT NOT NULL, --client Reference (also the ID)
	entity_type VARCHAR(255), --If they are a client, company, charity etc.
	full_name VARCHAR(255), --Company Name if applicable
	last_name VARCHAR(255), --Clients First Name if applicable
	first_name VARCHAR(255), --Clients Last Name if applicable
	address_first_line VARCHAR(255) NOT NULL, --First Line of the correspondence address
	address_second_line VARCHAR(255) DEFAULT NULL, --Second Line of the correspondence address
	address_third_line VARCHAR(255) DEFAULT NULL, --Third Line of the correspondence address
	address_fourth_line VARCHAR(255) DEFAULT NULL, --Fourth Line of the correspondence address
	address_postcode VARCHAR(255) NOT NULL, --Postcode of the correspondence address
	n_membership VARCHAR(255) DEFAULT 'N/a', --If they are an member or not (notes the member number)
	ern VARCHAR(255) DEFAULT 'N/a', --Employers Reference Number if applicable
	experience INT DEFAULT 0, --Relivant experience
	last_updated DATE DEFAULT CURRENT_TIMESTAMP, --the last time that client had their details added to the database
	PRIMARY KEY (client_reference),
	UNIQUE (client_reference));

--Creates a temporary table for "Client Data" so
--the data can be converted into the correct datatype
CREATE TABLE TempClientData (
    client_reference VARCHAR(255),
    entity_type VARCHAR(255),
    full_name VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    address_first_line VARCHAR(255) NOT NULL,
    address_second_line VARCHAR(255) DEFAULT NULL,
    address_third_line VARCHAR(255) DEFAULT NULL,
    address_fourth_line VARCHAR(255) DEFAULT NULL,
    address_postcode VARCHAR(255) NOT NULL,
    n_membership VARCHAR(255) DEFAULT 'N/a',
    ern VARCHAR(255) DEFAULT 'N/a',
    experience VARCHAR(255) DEFAULT 0,
    last_updated VARCHAR(MAX));

--Creates a temporary table for "Policy Data" so
--the data can be converted into the correct datatype
CREATE TABLE TempPolicyData (
    client_reference VARCHAR(255),
    policy_type VARCHAR(255),
    calc_type VARCHAR(255) DEFAULT 'Standard',
    trans_type VARCHAR(255) DEFAULT 'Quotation',
	bd_1 VARCHAR(255) NOT NULL,
	bd_1_per VARCHAR(255),
	bd_2 VARCHAR(255) DEFAULT ' ',
	bd_2_per VARCHAR(255),
	bd_3 VARCHAR(255) DEFAULT ' ',
	bd_3_per VARCHAR(255),
	lia_bd_load VARCHAR(255),
	man_pl_per VARCHAR(255),
	man_el_per VARCHAR(255),
	an_turn VARCHAR(255),
	pl_level VARCHAR(255),
	el_level VARCHAR(255) DEFAULT 'No',
	em_num VARCHAR(255),
	seats VARCHAR(255) DEFAULT 'No',
	oil VARCHAR(255),
	oil_load VARCHAR(255),
	eq_mob VARCHAR(255),
	eq_fixed VARCHAR(255),
	eq_postcode VARCHAR(255),
	pro_value VARCHAR(255),
	pro_first_line VARCHAR(255) DEFAULT 'N/a',
	pro_second_line VARCHAR(255) DEFAULT NULL,
	pro_third_line VARCHAR(255) DEFAULT NULL,
	pro_fourth_line VARCHAR(255) DEFAULT NULL,
	pro_poco VARCHAR(255) DEFAULT 'N/a',
	ar_etmd VARCHAR(255) DEFAULT 'N/a',
	tracker VARCHAR(255) DEFAULT 'No',
	standard_loc_proflatrate VARCHAR(255) DEFAULT 'Yes',
	non_stan_loc_type VARCHAR(255),
	non_stan_loc_load VARCHAR(255),
	property_load_other VARCHAR(255),
	hawkeye_theft VARCHAR(255),
	eq_fixed_load VARCHAR(255),
	eq_mobile_load VARCHAR(255),
	pl_total VARCHAR(255),
	el_total VARCHAR(255),
	eq_mob_total VARCHAR(255),
	eq_fixed_total VARCHAR(255),
	pro_total VARCHAR(255),
	stan_excess VARCHAR(255) DEFAULT '250',
	tmd_excess VARCHAR(255) DEFAULT '250',
	sto_flo_excess VARCHAR(255) DEFAULT '250',
	pro_excess VARCHAR(255) DEFAULT '250',
	calculation_date VARCHAR(255) DEFAULT CURRENT_TIMESTAMP,
	inception_date VARCHAR(255),
	renewal_date VARCHAR(255),
	gasbottles VARCHAR(255),
	deviation VARCHAR(255),
	cal_time TIME,
	hogroast VARCHAR(255),
	solidfuel VARCHAR(255),
	cotpp VARCHAR(255));
GO

--Left Joins the policy information onto the account entries
--This is used for mathcing payment entries with calculations
--done by the staff members for one of the 2 policy schemes.
--They create a view that matches the columns in the bordreau
--statement sent to the insurers and assigns a "likelyhood"
--factor on the end to remove duplicate entries that match up
CREATE VIEW [results IP] AS
SELECT IP.id,
	CASE
		WHEN IP.Trans = 'NEWP' THEN 'New Business Inception'
		WHEN IP.Trans = 'RNWP' THEN 'Renewal'
		WHEN IP.Trans = 'RBRP' THEN 'Rebroked'
		WHEN IP.Trans = 'ADDP' THEN 'MTA Inception'
		WHEN IP.Trans = 'RETP' THEN 'Cancellation'
		ELSE '---'
	END AS Trans,
	CASE
		WHEN IP.Trans = 'NEWP' AND IP.Due_to_insurer < 0 THEN 'NTU'
		WHEN IP.Trans = 'RNWP' AND IP.Due_to_insurer < 0 THEN 'NTU'
		WHEN IP.Trans = 'NEWP' THEN 'NB'
		WHEN IP.Trans = 'RNWP' THEN 'RN'
		WHEN IP.Trans = 'RBRP' THEN 'RN'
		WHEN IP.Trans = 'ADDP' THEN 'MTA'
		WHEN IP.Trans = 'RETP' THEN 'CXD'
		ELSE '---'
	END AS Trans2,
	IP.Posting_Date,
	CASE
		WHEN p.trans_type = 'Renewal Invitation' THEN p.renewal_date
		WHEN DATEDIFF(day,p.inception_date,p.calculation_date) > 0 AND p.trans_type = 'Quotation' THEN p.calculation_date
		ELSE p.inception_date
	END AS Effective_date,
	'---' AS Sub_Agent_Name,
	IP.Client_Code AS broker_reference,
	IP.Number AS policy_number,
	CASE
		WHEN p.trans_type = 'New Business Inception' THEN p.inception_date
		WHEN p.trans_type = 'Quotation' THEN
		CASE
			WHEN CONVERT(INT,CONVERT(VARBINARY(8),p.inception_date)) < CONVERT(INT,CONVERT(VARBINARY(8),p.calculation_date)) THEN p.calculation_date
			ELSE p.inception_date
		END
		WHEN p.trans_type = 'Renewal Invitation' THEN p.renewal_date
		WHEN p.trans_type = 'Cancellation' THEN DATEADD(day,-365,p.renewal_date)
		WHEN p.trans_type = 'Cancellation NB' THEN DATEADD(day,-365,p.renewal_date)
		WHEN p.trans_type = 'MTA Inception' THEN DATEADD(day,-365,p.renewal_date)
		WHEN p.trans_type = 'MTA Quotation' THEN DATEADD(day,-365,p.renewal_date)
		ELSE p.inception_date
	END AS start_date_,
	CASE
		WHEN p.trans_type = 'Quotation' THEN
		CASE
			WHEN DATEDIFF(day,p.renewal_date,p.calculation_date) > 0 THEN DATEADD(day,365,p.calculation_date)
			ELSE p.renewal_date
		END
		WHEN p.trans_type = 'Renewal Invitation' THEN DATEADD(day,365,p.renewal_date)
		WHEN p.trans_type = 'Cancellation' THEN p.inception_date
		WHEN p.trans_type = 'Cancellation NB' THEN p.inception_date
		WHEN IP.Trans = 'NEWP' AND IP.Due_to_insurer < 0 THEN p.inception_date
		WHEN IP.Trans = 'RNWP' AND IP.Due_to_insurer < 0 THEN p.inception_date
		ELSE p.renewal_date
	END AS expirydate,
	c.full_name,
	c.address_first_line,
	c.address_second_line,
	c.address_third_line,
	C.address_fourth_line,
	'United Kingdom' AS country1,
	c.address_postcode,
	CONCAT(p.bd_1,' ',p.bd_2,' ',p.bd_3) AS b_d_full,
	CASE
		WHEN p.pro_first_line = '' THEN NULL
		ELSE p.pro_first_line
	END AS pro_first_line,
	p.pro_second_line,
	p.pro_third_line,
	p.pro_fourth_line,
	'United Kingdom' AS country2,
	p.pro_poco,
	p.em_num AS employee_numbers,
	CASE 
		WHEN p.el_level = 'Yes' THEN 10000000
		ELSE 0
	END AS el_level,
	CASE
		WHEN 1=1 THEN 0
	END AS wagerolec,
	CASE
		WHEN 1=1 THEN 0
	END AS wagerolem,
	CASE
		WHEN c.ern = 'N/a' THEN 'Y'
		WHEN c.ern IS NULL THEN 'Y'
		ELSE 'N'
	END AS ern_exempt,
	CASE
		WHEN c.ern IS NULL THEN 'N/a'
		ELSE c.ern
	END AS ern,
	p.an_turn,
	p.pl_level,
	p.eq_fixed + p.eq_mob + p.pro_value AS all_risks,
	CASE
		WHEN Trans = 'Cancellation' THEN
		CASE
			WHEN p.eq_fixed_total + p.eq_mob_total + p.pro_total + p.pl_total + p.el_total > 0 THEN (p.el_total)*(-1)
			ELSE p.el_total
		END
		ELSE p.el_total
	END AS el_total_,
	CASE
		WHEN Trans = 'Cancellation' THEN
		CASE
			WHEN p.eq_fixed_total + p.eq_mob_total + p.pro_total + p.pl_total + p.el_total > 0 THEN (p.pl_total)*(-1)
			ELSE p.pl_total
		END
		ELSE p.pl_total
	END AS pl_total_,
	CASE
		WHEN Trans = 'Cancellation' THEN
		CASE
			WHEN p.eq_fixed_total + p.eq_mob_total + p.pro_total > 0 THEN (p.eq_fixed_total + p.eq_mob_total + p.pro_total)*(-1)
			ELSE p.eq_fixed_total + p.eq_mob_total + p.pro_total
		END
		ELSE p.eq_fixed_total + p.eq_mob_total + p.pro_total
	END AS all_risks_total,
	'------' AS column_break1,
	'------' AS column_break2,
	'------' AS column_break3,
	'------' AS column_break4,
	'------' AS column_break5,
	'------' AS column_break6,
	'------' AS column_break7,
	'------' AS column_break8,
	p.deviation-1 AS rate_increase,
	'------' AS column_break9,
	ROUND((p.eq_fixed_total + p.eq_mob_total + p.pro_total + p.pl_total + p.el_total)/p.deviation,2) AS technical_premium,
	p.deviation,
	IP.Premium,
	IP.Due_to_insurer,
	IP.Premium - (p.eq_fixed_total + p.eq_mob_total + p.pro_total + p.pl_total + p.el_total) AS system_dif,
	p.trans_type,
	p.calculation_date,
	p.cal_time,
	CASE
		WHEN Trans = 'New Business Inception' THEN
		CASE
			WHEN p.trans_type = 'New Business Inception' THEN 1
			WHEN p.trans_type = 'Rebroked' THEN 2
			WHEN p.trans_type = 'Quotation' THEN 3
			WHEN p.trans_type = 'Renewal Invitation' THEN 4
			WHEN p.trans_type = 'MTA Inception' THEN 5
			WHEN p.trans_type = 'MTA Quotation' THEN 6
			WHEN p.trans_type = 'Renewal' THEN 7
			WHEN p.trans_type = 'Cancellation NB' THEN 8
			WHEN p.trans_type = 'Cancellation' THEN 9
			ELSE 10
		END
		WHEN Trans = 'Renewal' THEN
		CASE
			WHEN p.trans_type = 'Renewal' THEN 1
			WHEN p.trans_type = 'Renewal Invitation' THEN 2
			WHEN p.trans_type = 'Rebroked' THEN 3
			WHEN p.trans_type = 'Quotation' THEN 4
			WHEN p.trans_type = 'New Business Inception' THEN 5
			WHEN p.trans_type = 'MTA Inception' THEN 6
			WHEN p.trans_type = 'MTA Quotation' THEN 7
			WHEN p.trans_type = 'Cancellation NB' THEN 8
			WHEN p.trans_type = 'Cancellation' THEN 9
			ELSE 10
		END
		WHEN Trans = 'Rebroked' THEN
		CASE
			WHEN p.trans_type = 'Rebroked' THEN 1
			WHEN p.trans_type = 'New Business Inception' THEN 2
			WHEN p.trans_type = 'Quotation' THEN 3
			WHEN p.trans_type = 'Renewal Invitation' THEN 4
			WHEN p.trans_type = 'Renewal' THEN 5
			WHEN p.trans_type = 'MTA Inception' THEN 6
			WHEN p.trans_type = 'MTA Quotation' THEN 7
			WHEN p.trans_type = 'Cancellation NB' THEN 8
			WHEN p.trans_type = 'Cancellation' THEN 9
			ELSE 10
		END
		WHEN Trans = 'MTA Inception' THEN
		CASE
			WHEN p.trans_type = 'MTA Inception' THEN 1
			WHEN p.trans_type = 'MTA Quotation' THEN 2
			WHEN p.trans_type = 'Quotation' THEN 3
			WHEN p.trans_type = 'Renewal' THEN 4
			WHEN p.trans_type = 'Rebroked' THEN 5
			WHEN p.trans_type = 'New Business Inception' THEN 6
			WHEN p.trans_type = 'Renewal Invitation' THEN 7
			WHEN p.trans_type = 'Cancellation NB' THEN 8
			WHEN p.trans_type = 'Cancellation' THEN 9
			ELSE 10
		END
		WHEN Trans = 'Cancellation' THEN
		CASE
			WHEN p.trans_type = 'Cancellation' THEN 1
			WHEN p.trans_type = 'Cancellation NB' THEN 2
			WHEN p.trans_type = 'MTA Inception' THEN 3
			WHEN p.trans_type = 'MTA Quotation' THEN 4
			WHEN p.trans_type = 'Quotation' THEN 5
			WHEN p.trans_type = 'Renewal Invitation' THEN 6
			WHEN p.trans_type = 'Renewal' THEN 7
			WHEN p.trans_type = 'Rebroked' THEN 8
			WHEN p.trans_type = 'New Business Inception' THEN 9
			ELSE 10
		END
		ELSE 10
	END AS second_check
FROM TempIPPayments IP
LEFT JOIN policy_info p ON IP.Client_Code = p.client_reference
LEFT JOIN policy_info p2 ON Trans LIKE p2.trans_type
LEFT JOIN client_info c ON IP.Client_Code = c.client_reference
GO

--Left Joins the policy information onto the account entries
--This is used for mathcing payment entries with calculations
--done by the staff members for one of the 2 policy schemes.
--They create a view that matches the columns in the bordreau
--statement sent to the insurers and assigns a "likelyhood"
--factor on the end to remove duplicate entries that match up
CREATE VIEW [results IPN] AS
SELECT IP.id,
	CASE
		WHEN IP.Trans = 'NEWP' THEN 'New Business Inception'
		WHEN IP.Trans = 'RNWP' THEN 'Renewal'
		WHEN IP.Trans = 'RBRP' THEN 'Rebroked'
		WHEN IP.Trans = 'ADDP' THEN 'MTA Inception'
		WHEN IP.Trans = 'RETP' THEN 'Cancellation'
		ELSE '---'
	END AS Trans,
	CASE
		WHEN IP.Trans = 'NEWP' AND IP.Due_to_insurer < 0 THEN 'NTU'
		WHEN IP.Trans = 'RNWP' AND IP.Due_to_insurer < 0 THEN 'NTU'
		WHEN IP.Trans = 'NEWP' THEN 'NB'
		WHEN IP.Trans = 'RNWP' THEN 'RN'
		WHEN IP.Trans = 'RBRP' THEN 'RN'
		WHEN IP.Trans = 'ADDP' THEN 'MTA'
		WHEN IP.Trans = 'RETP' THEN 'CXD'
		ELSE '---'
	END AS Trans2,
	IP.Posting_Date,
	CASE
		WHEN p.trans_type = 'Renewal Invitation' THEN p.renewal_date
		WHEN DATEDIFF(day,p.inception_date,p.calculation_date) > 0 AND p.trans_type = 'Quotation' THEN p.calculation_date
		ELSE p.inception_date
	END AS Effective_date,
	'---' AS Sub_Agent_Name,
	IP.Client_Code AS broker_reference,
	IP.Number AS policy_number,
	CASE
		WHEN p.trans_type = 'New Business Inception' THEN p.inception_date
		WHEN p.trans_type = 'Quotation' THEN
		CASE
			WHEN CONVERT(INT,CONVERT(VARBINARY(8),p.inception_date)) < CONVERT(INT,CONVERT(VARBINARY(8),p.calculation_date)) THEN p.calculation_date
			ELSE p.inception_date
		END
		WHEN p.trans_type = 'Renewal Invitation' THEN p.renewal_date
		WHEN p.trans_type = 'Cancellation' THEN DATEADD(day,-365,p.renewal_date)
		WHEN p.trans_type = 'Cancellation NB' THEN DATEADD(day,-365,p.renewal_date)
		WHEN p.trans_type = 'MTA Inception' THEN DATEADD(day,-365,p.renewal_date)
		WHEN p.trans_type = 'MTA Quotation' THEN DATEADD(day,-365,p.renewal_date)
		ELSE p.inception_date
	END AS start_date_,
	CASE
		WHEN p.trans_type = 'Quotation' THEN
		CASE
			WHEN DATEDIFF(day,p.renewal_date,p.calculation_date) > 0 THEN DATEADD(day,365,p.calculation_date)
			ELSE p.renewal_date
		END
		WHEN p.trans_type = 'Renewal Invitation' THEN DATEADD(day,365,p.renewal_date)
		WHEN p.trans_type = 'Cancellation' THEN p.inception_date
		WHEN p.trans_type = 'Cancellation NB' THEN p.inception_date
		WHEN IP.Trans = 'NEWP' AND IP.Due_to_insurer < 0 THEN p.inception_date
		WHEN IP.Trans = 'RNWP' AND IP.Due_to_insurer < 0 THEN p.inception_date
		ELSE p.renewal_date
	END AS expirydate,
	c.full_name,
	c.address_first_line,
	c.address_second_line,
	c.address_third_line,
	C.address_fourth_line,
	'United Kingdom' AS country1,
	c.address_postcode,
	CONCAT(p.bd_1,' ',p.bd_2,' ',p.bd_3) AS b_d_full,
	CASE
		WHEN p.pro_first_line = '' THEN NULL
		ELSE p.pro_first_line
	END AS pro_first_line,
	p.pro_second_line,
	p.pro_third_line,
	p.pro_fourth_line,
	'United Kingdom' AS country2,
	p.pro_poco,
	p.em_num AS employee_numbers,
	CASE 
		WHEN p.el_level = 'Yes' THEN 10000000
		ELSE 0
	END AS el_level,
	CASE
		WHEN 1=1 THEN 0
	END AS wagerolec,
	CASE
		WHEN 1=1 THEN 0
	END AS wagerolem,
	CASE
		WHEN c.ern = 'N/a' THEN 'Y'
		WHEN c.ern IS NULL THEN 'Y'
		ELSE 'N'
	END AS ern_exempt,
	CASE
		WHEN c.ern IS NULL THEN 'N/a'
		ELSE c.ern
	END AS ern,
	p.an_turn,
	p.pl_level,
	p.eq_fixed + p.eq_mob + p.pro_value AS all_risks,
	CASE
		WHEN Trans = 'Cancellation' THEN
		CASE
			WHEN p.eq_fixed_total + p.eq_mob_total + p.pro_total + p.pl_total + p.el_total > 0 THEN (p.el_total)*(-1)
			ELSE p.el_total
		END
		ELSE p.el_total
	END AS el_total_,
	CASE
		WHEN Trans = 'Cancellation' THEN
		CASE
			WHEN p.eq_fixed_total + p.eq_mob_total + p.pro_total + p.pl_total + p.el_total > 0 THEN (p.pl_total)*(-1)
			ELSE p.pl_total
		END
		ELSE p.pl_total
	END AS pl_total_,
	CASE
		WHEN Trans = 'Cancellation' THEN
		CASE
			WHEN p.eq_fixed_total + p.eq_mob_total + p.pro_total > 0 THEN (p.eq_fixed_total + p.eq_mob_total + p.pro_total)*(-1)
			ELSE p.eq_fixed_total + p.eq_mob_total + p.pro_total
		END
		ELSE p.eq_fixed_total + p.eq_mob_total + p.pro_total
	END AS all_risks_total,
	'------' AS column_break1,
	'------' AS column_break2,
	'------' AS column_break3,
	'------' AS column_break4,
	'------' AS column_break5,
	'------' AS column_break6,
	'------' AS column_break7,
	'------' AS column_break8,
	p.deviation-1 AS rate_increase,
	'------' AS column_break9,
	ROUND((p.eq_fixed_total + p.eq_mob_total + p.pro_total + p.pl_total + p.el_total)/p.deviation,2) AS technical_premium,
	p.deviation,
	IP.Premium,
	IP.Due_to_insurer,
	IP.Premium - (p.eq_fixed_total + p.eq_mob_total + p.pro_total + p.pl_total + p.el_total) AS system_dif,
	p.trans_type,
	p.calculation_date,
	p.cal_time,
	CASE
		WHEN Trans = 'New Business Inception' THEN
		CASE
			WHEN p.trans_type = 'New Business Inception' THEN 1
			WHEN p.trans_type = 'Rebroked' THEN 2
			WHEN p.trans_type = 'Quotation' THEN 3
			WHEN p.trans_type = 'Renewal Invitation' THEN 4
			WHEN p.trans_type = 'MTA Inception' THEN 5
			WHEN p.trans_type = 'MTA Quotation' THEN 6
			WHEN p.trans_type = 'Renewal' THEN 7
			WHEN p.trans_type = 'Cancellation NB' THEN 8
			WHEN p.trans_type = 'Cancellation' THEN 9
			ELSE 10
		END
		WHEN Trans = 'Renewal' THEN
		CASE
			WHEN p.trans_type = 'Renewal' THEN 1
			WHEN p.trans_type = 'Renewal Invitation' THEN 2
			WHEN p.trans_type = 'Rebroked' THEN 3
			WHEN p.trans_type = 'Quotation' THEN 4
			WHEN p.trans_type = 'New Business Inception' THEN 5
			WHEN p.trans_type = 'MTA Inception' THEN 6
			WHEN p.trans_type = 'MTA Quotation' THEN 7
			WHEN p.trans_type = 'Cancellation NB' THEN 8
			WHEN p.trans_type = 'Cancellation' THEN 9
			ELSE 10
		END
		WHEN Trans = 'Rebroked' THEN
		CASE
			WHEN p.trans_type = 'Rebroked' THEN 1
			WHEN p.trans_type = 'New Business Inception' THEN 2
			WHEN p.trans_type = 'Quotation' THEN 3
			WHEN p.trans_type = 'Renewal Invitation' THEN 4
			WHEN p.trans_type = 'Renewal' THEN 5
			WHEN p.trans_type = 'MTA Inception' THEN 6
			WHEN p.trans_type = 'MTA Quotation' THEN 7
			WHEN p.trans_type = 'Cancellation NB' THEN 8
			WHEN p.trans_type = 'Cancellation' THEN 9
			ELSE 10
		END
		WHEN Trans = 'MTA Inception' THEN
		CASE
			WHEN p.trans_type = 'MTA Inception' THEN 1
			WHEN p.trans_type = 'MTA Quotation' THEN 2
			WHEN p.trans_type = 'Quotation' THEN 3
			WHEN p.trans_type = 'Renewal' THEN 4
			WHEN p.trans_type = 'Rebroked' THEN 5
			WHEN p.trans_type = 'New Business Inception' THEN 6
			WHEN p.trans_type = 'Renewal Invitation' THEN 7
			WHEN p.trans_type = 'Cancellation NB' THEN 8
			WHEN p.trans_type = 'Cancellation' THEN 9
			ELSE 10
		END
		WHEN Trans = 'Cancellation' THEN
		CASE
			WHEN p.trans_type = 'Cancellation' THEN 1
			WHEN p.trans_type = 'Cancellation NB' THEN 2
			WHEN p.trans_type = 'MTA Inception' THEN 3
			WHEN p.trans_type = 'MTA Quotation' THEN 4
			WHEN p.trans_type = 'Quotation' THEN 5
			WHEN p.trans_type = 'Renewal Invitation' THEN 6
			WHEN p.trans_type = 'Renewal' THEN 7
			WHEN p.trans_type = 'Rebroked' THEN 8
			WHEN p.trans_type = 'New Business Inception' THEN 9
			ELSE 10
		END
		ELSE 10
	END AS second_check
FROM TempIPNPayments IP
LEFT JOIN policy_info p ON IP.Client_Code = p.client_reference
LEFT JOIN policy_info p2 ON Trans LIKE p2.trans_type
LEFT JOIN client_info c ON IP.Client_Code = c.client_reference
GO

--Creates a reference table for the policy types the insurers offer
CREATE TABLE policy_types_insurer_protect (
	id INT IDENTITY(1,1),
	policy_type VARCHAR(MAX),
	policy_type_long VARCHAR(MAX)
);
INSERT INTO policy_types_insurer_protect (policy_type, policy_type_long)
    VALUES ('P/L', 'Liability'),('E/P','Employers and Liability'),('TLC', 'property and Liability'),('TRC','property Only Cover')
GO


CREATE TABLE insurerprotectlivepolicies (
	surname VARCHAR(MAX),
	firstname VARCHAR(MAX),
	companyname VARCHAR(MAX),
	client_id INT,
	policy_type VARCHAR(MAX),
	policy_number VARCHAR(MAX),
	insurer VARCHAR(MAX),
	scheme VARCHAR(MAX),
	inception_date DATE,
	renewal_date DATE
);


CREATE TABLE tempinsurerprotectlivepolicies (
	surname VARCHAR(MAX),
	firstname VARCHAR(MAX),
	companyname VARCHAR(MAX),
	client_id VARCHAR(MAX),
	policy_type VARCHAR(MAX),
	policy_number VARCHAR(MAX),
	insurer VARCHAR(MAX),
	scheme VARCHAR(MAX),
	inception_date VARCHAR(MAX),
	renewal_date VARCHAR(MAX)
);
GO


CREATE TABLE insurerprotect_nonstan_livepolicies (
	surname VARCHAR(MAX),
	firstname VARCHAR(MAX),
	companyname VARCHAR(MAX),
	client_id INT,
	policy_type VARCHAR(MAX),
	policy_number VARCHAR(MAX),
	insurer VARCHAR(MAX),
	scheme VARCHAR(MAX),
	inception_date DATE,
	renewal_date DATE
);


CREATE TABLE tempinsurerprotect_nonstan_livepolicies (
	surname VARCHAR(MAX),
	firstname VARCHAR(MAX),
	companyname VARCHAR(MAX),
	client_id VARCHAR(MAX),
	policy_type VARCHAR(MAX),
	policy_number VARCHAR(MAX),
	insurer VARCHAR(MAX),
	scheme VARCHAR(MAX),
	inception_date VARCHAR(MAX),
	renewal_date VARCHAR(MAX)
);
GO

--Selects all entries (there should be non) to check all tables are created and working
SELECT * FROM client_info;
SELECT * FROM policy_info;
SELECT * FROM TempClientData;
SELECT * FROM TempPolicyData;
SELECT * FROM TempIPPayments;
SELECT * FROM TempIPNPayments;
SELECT * FROM TempClientData2;
SELECT * FROM [results IP];
SELECT * FROM [results IPN];
SELECT * FROM insurerprotectlivepolicies;
SELECT * FROM tempinsurerprotectlivepolicies;
SELECT * FROM insurerprotect_nonstan_livepolicies;
SELECT * FROM tempinsurerprotect_nonstan_livepolicies;
SELECT * FROM policy_types_insurer_protect;