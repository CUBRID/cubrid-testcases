--TC00: Check whether a table can be created with
--      default to_char(sysdatetime, ...)
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
	col2 char(8) DEFAULT to_char(sysdatetime, 'YYYYMMDD')
);

--
--
SELECT default_value FROM db_attribute
WHERE class_name = 't1' and attr_name = 'col2';

DROP CLASS t1;
