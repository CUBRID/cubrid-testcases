--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select minute('12:23:15');

select minute(str_to_date('2010-01-02 12:23:25', '%Y-%m-%d %H:%i:%s'));

select minute('2010-01-01 12:20:00');

create table minute_tests(char_col char(32), varchar_col varchar(32), 
			string_col string, 
			bit_col bit(16), 
			integer_col integer,
			smallint_col smallint,
			bigint_col bigint,
			float_col float,
			double_col double, 
			numeric_col numeric(10,2),
			monetary_col monetary,
			date_col DATETIME, 
			time_col TIME,
			timestamp_col timestamp,
			datetime_col datetime,
			set_col set(varchar(32), integer)
			);

insert into minute_tests values('2010-01-02 10:19:21','asdf','05/04/2010 12:23:15.123',NULL,12000,23,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, minute(char_col) from minute_tests order by smallint_col;
select varchar_col, minute(varchar_col) from minute_tests order by smallint_col;
select string_col, minute(string_col) from minute_tests order by smallint_col;
select bit_col, minute(bit_col) from minute_tests order by smallint_col;
select integer_col, minute(integer_col) from minute_tests order by smallint_col;
select smallint_col, minute(smallint_col) from minute_tests order by smallint_col;
select bigint_col, minute(bigint_col) from minute_tests order by smallint_col;
select float_col, minute(float_col) from minute_tests order by smallint_col;
select double_col, minute(double_col) from minute_tests order by smallint_col;
select numeric_col, minute(numeric_col) from minute_tests order by smallint_col;
select monetary_col, minute(monetary_col) from minute_tests order by smallint_col;
select date_col, minute(date_col) from minute_tests order by smallint_col;
select time_col, minute(time_col) from minute_tests order by smallint_col;
select timestamp_col, minute(timestamp_col) from minute_tests order by smallint_col;
select datetime_col, minute(datetime_col) from minute_tests order by smallint_col;
select set_col, minute(set_col) from minute_tests order by smallint_col;


select * from minute_tests where smallint_col < minute(varchar_col) order by smallint_col;
select * from minute_tests where smallint_col = minute('11:24:11')-1 order by smallint_col;

drop table minute_tests;

create table t (col varchar(255)) partition by list (minute(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;


create table minute_tests as select minute('10:11:12');

SELECT * FROM db_attribute where class_name='minute_tests';

select * from minute_tests;

drop table minute_tests;

create view minute_view(v) as select minute('2010-01-02 12:23:10') from db_root;

select * from minute_view;

drop minute_view;

$varchar, $2009-01-01 20:18:32
select minute(?) as rez;

$varchar, $2009-01-01 20:18:32
select minute(?) as rez;

$date, $1985-01-02
select minute(?) as rez;

$datetime, $01/02/1985 12:13:15
select minute(?) as rez;

-- test for valid date time format
select minute(datetime'2003-12-31 01:02:03.1234'), if (minute(datetime'2003-12-31 01:02:03.1234') = 2, 'ok', 'nok');
select minute(timestamp'2003-12-31 01:02:03'), if (minute(timestamp'2003-12-31 01:02:03') = 2, 'ok', 'nok');
select minute(time'01:02:03'), if (minute(time'01:02:03') = 2, 'ok', 'nok');


-- test for valid date, time string format
select minute('2003-12-31 01:02:03.1234'), if (minute('2003-12-31 01:02:03.1234') = 2, 'ok', 'nok');
select minute('2003-12-31 01:02:03'), if (minute('2003-12-31 01:02:03') = 2, 'ok', 'nok');
select minute('01:02:03'), if (minute('01:02:03') = 2, 'ok', 'nok');


-- test for valid current_*
SELECT if(minute(current_date) is null,'ok','not ok');
SELECT if(minute(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%i') AS INTEGER),'ok','not ok');
SELECT if(minute(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%i') AS INTEGER),'ok','not ok');
SELECT if(minute(current_time) = CAST(DATE_FORMAT(current_timestamp,'%i') AS INTEGER),'ok','not ok');



-- test for special case
select minute('23:59:59'), if (minute('23:59:59') = 59, 'ok', 'nok');
select minute('00:00:00'), if (minute('00:00:00') = 0, 'ok', 'nok');
select minute(time'00:00:00' - 1), if (minute(time'00:00:00' - 1) = 59, 'ok', 'nok');
select minute(time'23:59:59' + 1), if (minute(time'23:59:59' + 1) = 0, 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select minute('00:61:00');
select minute('00:-10:10');
select minute('2003-12-31');

set system parameters 'return_null_on_function_errors = no';

select minute('12:23:15');

select minute(str_to_date('2010-01-02 12:23:25', '%Y-%m-%d %H:%i:%s'));

select minute('2010-01-01 12:20:00');

create table minute_tests(char_col char(32), varchar_col varchar(32), 
			string_col string, 
			bit_col bit(16), 
			integer_col integer,
			smallint_col smallint,
			bigint_col bigint,
			float_col float,
			double_col double, 
			numeric_col numeric(10,2),
			monetary_col monetary,
			date_col DATETIME, 
			time_col TIME,
			timestamp_col timestamp,
			datetime_col datetime,
			set_col set(varchar(32), integer)
			);

insert into minute_tests values('2010-01-02 10:19:21','asdf','05/04/2010 12:23:15.123',NULL,12000,23,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, minute(char_col) from minute_tests order by smallint_col;
select varchar_col, minute(varchar_col) from minute_tests order by smallint_col;
select string_col, minute(string_col) from minute_tests order by smallint_col;
select bit_col, minute(bit_col) from minute_tests order by smallint_col;
select integer_col, minute(integer_col) from minute_tests order by smallint_col;
select smallint_col, minute(smallint_col) from minute_tests order by smallint_col;
select bigint_col, minute(bigint_col) from minute_tests order by smallint_col;
select float_col, minute(float_col) from minute_tests order by smallint_col;
select double_col, minute(double_col) from minute_tests order by smallint_col;
select numeric_col, minute(numeric_col) from minute_tests order by smallint_col;
select monetary_col, minute(monetary_col) from minute_tests order by smallint_col;
select date_col, minute(date_col) from minute_tests order by smallint_col;
select time_col, minute(time_col) from minute_tests order by smallint_col;
select timestamp_col, minute(timestamp_col) from minute_tests order by smallint_col;
select datetime_col, minute(datetime_col) from minute_tests order by smallint_col;
select set_col, minute(set_col) from minute_tests order by smallint_col;


select * from minute_tests where smallint_col < minute(varchar_col) order by smallint_col;
select * from minute_tests where smallint_col = minute('11:24:11')-1 order by smallint_col;

drop table minute_tests;

create table t (col varchar(255)) partition by list (minute(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;


create table minute_tests as select minute('10:11:12');

SELECT * FROM db_attribute where class_name='minute_tests';

select * from minute_tests;

drop table minute_tests;

create view minute_view(v) as select minute('2010-01-02 12:23:10') from db_root;

select * from minute_view;

drop minute_view;

$varchar, $2009-01-01 20:18:32
select minute(?) as rez;

$varchar, $2009-01-01 20:18:32
select minute(?) as rez;

$date, $1985-01-02
select minute(?) as rez;

$datetime, $01/02/1985 12:13:15
select minute(?) as rez;

-- test for valid date time format
select minute(datetime'2003-12-31 01:02:03.1234'), if (minute(datetime'2003-12-31 01:02:03.1234') = 2, 'ok', 'nok');
select minute(timestamp'2003-12-31 01:02:03'), if (minute(timestamp'2003-12-31 01:02:03') = 2, 'ok', 'nok');
select minute(time'01:02:03'), if (minute(time'01:02:03') = 2, 'ok', 'nok');


-- test for valid date, time string format
select minute('2003-12-31 01:02:03.1234'), if (minute('2003-12-31 01:02:03.1234') = 2, 'ok', 'nok');
select minute('2003-12-31 01:02:03'), if (minute('2003-12-31 01:02:03') = 2, 'ok', 'nok');
select minute('01:02:03'), if (minute('01:02:03') = 2, 'ok', 'nok');


-- test for valid current_*
SELECT if(minute(current_date) is null,'ok','not ok');
SELECT if(minute(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%i') AS INTEGER),'ok','not ok');
SELECT if(minute(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%i') AS INTEGER),'ok','not ok');
SELECT if(minute(current_time) = CAST(DATE_FORMAT(current_timestamp,'%i') AS INTEGER),'ok','not ok');



-- test for special case
select minute('23:59:59'), if (minute('23:59:59') = 59, 'ok', 'nok');
select minute('00:00:00'), if (minute('00:00:00') = 0, 'ok', 'nok');
select minute(time'00:00:00' - 1), if (minute(time'00:00:00' - 1) = 59, 'ok', 'nok');
select minute(time'23:59:59' + 1), if (minute(time'23:59:59' + 1) = 0, 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select minute('00:61:00');
select minute('00:-10:10');
select minute('2003-12-31');
commit;
--+ holdcas off;
