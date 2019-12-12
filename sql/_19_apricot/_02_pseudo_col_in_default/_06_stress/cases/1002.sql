CREATE TABLE tst (col_1 int,
		  col_2 int,
		  col_3 int,
		  col_4 int,
		  col_5 int,
		  col_6 int,
		  col_7 int,
		  col_8 int,
		  col_9 int,
		  col_10 int,
		  col_11 int,
		  col_12 int,
		  col_13 int,
		  col_14 int,
		  col_15 int,
		  col_16 int,
		  col_17 int,
		  col_18 int,
		  col_19 int,
		  col_20 int);
		  
ALTER TABLE tst change column col_1 col_1 string default user();

ALTER TABLE tst change column col_2 col_2 string default user();

ALTER TABLE tst change column col_3 col_3 string default user();

ALTER TABLE tst change column col_4 col_4 string default user();

ALTER TABLE tst change column col_5 col_5 string default user();

ALTER TABLE tst change column col_6 col_6 string default user();

ALTER TABLE tst change column col_7 col_7 string default user();

ALTER TABLE tst change column col_8 col_8 string default user();

ALTER TABLE tst change column col_9 col_9 string default user();

ALTER TABLE tst change column col_10 col_10 string default user();

ALTER TABLE tst change column col_11 col_11 string default user();

ALTER TABLE tst change column col_12 col_12 string default user();

ALTER TABLE tst change column col_13 col_13 string default user();

ALTER TABLE tst change column col_14 col_14 string default user();

ALTER TABLE tst change column col_15 col_15 string default user();

ALTER TABLE tst change column col_16 col_16 string default user();

ALTER TABLE tst change column col_17 col_17 string default user();

ALTER TABLE tst change column col_18 col_18 string default user();

ALTER TABLE tst change column col_19 col_19 string default user();

ALTER TABLE tst change column col_20 col_20 string default user();

DESCRIBE tst;



ALTER TABLE tst change column col_1 col_1 int default 10;

ALTER TABLE tst change column col_2 col_2 int default 10;

ALTER TABLE tst change column col_3 col_3 int default 10;

ALTER TABLE tst change column col_4 col_4 int default 10;

ALTER TABLE tst change column col_5 col_5 int default 10;

ALTER TABLE tst change column col_6 col_6 int default 10;

ALTER TABLE tst change column col_7 col_7 int default 10;

ALTER TABLE tst change column col_8 col_8 int default 10;

ALTER TABLE tst change column col_9 col_9 int default 10;

ALTER TABLE tst change column col_10 col_10 int default 10;

ALTER TABLE tst change column col_11 col_11 int default 10;

ALTER TABLE tst change column col_12 col_12 int default 10;

ALTER TABLE tst change column col_13 col_13 int default 10;

ALTER TABLE tst change column col_14 col_14 int default 10;

ALTER TABLE tst change column col_15 col_15 int default 10;

ALTER TABLE tst change column col_16 col_16 int default 10;

ALTER TABLE tst change column col_17 col_17 int default 10;

ALTER TABLE tst change column col_18 col_18 int default 10;

ALTER TABLE tst change column col_19 col_19 int default 10;

ALTER TABLE tst change column col_20 col_20 int default 10;

DESCRIBE tst;




ALTER TABLE tst change column col_1 col_1 string default current_user;

ALTER TABLE tst change column col_2 col_2 string default current_user;

ALTER TABLE tst change column col_3 col_3 string default current_user;

ALTER TABLE tst change column col_4 col_4 string default current_user;

ALTER TABLE tst change column col_5 col_5 string default current_user;

ALTER TABLE tst change column col_6 col_6 string default current_user;

ALTER TABLE tst change column col_7 col_7 string default current_user;

ALTER TABLE tst change column col_8 col_8 string default current_user;

ALTER TABLE tst change column col_9 col_9 string default current_user;

ALTER TABLE tst change column col_10 col_10 string default current_user;

ALTER TABLE tst change column col_11 col_11 string default current_user;

ALTER TABLE tst change column col_12 col_12 string default current_user;

ALTER TABLE tst change column col_13 col_13 string default current_user;

