-- check that changes are visible in schema
CREATE TABLE tst (int_col int, 
				   float_col float, 
				   double_col double);
DESCRIBE tst;

-- USER()
ALTER TABLE tst ADD COLUMN string_col string default user();
DESCRIBE tst;

-- CURRENT_USER()
ALTER TABLE tst ADD COLUMN string_col2 string default current_user;
DESCRIBE tst;

-- SYS_DATE
ALTER TABLE tst ADD COLUMN date_col date default sys_date;
DESCRIBE tst;


-- SYS_DATETIME
ALTER TABLE tst ADD COLUMN datetime_col datetime default sys_datetime;
DESCRIBE tst;

-- SYS_TIMESTAMP
ALTER TABLE tst ADD COLUMN timestamp_col timestamp default sys_timestamp;
DESCRIBE tst;

-- UNIX_TIMESTAMP()
ALTER TABLE tst ADD COLUMN timestamp_col2 timestamp default unix_timestamp();
DESCRIBE tst;

DROP TABLE tst;