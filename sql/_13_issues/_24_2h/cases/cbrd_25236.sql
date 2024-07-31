-- This issue verifies CBRD-25236 issue.
-- Output error related to TZM in timezone information
-- The results of to_char(), date_format(), and time_format() must always be expressed the same.
-- The relevant matter has been verified through various existing cases with below PR.
-- https://github.com/CUBRID/cubrid-testcases/pull/1625


set timezone '-09:10';
select 'set timezone -09:10';
SELECT  TO_CHAR(datetime'2009-10-04 11:07:00', 'TZH TZM TZH:TZM'), DATE_FORMAT(datetime'2009-10-04 11:07:00', '%TZH %TZM %TZH:%TZM'), TIME_FORMAT(datetime'2009-10-04 11:07:00', '%TZH %TZM  %TZH:%TZM');
		
set timezone '-00:20';		
select 'set timezone -00:20';		
SELECT  TO_CHAR(datetime'2009-10-04 11:07:00', 'TZH TZM TZH:TZM'), DATE_FORMAT(datetime'2009-10-04 11:07:00', '%TZH %TZM %TZH:%TZM'), TIME_FORMAT(datetime'2009-10-04 11:07:00', '%TZH %TZM  %TZH:%TZM');		

set timezone '+09:10';
select 'set timezone +09:10';
SELECT  TO_CHAR(datetime'2009-10-04 11:07:00', 'TZH TZM TZH:TZM'), DATE_FORMAT(datetime'2009-10-04 11:07:00', '%TZH %TZM %TZH:%TZM'), TIME_FORMAT(datetime'2009-10-04 11:07:00', '%TZH %TZM  %TZH:%TZM');
		
set timezone '+00:20';		
select 'set timezone +00:20';		
SELECT  TO_CHAR(datetime'2009-10-04 11:07:00', 'TZH TZM TZH:TZM'), DATE_FORMAT(datetime'2009-10-04 11:07:00', '%TZH %TZM %TZH:%TZM'), TIME_FORMAT(datetime'2009-10-04 11:07:00', '%TZH %TZM  %TZH:%TZM');
