--TC00: Check whether a Table can be created with
--      extended default like following:
--
--      default to_char(sysdatetime, 'YYYYMMDD')
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
SELECT default_value FROM db_attribute
WHERE class_name = 't1' and attr_name = 'col2';

DROP CLASS t1;
