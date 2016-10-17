--TC08: Check whether use of wrong date type
--      can be detected
--      Currently, only 'sysdatetime' is supported
--
-- Notice:
--   This is CBRD-20399 enhancement.
--   So, apply this test case to former CUBRID
--   will lead to verdict 'fail'
--
DROP CLASS IF EXISTS t1;
---
-- create table with default
--
CREATE CLASS t1 (
	col1  int,
	col2 char(8) DEFAULT to_char(sysdate, 'YYYYMMDD')
);

