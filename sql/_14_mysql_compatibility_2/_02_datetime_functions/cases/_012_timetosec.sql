--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select time_to_sec('12:21:14') as q;

select time_to_sec('19:53:21') as q;

select time_to_sec('10:21:41') as q;

select time_to_sec('1983-01-01 08:01:01') as q;

select time_to_sec('00:00:00') as q;

select time_to_sec(str_to_date('12/25/1999 15:21:53', '%m/%d/%Y %H:%i:%s'));

select time_to_sec('2010-01-01 12:20:00');

create table time_to_sec_tests(char_col char(32), varchar_col varchar(32), 
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

insert into time_to_sec_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,22,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,3,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, time_to_sec(char_col) from time_to_sec_tests order by smallint_col;
select varchar_col, time_to_sec(varchar_col) from time_to_sec_tests order by smallint_col;
select string_col, time_to_sec(string_col) from time_to_sec_tests order by smallint_col;
select bit_col, time_to_sec(bit_col) from time_to_sec_tests order by smallint_col;
select integer_col, time_to_sec(integer_col) from time_to_sec_tests order by smallint_col;
select smallint_col, time_to_sec(smallint_col) from time_to_sec_tests order by smallint_col;
select bigint_col, time_to_sec(bigint_col) from time_to_sec_tests order by smallint_col;
select float_col, time_to_sec(float_col) from time_to_sec_tests order by smallint_col;
select double_col, time_to_sec(double_col) from time_to_sec_tests order by smallint_col;
select numeric_col, time_to_sec(numeric_col) from time_to_sec_tests order by smallint_col;
select monetary_col, time_to_sec(monetary_col) from time_to_sec_tests order by smallint_col;
select date_col, time_to_sec(date_col) from time_to_sec_tests order by smallint_col;
select time_col, time_to_sec(time_col) from time_to_sec_tests order by smallint_col;
select timestamp_col, time_to_sec(timestamp_col) from time_to_sec_tests order by smallint_col;
select datetime_col, time_to_sec(datetime_col) from time_to_sec_tests order by smallint_col;
select set_col, time_to_sec(set_col) from time_to_sec_tests order by smallint_col;


select * from time_to_sec_tests where smallint_col = time_to_sec('00:00:21')+1 order by smallint_col;
select * from time_to_sec_tests where smallint_col < time_to_sec(datetime_col) order by smallint_col;

create table t (col varchar(255)) partition by list (time_to_sec(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

drop table time_to_sec_tests;

create table time_to_sec_tests as select time_to_sec('14:32:11');

SELECT * FROM db_attribute where class_name='time_to_sec_tests';

select * from time_to_sec_tests;

drop table time_to_sec_tests;

create view time_to_sec_view(v) as select time_to_sec('14:32:11') from db_root;

select * from time_to_sec_view;

drop time_to_sec_view;

$varchar, $2009-12-12 20:18:32
select time_to_sec(?) as rez;

$date, $1985-01-02
select time_to_sec(?) as rez;

$datetime, $01/02/1985 12:13:15
select time_to_sec(?) as rez;

$time, $12:23:15
select time_to_sec(?) as rez;

$datetime, $01/02/1985 12:13:14
select 1 as rez from db_root where time_to_sec(?) = 43994;

$time, $12:13:14
select 1 as rez from db_root where time_to_sec(?) = 2;

-- test for valid date time format
select time_to_sec('2000-12-31 17:34:23.1234'), if (time_to_sec(datetime'2000-12-31 17:34:23.1234') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec(timestamp'2000-12-31 17:34:23'), if (time_to_sec(timestamp'2000-12-31 17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec(time'17:34:23'), if (time_to_sec(time'17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');


-- test for valid date, time string format
select time_to_sec('2000-12-31 17:34:23.1234'), if (time_to_sec('2000-12-31 17:34:23.1234') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec('2000-12-31 17:34:23'), if (time_to_sec('2000-12-31 17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec('17:34:23'), if (time_to_sec('17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');


-- test for valid current_*
select if (time_to_sec(current_datetime) - time_to_sec(current_time) = 0, 'ok', 'nok');
select if (time_to_sec(current_timestamp) - time_to_sec(current_time) = 0, 'ok', 'nok');
select if (time_to_sec(current_time) - time_to_sec(current_time) = 0, 'ok', 'nok');


-- test for normal case
select time_to_sec('00:00:00'), if (time_to_sec('00:00:00') = 0, 'ok', 'nok');
select time_to_sec('00:00:01'), if (time_to_sec('00:00:01') = 1, 'ok', 'nok');
select time_to_sec('00:01:00'), if (time_to_sec('00:01:00') = 60, 'ok', 'nok');
select time_to_sec('01:00:00'), if (time_to_sec('01:00:00') = 60*60, 'ok', 'nok');
select time_to_sec('03:12:30'), if (time_to_sec('03:12:30') = 3*60*60 + 12*60 + 30, 'ok', 'nok');



-- check if ER_TIME_CONVERSION is occured.
select time_to_sec('24:00:01');
select time_to_sec('00:00:60');

set system parameters 'return_null_on_function_errors = no';
select time_to_sec('12:21:14') as q;

select time_to_sec('19:53:21') as q;

select time_to_sec('10:21:41') as q;

select time_to_sec('1983-01-01 08:01:01') as q;

select time_to_sec('00:00:00') as q;

select time_to_sec(str_to_date('12/25/1999 15:21:53', '%m/%d/%Y %H:%i:%s'));

select time_to_sec('2010-01-01 12:20:00');

create table time_to_sec_tests(char_col char(32), varchar_col varchar(32), 
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

insert into time_to_sec_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,22,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,3,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, time_to_sec(char_col) from time_to_sec_tests order by smallint_col;
select varchar_col, time_to_sec(varchar_col) from time_to_sec_tests order by smallint_col;
select string_col, time_to_sec(string_col) from time_to_sec_tests order by smallint_col;
select bit_col, time_to_sec(bit_col) from time_to_sec_tests order by smallint_col;
select integer_col, time_to_sec(integer_col) from time_to_sec_tests order by smallint_col;
select smallint_col, time_to_sec(smallint_col) from time_to_sec_tests order by smallint_col;
select bigint_col, time_to_sec(bigint_col) from time_to_sec_tests order by smallint_col;
select float_col, time_to_sec(float_col) from time_to_sec_tests order by smallint_col;
select double_col, time_to_sec(double_col) from time_to_sec_tests order by smallint_col;
select numeric_col, time_to_sec(numeric_col) from time_to_sec_tests order by smallint_col;
select monetary_col, time_to_sec(monetary_col) from time_to_sec_tests order by smallint_col;
select date_col, time_to_sec(date_col) from time_to_sec_tests order by smallint_col;
select time_col, time_to_sec(time_col) from time_to_sec_tests order by smallint_col;
select timestamp_col, time_to_sec(timestamp_col) from time_to_sec_tests order by smallint_col;
select datetime_col, time_to_sec(datetime_col) from time_to_sec_tests order by smallint_col;
select set_col, time_to_sec(set_col) from time_to_sec_tests order by smallint_col;


select * from time_to_sec_tests where smallint_col = time_to_sec('00:00:21')+1 order by smallint_col;
select * from time_to_sec_tests where smallint_col < time_to_sec(datetime_col) order by smallint_col;

create table t (col varchar(255)) partition by list (time_to_sec(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

drop table time_to_sec_tests;

create table time_to_sec_tests as select time_to_sec('14:32:11');

SELECT * FROM db_attribute where class_name='time_to_sec_tests';

select * from time_to_sec_tests;

drop table time_to_sec_tests;

create view time_to_sec_view(v) as select time_to_sec('14:32:11') from db_root;

select * from time_to_sec_view;

drop time_to_sec_view;

$varchar, $2009-12-12 20:18:32
select time_to_sec(?) as rez;

$date, $1985-01-02
select time_to_sec(?) as rez;

$datetime, $01/02/1985 12:13:15
select time_to_sec(?) as rez;

$time, $12:23:15
select time_to_sec(?) as rez;

$datetime, $01/02/1985 12:13:14
select 1 as rez from db_root where time_to_sec(?) = 43994;

$time, $12:13:14
select 1 as rez from db_root where time_to_sec(?) = 2;

-- test for valid date time format
select time_to_sec('2000-12-31 17:34:23.1234'), if (time_to_sec(datetime'2000-12-31 17:34:23.1234') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec(timestamp'2000-12-31 17:34:23'), if (time_to_sec(timestamp'2000-12-31 17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec(time'17:34:23'), if (time_to_sec(time'17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');


-- test for valid date, time string format
select time_to_sec('2000-12-31 17:34:23.1234'), if (time_to_sec('2000-12-31 17:34:23.1234') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec('2000-12-31 17:34:23'), if (time_to_sec('2000-12-31 17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec('17:34:23'), if (time_to_sec('17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');


-- test for valid current_*
select if (time_to_sec(current_datetime) - time_to_sec(current_time) = 0, 'ok', 'nok');
select if (time_to_sec(current_timestamp) - time_to_sec(current_time) = 0, 'ok', 'nok');
select if (time_to_sec(current_time) - time_to_sec(current_time) = 0, 'ok', 'nok');


-- test for normal case
select time_to_sec('00:00:00'), if (time_to_sec('00:00:00') = 0, 'ok', 'nok');
select time_to_sec('00:00:01'), if (time_to_sec('00:00:01') = 1, 'ok', 'nok');
select time_to_sec('00:01:00'), if (time_to_sec('00:01:00') = 60, 'ok', 'nok');
select time_to_sec('01:00:00'), if (time_to_sec('01:00:00') = 60*60, 'ok', 'nok');
select time_to_sec('03:12:30'), if (time_to_sec('03:12:30') = 3*60*60 + 12*60 + 30, 'ok', 'nok');



-- check if ER_TIME_CONVERSION is occured.
select time_to_sec('24:00:01');
select time_to_sec('00:00:60');
commit;
--+ holdcas off;
