--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select hour('12:23:15');

select hour(str_to_date('2010-01-02 12:23:25', '%Y-%m-%d %H:%i:%s'));

select hour('2010-01-01 12:20:00');

create table hour_tests(char_col char(32), varchar_col varchar(32), 
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

insert into hour_tests values('2010-01-02 10:19:21','asdf','05/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, hour(char_col) from hour_tests order by smallint_col;
select varchar_col, hour(varchar_col) from hour_tests order by smallint_col;
select string_col, hour(string_col) from hour_tests order by smallint_col;
select bit_col, hour(bit_col) from hour_tests order by smallint_col;
select integer_col, hour(integer_col) from hour_tests order by smallint_col;
select smallint_col, hour(smallint_col) from hour_tests order by smallint_col;
select bigint_col, hour(bigint_col) from hour_tests order by smallint_col;
select float_col, hour(float_col) from hour_tests order by smallint_col;
select double_col, hour(double_col) from hour_tests order by smallint_col;
select numeric_col, hour(numeric_col) from hour_tests order by smallint_col;
select monetary_col, hour(monetary_col) from hour_tests order by smallint_col;
select date_col, hour(date_col) from hour_tests order by smallint_col;
select time_col, hour(time_col) from hour_tests order by smallint_col;
select timestamp_col, hour(timestamp_col) from hour_tests order by smallint_col;
select datetime_col, hour(datetime_col) from hour_tests order by smallint_col;
select set_col, hour(set_col) from hour_tests order by smallint_col;


select * from hour_tests where smallint_col < hour(varchar_col) order by smallint_col;
select * from hour_tests where smallint_col = hour('11:24:11')-1 order by smallint_col;

drop table hour_tests;

create table t (col varchar(255)) partition by list (hour(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table hour_tests as select hour('2010-01-02') as [ hour('2010-01-02')];

SELECT * FROM db_attribute where class_name='hour_tests';

select * from hour_tests;

drop table hour_tests;

create view hour_view(v) as select hour('2010-01-02 12:23:10') from db_root;

select * from hour_view;

drop hour_view;

$varchar, $2009-01-01 20:18:32
select hour(?) as rez;

$varchar, $2009-01-01 20:18:32
select hour(?) as rez;

$date, $1985-01-02
select hour(?) as rez;

$datetime, $01/02/1985 12:13:15
select hour(?) as rez;

-- test for valid date time format
select hour(datetime'2003-12-31 01:02:03.1234'), if (hour(datetime'2003-12-31 01:02:03.1234') = 1, 'ok', 'nok');
select hour(timestamp'2003-12-31 01:02:03'), if (hour(timestamp'2003-12-31 01:02:03') = 1, 'ok', 'nok');
select hour(time'01:02:03'), if (hour(time'01:02:03') = 1, 'ok', 'nok');


-- test for valid date, time string format
select hour('2003-12-31 01:02:03.1234'), if (hour('2003-12-31 01:02:03.1234') = 1, 'ok', 'nok');
select hour('2003-12-31 01:02:03'), if (hour('2003-12-31 01:02:03') = 1, 'ok', 'nok');
select hour('01:02:03'), if (hour('01:02:03') = 1, 'ok', 'nok');


-- test for valid current_*
SELECT if(hour(current_date) is null,'ok','not ok');
SELECT if(hour(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%k') AS INTEGER),'ok','not ok');
SELECT if(hour(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%k') AS INTEGER),'ok','not ok');
SELECT if(hour(current_time) = CAST(DATE_FORMAT(current_timestamp,'%k') AS INTEGER),'ok','not ok');


-- test for special case
select hour('23:59:59'), if (hour('23:59:59') = 23, 'ok', 'nok');
select hour('00:00:00'), if (hour('00:00:00') = 0, 'ok', 'nok');
select hour(time'00:00:00' - 1), if (hour(time'00:00:00' - 1) = 23, 'ok', 'nok');
select hour(time'23:59:59' + 1), if (hour(time'23:59:59' + 1) = 0, 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select hour('25:00:00');
select hour('01:00:70');
select hour('-30:00:10');
select hour('2003-12-31');

commit;
set system parameters 'return_null_on_function_errors = no';
select hour('12:23:15');

select hour(str_to_date('2010-01-02 12:23:25', '%Y-%m-%d %H:%i:%s'));

select hour('2010-01-01 12:20:00');

create table hour_tests(char_col char(32), varchar_col varchar(32), 
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

insert into hour_tests values('2010-01-02 10:19:21','asdf','05/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, hour(char_col) from hour_tests order by smallint_col;
select varchar_col, hour(varchar_col) from hour_tests order by smallint_col;
select string_col, hour(string_col) from hour_tests order by smallint_col;
select bit_col, hour(bit_col) from hour_tests order by smallint_col;
select integer_col, hour(integer_col) from hour_tests order by smallint_col;
select smallint_col, hour(smallint_col) from hour_tests order by smallint_col;
select bigint_col, hour(bigint_col) from hour_tests order by smallint_col;
select float_col, hour(float_col) from hour_tests order by smallint_col;
select double_col, hour(double_col) from hour_tests order by smallint_col;
select numeric_col, hour(numeric_col) from hour_tests order by smallint_col;
select monetary_col, hour(monetary_col) from hour_tests order by smallint_col;
select date_col, hour(date_col) from hour_tests order by smallint_col;
select time_col, hour(time_col) from hour_tests order by smallint_col;
select timestamp_col, hour(timestamp_col) from hour_tests order by smallint_col;
select datetime_col, hour(datetime_col) from hour_tests order by smallint_col;
select set_col, hour(set_col) from hour_tests order by smallint_col;


select * from hour_tests where smallint_col < hour(varchar_col) order by smallint_col;
select * from hour_tests where smallint_col = hour('11:24:11')-1 order by smallint_col;

drop table hour_tests;

create table t (col varchar(255)) partition by list (hour(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table hour_tests as select hour('2010-01-02 19:22:23') as [ hour('2010-01-02 19:22:23')];

SELECT * FROM db_attribute where class_name='hour_tests';

select * from hour_tests;

drop table hour_tests;

create view hour_view(v) as select hour('2010-01-02 12:23:10') from db_root;

select * from hour_view;

drop hour_view;

$varchar, $2009-01-01 20:18:32
select hour(?) as rez;

$varchar, $2009-01-01 20:18:32
select hour(?) as rez;

$date, $1985-01-02
select hour(?) as rez;

$datetime, $01/02/1985 12:13:15
select hour(?) as rez;

-- test for valid date time format
select hour(datetime'2003-12-31 01:02:03.1234'), if (hour(datetime'2003-12-31 01:02:03.1234') = 1, 'ok', 'nok');
select hour(timestamp'2003-12-31 01:02:03'), if (hour(timestamp'2003-12-31 01:02:03') = 1, 'ok', 'nok');
select hour(time'01:02:03'), if (hour(time'01:02:03') = 1, 'ok', 'nok');


-- test for valid date, time string format
select hour('2003-12-31 01:02:03.1234'), if (hour('2003-12-31 01:02:03.1234') = 1, 'ok', 'nok');
select hour('2003-12-31 01:02:03'), if (hour('2003-12-31 01:02:03') = 1, 'ok', 'nok');
select hour('01:02:03'), if (hour('01:02:03') = 1, 'ok', 'nok');


-- test for valid current_*
SELECT if(hour(current_date) is null,'ok','not ok');
SELECT if(hour(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%k') AS INTEGER),'ok','not ok');
SELECT if(hour(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%k') AS INTEGER),'ok','not ok');
SELECT if(hour(current_time) = CAST(DATE_FORMAT(current_timestamp,'%k') AS INTEGER),'ok','not ok');


-- test for special case
select hour('23:59:59'), if (hour('23:59:59') = 23, 'ok', 'nok');
select hour('00:00:00'), if (hour('00:00:00') = 0, 'ok', 'nok');
select hour(time'00:00:00' - 1), if (hour(time'00:00:00' - 1) = 23, 'ok', 'nok');
select hour(time'23:59:59' + 1), if (hour(time'23:59:59' + 1) = 0, 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select hour('25:00:00');
select hour('01:00:70');
select hour('-30:00:10');
select hour('2003-12-31');
commit;
--+ holdcas off;
