--+ holdcas on;
set system parameters 'return_null_on_function_errors=yes';
select month('2010-01-01');

select month('01/01/2010');

select month(str_to_date('12/25/1999', '%m/%d/%Y'));

select month('2010-01-01 12:20:00');

create table month_tests(char_col char(32), varchar_col varchar(32), 
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

insert into month_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,0,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02 17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, month(char_col) from month_tests order by smallint_col;
select varchar_col, month(varchar_col) from month_tests order by smallint_col;
select string_col, month(string_col) from month_tests order by smallint_col;
select bit_col, month(bit_col) from month_tests order by smallint_col;
select integer_col, month(integer_col) from month_tests order by smallint_col;
select smallint_col, month(smallint_col) from month_tests order by smallint_col;
select bigint_col, month(bigint_col) from month_tests order by smallint_col;
select float_col, month(float_col) from month_tests order by smallint_col;
select double_col, month(double_col) from month_tests order by smallint_col;
select numeric_col, month(numeric_col) from month_tests order by smallint_col;
select monetary_col, month(monetary_col) from month_tests order by smallint_col;
select date_col, month(date_col) from month_tests order by smallint_col;
select time_col, month(time_col) from month_tests order by smallint_col;
select timestamp_col, month(timestamp_col) from month_tests order by smallint_col;
select datetime_col, month(datetime_col) from month_tests order by smallint_col;
select set_col, month(set_col) from month_tests order by smallint_col;

select * from month_tests where smallint_col < month(varchar_col) order by smallint_col;
select * from month_tests where smallint_col = month('2010-01-02')-1 order by smallint_col;

drop table month_tests;

create table t (col varchar(255)) partition by list (month(col)) (PARTITION P0 VALUES IN (2010, 2011));
drop table t;

create table month_tests as select month('2010-01-02') as [ month('2010-01-02')];

SELECT * FROM db_attribute where class_name='month_tests';

select * from month_tests;

drop table month_tests;

create view month_view(v) as select month('2010-01-02') from db_root;

select * from month_view;

drop month_view;

$varchar, $2009-01-01 20:18:32
select month(?) as rez;

$varchar, $2009-01-01 20:18:32
select month(?) as rez;

$date, $1985-01-02
select month(?) as rez;

$datetime, $01/02/1985 12:13:15
select month(?) as rez;

--wrong type of hostvar
$int, $12
select month(?) as rez;

--wrong string format
$varchar, $2010
select month(?) as rez;

-- test for valid date time format
select month(datetime'2003-12-31 01:02:03.1234'), if (month(datetime'2003-12-31 01:02:03.1234') = 12, 'ok', 'nok');
select month(timestamp'2003-12-31 01:02:03'), if (month(timestamp'2003-12-31 01:02:03') = 12, 'ok', 'nok');
select month(date'2003-12-31'), if (month(date'2003-12-31') = 12, 'ok', 'nok');


-- test for valid date, time string format
select month('2003-12-31 01:02:03.1234'), if (month('2003-12-31 01:02:03.1234') = 12, 'ok', 'nok');
select month('2003-12-31 01:02:03'), if (month('2003-12-31 01:02:03') = 12, 'ok', 'nok');
select month('2003-12-31'), if (month('2003-12-31') = 12, 'ok', 'nok');


-- test for valid current_*
SELECT if(month(current_date) = CAST(DATE_FORMAT(current_date,'%c') AS INTEGER),'ok','not ok');
SELECT if(month(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%c') AS INTEGER),'ok','not ok');
SELECT if(month(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%c') AS INTEGER),'ok','not ok');

-- test for special case
select month('1-1-1'), if (month('1-1-1') = 1, 'ok', 'nok');
select month('1/1/1'), if (month('1/1/1') = 1, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select month('2000-00-31 01:02:03');
select month('2000-13-31 01:02:03');
select month('2000-12-32 01:02:03');
select month('1999-2-29 01:02:03');

select month('01:02:03');

set system parameters 'return_null_on_function_errors = no';
select month('2010-01-01');

select month('01/01/2010');

select month(str_to_date('12/25/1999', '%m/%d/%Y'));

select month('2010-01-01 12:20:00');

create table month_tests(char_col char(32), varchar_col varchar(32), 
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

insert into month_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,0,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02 17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, month(char_col) from month_tests order by smallint_col;
select varchar_col, month(varchar_col) from month_tests order by smallint_col;
select string_col, month(string_col) from month_tests order by smallint_col;
select bit_col, month(bit_col) from month_tests order by smallint_col;
select integer_col, month(integer_col) from month_tests order by smallint_col;
select smallint_col, month(smallint_col) from month_tests order by smallint_col;
select bigint_col, month(bigint_col) from month_tests order by smallint_col;
select float_col, month(float_col) from month_tests order by smallint_col;
select double_col, month(double_col) from month_tests order by smallint_col;
select numeric_col, month(numeric_col) from month_tests order by smallint_col;
select monetary_col, month(monetary_col) from month_tests order by smallint_col;
select date_col, month(date_col) from month_tests order by smallint_col;
select time_col, month(time_col) from month_tests order by smallint_col;
select timestamp_col, month(timestamp_col) from month_tests order by smallint_col;
select datetime_col, month(datetime_col) from month_tests order by smallint_col;
select set_col, month(set_col) from month_tests order by smallint_col;

select * from month_tests where smallint_col < month(varchar_col) order by smallint_col;
select * from month_tests where smallint_col = month('2010-01-02')-1 order by smallint_col;

drop table month_tests;

create table t (col varchar(255)) partition by list (month(col)) (PARTITION P0 VALUES IN (2010, 2011));
drop table t;

create table month_tests as select month('2010-01-02') as [ month('2010-01-02')];

SELECT * FROM db_attribute where class_name='month_tests';

select * from month_tests;

drop table month_tests;

create view month_view(v) as select month('2010-01-02') from db_root;

select * from month_view;

drop month_view;

$varchar, $2009-01-01 20:18:32
select month(?) as rez;

$varchar, $2009-01-01 20:18:32
select month(?) as rez;

$date, $1985-01-02
select month(?) as rez;

$datetime, $01/02/1985 12:13:15
select month(?) as rez;

--wrong type of hostvar
$int, $12
select month(?) as rez;

--wrong string format
$varchar, $2010
select month(?) as rez;

-- test for valid date time format
select month(datetime'2003-12-31 01:02:03.1234'), if (month(datetime'2003-12-31 01:02:03.1234') = 12, 'ok', 'nok');
select month(timestamp'2003-12-31 01:02:03'), if (month(timestamp'2003-12-31 01:02:03') = 12, 'ok', 'nok');
select month(date'2003-12-31'), if (month(date'2003-12-31') = 12, 'ok', 'nok');


-- test for valid date, time string format
select month('2003-12-31 01:02:03.1234'), if (month('2003-12-31 01:02:03.1234') = 12, 'ok', 'nok');
select month('2003-12-31 01:02:03'), if (month('2003-12-31 01:02:03') = 12, 'ok', 'nok');
select month('2003-12-31'), if (month('2003-12-31') = 12, 'ok', 'nok');


-- test for valid current_*
SELECT if(month(current_date) = CAST(DATE_FORMAT(current_date,'%c') AS INTEGER),'ok','not ok');
SELECT if(month(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%c') AS INTEGER),'ok','not ok');
SELECT if(month(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%c') AS INTEGER),'ok','not ok');


-- test for special case
select month('1-1-1'), if (month('1-1-1') = 1, 'ok', 'nok');
select month('1/1/1'), if (month('1/1/1') = 1, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select month('2000-00-31 01:02:03');
select month('2000-13-31 01:02:03');
select month('2000-12-32 01:02:03');
select month('1999-2-29 01:02:03');

select month('01:02:03');
commit;
--+ holdcas off;
set system parameters 'return_null_on_function_errors=no';