ALTER TABLE tst change column col_14 col_14 string default current_user;

ALTER TABLE tst change column col_15 col_15 string default current_user;

ALTER TABLE tst change column col_16 col_16 string default current_user;

ALTER TABLE tst change column col_17 col_17 string default current_user;

ALTER TABLE tst change column col_18 col_18 string default current_user;

ALTER TABLE tst change column col_19 col_19 string default current_user;

ALTER TABLE tst change column col_20 col_20 string default current_user;

DESCRIBE tst;


ALTER TABLE tst change column col_1 col_1 date default sys_date;

ALTER TABLE tst change column col_2 col_2 date default sys_date;

ALTER TABLE tst change column col_3 col_3 date default sys_date;

ALTER TABLE tst change column col_4 col_4 date default sys_date;

ALTER TABLE tst change column col_5 col_5 date default sys_date;

ALTER TABLE tst change column col_6 col_6 date default sys_date;

ALTER TABLE tst change column col_7 col_7 date default sys_date;

ALTER TABLE tst change column col_8 col_8 date default sys_date;

ALTER TABLE tst change column col_9 col_9 date default sys_date;

ALTER TABLE tst change column col_10 col_10 date default sys_date;

ALTER TABLE tst change column col_11 col_11 date default sys_date;

ALTER TABLE tst change column col_12 col_12 date default sys_date;

ALTER TABLE tst change column col_13 col_13 date default sys_date;

ALTER TABLE tst change column col_14 col_14 date default sys_date;

ALTER TABLE tst change column col_15 col_15 date default sys_date;

ALTER TABLE tst change column col_16 col_16 date default sys_date;

ALTER TABLE tst change column col_17 col_17 date default sys_date;

ALTER TABLE tst change column col_18 col_18 date default sys_date;

ALTER TABLE tst change column col_19 col_19 date default sys_date;

ALTER TABLE tst change column col_20 col_20 date default sys_date;

DESCRIBE tst;



ALTER TABLE tst change column col_1 col_1 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_2 col_2 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_3 col_3 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_4 col_4 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_5 col_5 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_6 col_6 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_7 col_7 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_8 col_8 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_9 col_9 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_10 col_10 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_11 col_11 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_12 col_12 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_13 col_13 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_14 col_14 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_15 col_15 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_16 col_16 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_17 col_17 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_18 col_18 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_19 col_19 datetime default datetime'2011-01-01';

ALTER TABLE tst change column col_20 col_20 datetime default datetime'2011-01-01';

DESCRIBE tst;



ALTER TABLE tst change column col_1 col_1 datetime default sys_datetime;

ALTER TABLE tst change column col_2 col_2 datetime default sys_datetime;

ALTER TABLE tst change column col_3 col_3 datetime default sys_datetime;

ALTER TABLE tst change column col_4 col_4 datetime default sys_datetime;

ALTER TABLE tst change column col_5 col_5 datetime default sys_datetime;

ALTER TABLE tst change column col_6 col_6 datetime default sys_datetime;

ALTER TABLE tst change column col_7 col_7 datetime default sys_datetime;

ALTER TABLE tst change column col_8 col_8 datetime default sys_datetime;

ALTER TABLE tst change column col_9 col_9 datetime default sys_datetime;

ALTER TABLE tst change column col_10 col_10 datetime default sys_datetime;

ALTER TABLE tst change column col_11 col_11 datetime default sys_datetime;

ALTER TABLE tst change column col_12 col_12 datetime default sys_datetime;

ALTER TABLE tst change column col_13 col_13 datetime default sys_datetime;

ALTER TABLE tst change column col_14 col_14 datetime default sys_datetime;

ALTER TABLE tst change column col_15 col_15 datetime default sys_datetime;

ALTER TABLE tst change column col_16 col_16 datetime default sys_datetime;

ALTER TABLE tst change column col_17 col_17 datetime default sys_datetime;

ALTER TABLE tst change column col_18 col_18 datetime default sys_datetime;

ALTER TABLE tst change column col_19 col_19 datetime default sys_datetime;

ALTER TABLE tst change column col_20 col_20 datetime default sys_datetime;

