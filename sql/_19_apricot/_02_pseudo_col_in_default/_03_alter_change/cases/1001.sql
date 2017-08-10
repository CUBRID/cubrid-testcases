-- check that changes are visible in schema
CREATE TABLE tst (int_col int, 
				   float_col float, 
				   double_col double,
				   string_col string,
				   date_col date,
				   datetime_col datetime,
				   time_col time,
				   timestamp_col timestamp);
				   
DESCRIBE tst;

-- USER()
ALTER TABLE tst CHANGE COLUMN string_col string_col string default user();
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN string_col string_col string default 'string';
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN string_col string_col string default user();
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN string_col string_col string;
DESCRIBE tst;

-- CURRENT_USER()
ALTER TABLE tst CHANGE COLUMN string_col string_col string default current_user;
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN string_col string_col string default 'string';
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN string_col string_col string default current_user;
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN string_col string_col string;
DESCRIBE tst;

-- SYS_DATE
ALTER TABLE tst CHANGE COLUMN date_col date_col date default sys_date;
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN date_col date_col date default date'2011-01-01';
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN date_col date_col date default sys_date;
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN date_col date_col date;
DESCRIBE tst;

-- SYS_DATETIME
ALTER TABLE tst CHANGE COLUMN datetime_col datetime_col datetime default sys_datetime;
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN datetime_col datetime_col datetime default datetime'2011-01-01 12:34:56.789';
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN datetime_col datetime_col datetime;
DESCRIBE tst;

-- SYS_TIMESTAMP
ALTER TABLE tst CHANGE COLUMN timestamp_col timestamp_col timestamp default sys_timestamp;
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN timestamp_col timestamp_col timestamp default timestamp'2011-01-01 12:34:56';
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN timestamp_col timestamp_col timestamp;
DESCRIBE tst;

-- UNIX_TIMESTAMP()
ALTER TABLE tst CHANGE COLUMN timestamp_col timestamp_col timestamp default unix_timestamp();
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN timestamp_col timestamp_col timestamp default timestamp'2011-01-01 12:34:56';
DESCRIBE tst;

ALTER TABLE tst CHANGE COLUMN timestamp_col timestamp_col timestamp;
DESCRIBE tst;

DROP TABLE tst;
