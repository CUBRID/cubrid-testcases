--TC07: Check whether wrong format of default
--      can be detected
--
-- Notice:
--   This is CBRD-20399 enhancement.
--   So, apply this test case to former CUBRID
--   will lead to verdict 'fail'
--   'X' in format string is wrong
--   it should be 'YYYYMMDD' not
--                'XYYYMMDD'
DROP CLASS IF EXISTS t1;
---
-- create table with default
--
CREATE CLASS t1 (
	col1  int,
	col2 char(8) DEFAULT to_char(sysdatetime, 'XYYYMMDD')
);

