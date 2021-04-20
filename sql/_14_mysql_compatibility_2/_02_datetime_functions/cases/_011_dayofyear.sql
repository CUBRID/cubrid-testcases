--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select dayofyear('2010-05-11');

select dayofyear('2010-06-21');

select dayofyear('2008-02-29');

select dayofyear('1983-05-24');

select dayofyear('22/11/2010');

select dayofyear(str_to_date('12/25/1999', '%m/%d/%Y'));

select dayofyear('2010-01-01 12:20:00');

create table dayofyear_tests(char_col char(32), varchar_col varchar(32), 
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

insert into dayofyear_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,6,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,3,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, dayofyear(char_col) from dayofyear_tests order by smallint_col;
select varchar_col, dayofyear(varchar_col) from dayofyear_tests order by smallint_col;
select string_col, dayofyear(string_col) from dayofyear_tests order by smallint_col;
select bit_col, dayofyear(bit_col) from dayofyear_tests order by smallint_col;
select integer_col, dayofyear(integer_col) from dayofyear_tests order by smallint_col;
select smallint_col, dayofyear(smallint_col) from dayofyear_tests order by smallint_col;
select bigint_col, dayofyear(bigint_col) from dayofyear_tests order by smallint_col;
select float_col, if(dayofyear(float_col)=dayofyear(date(concat(year(sysdate),'-12-25'))),'ok','nok') from dayofyear_tests order by smallint_col;
select double_col, dayofyear(double_col) from dayofyear_tests order by smallint_col;
--select numeric_col, dayofyear(numeric_col) from dayofyear_tests order by smallint_col;
select float_col, if(dayofyear(numeric_col)=dayofyear(date(concat(year(sysdate),'-11-12'))),'ok','nok') from dayofyear_tests order by smallint_col;
select monetary_col, dayofyear(monetary_col) from dayofyear_tests order by smallint_col;
select date_col, dayofyear(date_col) from dayofyear_tests order by smallint_col;
select time_col, dayofyear(time_col) from dayofyear_tests order by smallint_col;
select timestamp_col, dayofyear(timestamp_col) from dayofyear_tests order by smallint_col;
select datetime_col, dayofyear(datetime_col) from dayofyear_tests order by smallint_col;
select set_col, dayofyear(set_col) from dayofyear_tests order by smallint_col;


select * from dayofyear_tests where smallint_col = dayofyear('2010-01-02')+1 order by smallint_col;
select * from dayofyear_tests where smallint_col < dayofyear(varchar_col) order by smallint_col;

create table t (col varchar(255)) partition by list (dayofyear(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

drop table dayofyear_tests;

create table dayofyear_tests as select dayofyear('2010-01-02') as [ dayofyear('2010-01-02')];

SELECT * FROM db_attribute where class_name='dayofyear_tests';

select * from dayofyear_tests;

drop table dayofyear_tests;

create view dayofyear_view(v) as select dayofyear('2010-01-02') from db_root;

select * from dayofyear_view;

drop dayofyear_view;

$varchar, $2009-12-12 20:18:32
select dayofyear(?) as rez;

$date, $1985-01-02
select dayofyear(?) as rez;

$datetime, $01/02/1985 12:13:15
select dayofyear(?) as rez;

$time, $12:23:15
select dayofyear(?) as rez;

$date, $1985-04-01
select 1 as rez from db_root where dayofyear(?) = 91;

$datetime, $01/03/1985
select 1 as rez from db_root where dayofyear(?) = 2;

-- test for valid date time format
select dayofyear(datetime'2003-08-23 01:02:03.1234'), if (dayofyear(datetime'2010-08-23 01:02:03.1234') = 235, 'ok', 'nok');
select dayofyear(timestamp'2010-08-23 01:02:03'), if (dayofyear(timestamp'2010-08-23 01:02:03') = 235, 'ok', 'nok');
select dayofyear(date'2010-08-23'), if (dayofyear(date'2010-08-23') = 235, 'ok', 'nok');


-- test for valid date, time string format
select dayofyear('2010-08-23 01:02:03.1234'), if (dayofyear('2010-08-23 01:02:03.1234') = 235, 'ok', 'nok');
select dayofyear('2010-08-23 01:02:03'), if (dayofyear('2010-08-23 01:02:03') = 235, 'ok', 'nok');
select dayofyear('2010-08-23'), if (dayofyear('2010-08-23') = 235, 'ok', 'nok');


-- test for valid current_*
SELECT if(dayofyear(current_date) = CAST(DATE_FORMAT(current_date,'%j') AS INTEGER),'ok','not ok');
SELECT if(dayofyear(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%j') AS INTEGER),'ok','not ok');
SELECT if(dayofyear(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%j') AS INTEGER),'ok','not ok');

-- test for normal case
select dayofyear('2010-01-01'), if (dayofyear('2010-01-01') = 1, 'ok', 'nok');
select dayofyear('2010-02-01'), if (dayofyear('2010-02-01') = 32, 'ok', 'nok');
select dayofyear('2010-03-01'), if (dayofyear('2010-03-01') = 60, 'ok', 'nok');
select dayofyear('2010-04-01'), if (dayofyear('2010-04-01') = 91, 'ok', 'nok');
select dayofyear('2010-05-01'), if (dayofyear('2010-05-01') = 121, 'ok', 'nok');
select dayofyear('2010-06-01'), if (dayofyear('2010-06-01') = 152, 'ok', 'nok');
select dayofyear('2010-07-01'), if (dayofyear('2010-07-01') = 182, 'ok', 'nok');
select dayofyear('2010-08-01'), if (dayofyear('2010-08-01') = 213, 'ok', 'nok');
select dayofyear('2010-09-01'), if (dayofyear('2010-09-01') = 244, 'ok', 'nok');
select dayofyear('2010-10-01'), if (dayofyear('2010-10-01') = 274, 'ok', 'nok');
select dayofyear('2010-11-01'), if (dayofyear('2010-11-01') = 305, 'ok', 'nok');
select dayofyear('2010-12-01'), if (dayofyear('2010-12-01') = 335, 'ok', 'nok');


-- test for special case
select dayofyear('2000-01-01'), if (dayofyear('2000-01-01') = 1, 'ok', 'nok');
select dayofyear(date'2000-01-01' - 1), if (dayofyear(date'2000-01-01' - 1) = 365, 'ok', 'nok');
select dayofyear('2000-12-31'), if (dayofyear('2000-12-31') = 366, 'ok', 'nok');
select dayofyear(date'2000-12-31' + 1), if (dayofyear(date'2000-12-31' + 1) = 1, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select dayofyear('2000-01-00 01:02:03');
select dayofyear('2000-12-32 01:02:03');
select dayofyear('1999-2-29 01:02:03');

select dayofyear('01:02:03');

set system parameters 'return_null_on_function_errors = no';

select dayofyear('2010-05-11');

select dayofyear('2010-06-21');

select dayofyear('2008-02-29');

select dayofyear('1983-05-24');

select dayofyear('22/11/2010');

select dayofyear(str_to_date('12/25/1999', '%m/%d/%Y'));

select dayofyear('2010-01-01 12:20:00');

create table dayofyear_tests(char_col char(32), varchar_col varchar(32), 
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

insert into dayofyear_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,6,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,3,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, dayofyear(char_col) from dayofyear_tests order by smallint_col;
select varchar_col, dayofyear(varchar_col) from dayofyear_tests order by smallint_col;
select string_col, dayofyear(string_col) from dayofyear_tests order by smallint_col;
select bit_col, dayofyear(bit_col) from dayofyear_tests order by smallint_col;
select integer_col, dayofyear(integer_col) from dayofyear_tests order by smallint_col;
select smallint_col, dayofyear(smallint_col) from dayofyear_tests order by smallint_col;
select bigint_col, dayofyear(bigint_col) from dayofyear_tests order by smallint_col;
--select float_col, dayofyear(float_col) from dayofyear_tests order by smallint_col;
select float_col, if(dayofyear(float_col)=dayofyear(date(concat(year(sysdate),'-12-25'))),'ok','nok') from dayofyear_tests order by smallint_col;
select double_col, dayofyear(double_col) from dayofyear_tests order by smallint_col;
--select numeric_col, dayofyear(numeric_col) from dayofyear_tests order by smallint_col;
select float_col, if(dayofyear(numeric_col)=dayofyear(date(concat(year(sysdate),'-11-12'))),'ok','nok') from dayofyear_tests order by smallint_col;
select monetary_col, dayofyear(monetary_col) from dayofyear_tests order by smallint_col;
select date_col, dayofyear(date_col) from dayofyear_tests order by smallint_col;
select time_col, dayofyear(time_col) from dayofyear_tests order by smallint_col;
select timestamp_col, dayofyear(timestamp_col) from dayofyear_tests order by smallint_col;
select datetime_col, dayofyear(datetime_col) from dayofyear_tests order by smallint_col;
select set_col, dayofyear(set_col) from dayofyear_tests order by smallint_col;


select * from dayofyear_tests where smallint_col = dayofyear('2010-01-02')+1 order by smallint_col;
select * from dayofyear_tests where smallint_col < dayofyear(varchar_col) order by smallint_col;

create table t (col varchar(255)) partition by list (dayofyear(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

drop table dayofyear_tests;

create table dayofyear_tests as select dayofyear('2010-01-02') as [ dayofyear('2010-01-02')];

SELECT * FROM db_attribute where class_name='dayofyear_tests';

select * from dayofyear_tests;

drop table dayofyear_tests;

create view dayofyear_view(v) as select dayofyear('2010-01-02') from db_root;

select * from dayofyear_view;

drop dayofyear_view;

$varchar, $2009-12-12 20:18:32
select dayofyear(?) as rez;

$date, $1985-01-02
select dayofyear(?) as rez;

$datetime, $01/02/1985 12:13:15
select dayofyear(?) as rez;

$time, $12:23:15
select dayofyear(?) as rez;

$date, $1985-04-01
select 1 as rez from db_root where dayofyear(?) = 91;

$datetime, $01/03/1985
select 1 as rez from db_root where dayofyear(?) = 2;

-- test for valid date time format
select dayofyear(datetime'2003-08-23 01:02:03.1234'), if (dayofyear(datetime'2010-08-23 01:02:03.1234') = 235, 'ok', 'nok');
select dayofyear(timestamp'2010-08-23 01:02:03'), if (dayofyear(timestamp'2010-08-23 01:02:03') = 235, 'ok', 'nok');
select dayofyear(date'2010-08-23'), if (dayofyear(date'2010-08-23') = 235, 'ok', 'nok');


-- test for valid date, time string format
select dayofyear('2010-08-23 01:02:03.1234'), if (dayofyear('2010-08-23 01:02:03.1234') = 235, 'ok', 'nok');
select dayofyear('2010-08-23 01:02:03'), if (dayofyear('2010-08-23 01:02:03') = 235, 'ok', 'nok');
select dayofyear('2010-08-23'), if (dayofyear('2010-08-23') = 235, 'ok', 'nok');


-- test for valid current_*
SELECT if(dayofyear(current_date) = CAST(DATE_FORMAT(current_date,'%j') AS INTEGER),'ok','not ok');
SELECT if(dayofyear(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%j') AS INTEGER),'ok','not ok');
SELECT if(dayofyear(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%j') AS INTEGER),'ok','not ok');

-- test for normal case
select dayofyear('2010-01-01'), if (dayofyear('2010-01-01') = 1, 'ok', 'nok');
select dayofyear('2010-02-01'), if (dayofyear('2010-02-01') = 32, 'ok', 'nok');
select dayofyear('2010-03-01'), if (dayofyear('2010-03-01') = 60, 'ok', 'nok');
select dayofyear('2010-04-01'), if (dayofyear('2010-04-01') = 91, 'ok', 'nok');
select dayofyear('2010-05-01'), if (dayofyear('2010-05-01') = 121, 'ok', 'nok');
select dayofyear('2010-06-01'), if (dayofyear('2010-06-01') = 152, 'ok', 'nok');
select dayofyear('2010-07-01'), if (dayofyear('2010-07-01') = 182, 'ok', 'nok');
select dayofyear('2010-08-01'), if (dayofyear('2010-08-01') = 213, 'ok', 'nok');
select dayofyear('2010-09-01'), if (dayofyear('2010-09-01') = 244, 'ok', 'nok');
select dayofyear('2010-10-01'), if (dayofyear('2010-10-01') = 274, 'ok', 'nok');
select dayofyear('2010-11-01'), if (dayofyear('2010-11-01') = 305, 'ok', 'nok');
select dayofyear('2010-12-01'), if (dayofyear('2010-12-01') = 335, 'ok', 'nok');


-- test for special case
select dayofyear('2000-01-01'), if (dayofyear('2000-01-01') = 1, 'ok', 'nok');
select dayofyear('2000-01-01' - 1), if (dayofyear('2000-01-01' - 1) = 365, 'ok', 'nok');
select dayofyear('2000-12-31'), if (dayofyear('2000-12-31') = 366, 'ok', 'nok');
select dayofyear('2000-12-31' + 1), if (dayofyear('2000-12-31' + 1) = 1, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select dayofyear('2000-01-00 01:02:03');
select dayofyear('2000-12-32 01:02:03');
select dayofyear('1999-2-29 01:02:03');

select dayofyear('01:02:03');
commit;
--+ holdcas off;