DESCRIBE tst;



ALTER TABLE tst change column col_1 col_1 string default 'default_string';

ALTER TABLE tst change column col_2 col_2 string default 'default_string';

ALTER TABLE tst change column col_3 col_3 string default 'default_string';

ALTER TABLE tst change column col_4 col_4 string default 'default_string';

ALTER TABLE tst change column col_5 col_5 string default 'default_string';

ALTER TABLE tst change column col_6 col_6 string default 'default_string';

ALTER TABLE tst change column col_7 col_7 string default 'default_string';

ALTER TABLE tst change column col_8 col_8 string default 'default_string';

ALTER TABLE tst change column col_9 col_9 string default 'default_string';

ALTER TABLE tst change column col_10 col_10 string default 'default_string';

ALTER TABLE tst change column col_11 col_11 string default 'default_string';

ALTER TABLE tst change column col_12 col_12 string default 'default_string';

ALTER TABLE tst change column col_13 col_13 string default 'default_string';

ALTER TABLE tst change column col_14 col_14 string default 'default_string';

ALTER TABLE tst change column col_15 col_15 string default 'default_string';

ALTER TABLE tst change column col_16 col_16 string default 'default_string';

ALTER TABLE tst change column col_17 col_17 string default 'default_string';

ALTER TABLE tst change column col_18 col_18 string default 'default_string';

ALTER TABLE tst change column col_19 col_19 string default 'default_string';

ALTER TABLE tst change column col_20 col_20 string default 'default_string';

DESCRIBE tst;




ALTER TABLE tst change column col_1 col_1 timestamp default sys_timestamp;

ALTER TABLE tst change column col_2 col_2 timestamp default sys_timestamp;

ALTER TABLE tst change column col_3 col_3 timestamp default sys_timestamp;

ALTER TABLE tst change column col_4 col_4 timestamp default sys_timestamp;

ALTER TABLE tst change column col_5 col_5 timestamp default sys_timestamp;

ALTER TABLE tst change column col_6 col_6 timestamp default sys_timestamp;

ALTER TABLE tst change column col_7 col_7 timestamp default sys_timestamp;

ALTER TABLE tst change column col_8 col_8 timestamp default sys_timestamp;

ALTER TABLE tst change column col_9 col_9 timestamp default sys_timestamp;

ALTER TABLE tst change column col_10 col_10 timestamp default sys_timestamp;

ALTER TABLE tst change column col_11 col_11 timestamp default sys_timestamp;

ALTER TABLE tst change column col_12 col_12 timestamp default sys_timestamp;

ALTER TABLE tst change column col_13 col_13 timestamp default sys_timestamp;

ALTER TABLE tst change column col_14 col_14 timestamp default sys_timestamp;

ALTER TABLE tst change column col_15 col_15 timestamp default sys_timestamp;

ALTER TABLE tst change column col_16 col_16 timestamp default sys_timestamp;

ALTER TABLE tst change column col_17 col_17 timestamp default sys_timestamp;

ALTER TABLE tst change column col_18 col_18 timestamp default sys_timestamp;

ALTER TABLE tst change column col_19 col_19 timestamp default sys_timestamp;

ALTER TABLE tst change column col_20 col_20 timestamp default sys_timestamp;

DESCRIBE tst;




ALTER TABLE tst change column col_1 col_1 date default date'2011-01-01';

ALTER TABLE tst change column col_2 col_2 date default date'2011-01-01';

ALTER TABLE tst change column col_3 col_3 date default date'2011-01-01';

ALTER TABLE tst change column col_4 col_4 date default date'2011-01-01';

ALTER TABLE tst change column col_5 col_5 date default date'2011-01-01';

ALTER TABLE tst change column col_6 col_6 date default date'2011-01-01';

ALTER TABLE tst change column col_7 col_7 date default date'2011-01-01';

ALTER TABLE tst change column col_8 col_8 date default date'2011-01-01';

ALTER TABLE tst change column col_9 col_9 date default date'2011-01-01';

ALTER TABLE tst change column col_10 col_10 date default date'2011-01-01';

ALTER TABLE tst change column col_11 col_11 date default date'2011-01-01';

ALTER TABLE tst change column col_12 col_12 date default date'2011-01-01';

ALTER TABLE tst change column col_13 col_13 date default date'2011-01-01';

ALTER TABLE tst change column col_14 col_14 date default date'2011-01-01';

ALTER TABLE tst change column col_15 col_15 date default date'2011-01-01';

ALTER TABLE tst change column col_16 col_16 date default date'2011-01-01';

ALTER TABLE tst change column col_17 col_17 date default date'2011-01-01';

ALTER TABLE tst change column col_18 col_18 date default date'2011-01-01';

ALTER TABLE tst change column col_19 col_19 date default date'2011-01-01';

ALTER TABLE tst change column col_20 col_20 date default date'2011-01-01';

DESCRIBE tst;




ALTER TABLE tst change column col_1 col_1 timestamp default unix_timestamp();

ALTER TABLE tst change column col_2 col_2 timestamp default unix_timestamp();

ALTER TABLE tst change column col_3 col_3 timestamp default unix_timestamp();

ALTER TABLE tst change column col_4 col_4 timestamp default unix_timestamp();

ALTER TABLE tst change column col_5 col_5 timestamp default unix_timestamp();

ALTER TABLE tst change column col_6 col_6 timestamp default unix_timestamp();

ALTER TABLE tst change column col_7 col_7 timestamp default unix_timestamp();

ALTER TABLE tst change column col_8 col_8 timestamp default unix_timestamp();

ALTER TABLE tst change column col_9 col_9 timestamp default unix_timestamp();

ALTER TABLE tst change column col_10 col_10 timestamp default unix_timestamp();

ALTER TABLE tst change column col_11 col_11 timestamp default unix_timestamp();

ALTER TABLE tst change column col_12 col_12 timestamp default unix_timestamp();

ALTER TABLE tst change column col_13 col_13 timestamp default unix_timestamp();

ALTER TABLE tst change column col_14 col_14 timestamp default unix_timestamp();

ALTER TABLE tst change column col_15 col_15 timestamp default unix_timestamp();

ALTER TABLE tst change column col_16 col_16 timestamp default unix_timestamp();

ALTER TABLE tst change column col_17 col_17 timestamp default unix_timestamp();

ALTER TABLE tst change column col_18 col_18 timestamp default unix_timestamp();

ALTER TABLE tst change column col_19 col_19 timestamp default unix_timestamp();

ALTER TABLE tst change column col_20 col_20 timestamp default unix_timestamp();

DESCRIBE tst;



ALTER TABLE tst change column col_1 col_1 time default time'12:34:56';

ALTER TABLE tst change column col_2 col_2 time default time'12:34:56';

ALTER TABLE tst change column col_3 col_3 time default time'12:34:56';

ALTER TABLE tst change column col_4 col_4 time default time'12:34:56';

ALTER TABLE tst change column col_5 col_5 time default time'12:34:56';

ALTER TABLE tst change column col_6 col_6 time default time'12:34:56';

ALTER TABLE tst change column col_7 col_7 time default time'12:34:56';

ALTER TABLE tst change column col_8 col_8 time default time'12:34:56';

ALTER TABLE tst change column col_9 col_9 time default time'12:34:56';

ALTER TABLE tst change column col_10 col_10 time default time'12:34:56';

ALTER TABLE tst change column col_11 col_11 time default time'12:34:56';

ALTER TABLE tst change column col_12 col_12 time default time'12:34:56';

ALTER TABLE tst change column col_13 col_13 time default time'12:34:56';

ALTER TABLE tst change column col_14 col_14 time default time'12:34:56';

ALTER TABLE tst change column col_15 col_15 time default time'12:34:56';

ALTER TABLE tst change column col_16 col_16 time default time'12:34:56';

ALTER TABLE tst change column col_17 col_17 time default time'12:34:56';

ALTER TABLE tst change column col_18 col_18 time default time'12:34:56';

ALTER TABLE tst change column col_19 col_19 time default time'12:34:56';

ALTER TABLE tst change column col_20 col_20 time default time'12:34:56';

DESCRIBE tst;

DROP TABLE tst;