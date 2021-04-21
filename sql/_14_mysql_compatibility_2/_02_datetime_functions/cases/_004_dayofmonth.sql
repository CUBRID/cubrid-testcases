--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select dayofmonth('2010-01-01');

select dayofmonth('01/01/2010');

select dayofmonth(str_to_date('12/25/1999', '%m/%d/%Y'));

select dayofmonth('2010-01-01 12:20:00');

create table dayofmonth_tests(char_col char(32), varchar_col varchar(32), 
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

insert into dayofmonth_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, dayofmonth(char_col) from dayofmonth_tests order by smallint_col
select varchar_col, dayofmonth(varchar_col) from dayofmonth_tests order by smallint_col;
select string_col, dayofmonth(string_col) from dayofmonth_tests order by smallint_col;
select bit_col, dayofmonth(bit_col) from dayofmonth_tests order by smallint_col;
select integer_col, dayofmonth(integer_col) from dayofmonth_tests order by smallint_col;
select smallint_col, dayofmonth(smallint_col) from dayofmonth_tests order by smallint_col;
select bigint_col, dayofmonth(bigint_col) from dayofmonth_tests order by smallint_col;
select float_col, dayofmonth(float_col) from dayofmonth_tests order by smallint_col;
select double_col, dayofmonth(double_col) from dayofmonth_tests order by smallint_col;
select numeric_col, dayofmonth(numeric_col) from dayofmonth_tests order by smallint_col;
select monetary_col, dayofmonth(monetary_col) from dayofmonth_tests order by smallint_col;
select date_col, dayofmonth(date_col) from dayofmonth_tests order by smallint_col;
select time_col, dayofmonth(time_col) from dayofmonth_tests order by smallint_col;
select timestamp_col, dayofmonth(timestamp_col) from dayofmonth_tests order by smallint_col;
select datetime_col, dayofmonth(datetime_col) from dayofmonth_tests order by smallint_col;
select set_col, dayofmonth(set_col) from dayofmonth_tests order by smallint_col;


select * from dayofmonth_tests where smallint_col < dayofmonth(varchar_col) order by smallint_col;
select * from dayofmonth_tests where smallint_col = dayofmonth('2010-01-02')+9 order by smallint_col;

drop table dayofmonth_tests;

create table t (col varchar(255)) partition by list (dayofmonth(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;


create table dayofmonth_tests as select dayofmonth('2010-01-02') as [ dayofmonth('2010-01-02')];

SELECT * FROM db_attribute where class_name='dayofmonth_tests';

select * from dayofmonth_tests;

drop table dayofmonth_tests;

create view dayofmonth_view(v) as select dayofmonth('2010-01-02') from db_root;

select * from dayofmonth_view;

drop dayofmonth_view;

$varchar, $2009-01-01 20:18:32
select dayofmonth(?) as rez;

$varchar, $2009-01-01 20:18:32
select dayofmonth(?) as rez;

$date, $1985-01-02
select dayofmonth(?) as rez;

$datetime, $01/02/1985 12:13:15
select dayofmonth(?) as rez;

-- test for valid date time format
select dayofmonth(datetime'2003-12-31 01:02:03.1234'), if (dayofmonth(datetime'2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select dayofmonth(timestamp'2003-12-31 01:02:03'), if (dayofmonth(timestamp'2003-12-31 01:02:03') = 31, 'ok', 'nok');
select dayofmonth(date'2003-12-31'), if (dayofmonth(date'2003-12-31') = 31, 'ok', 'nok');


-- test for valid date, time string format
select dayofmonth('2003-12-31 01:02:03.1234'), if (dayofmonth('2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select dayofmonth('2003-12-31 01:02:03'), if (dayofmonth('2003-12-31 01:02:03') = 31, 'ok', 'nok');
select dayofmonth('2003-12-31'), if (dayofmonth('2003-12-31') = 31, 'ok', 'nok');


-- test for valid current_*
SELECT if(dayofmonth(current_date) = CAST(DATE_FORMAT(current_date,'%e') AS INTEGER),'ok','not ok');
SELECT if(dayofmonth(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%e') AS INTEGER),'ok','not ok');
SELECT if(dayofmonth(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%e') AS INTEGER),'ok','not ok');

-- test for special case
select dayofmonth('1-1-1'), if (dayofmonth('1-1-1') = 1, 'ok', 'nok');
select dayofmonth('1/1/1'), if (dayofmonth('1/1/1') = 1, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is returned.
select dayofmonth('2000-01-00 01:02:03');
select dayofmonth('2000-12-32 01:02:03');
select dayofmonth('1999-2-29 01:02:03');

select dayofmonth('01:02:03');

set system parameters 'return_null_on_function_errors = no';
select dayofmonth('2010-01-01');

select dayofmonth('01/01/2010');

select dayofmonth(str_to_date('12/25/1999', '%m/%d/%Y'));

select dayofmonth('2010-01-01 12:20:00');

create table dayofmonth_tests(char_col char(32), varchar_col varchar(32), 
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

insert into dayofmonth_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, dayofmonth(char_col) from dayofmonth_tests order by smallint_col
select varchar_col, dayofmonth(varchar_col) from dayofmonth_tests order by smallint_col;
select string_col, dayofmonth(string_col) from dayofmonth_tests order by smallint_col;
select bit_col, dayofmonth(bit_col) from dayofmonth_tests order by smallint_col;
select integer_col, dayofmonth(integer_col) from dayofmonth_tests order by smallint_col;
select smallint_col, dayofmonth(smallint_col) from dayofmonth_tests order by smallint_col;
select bigint_col, dayofmonth(bigint_col) from dayofmonth_tests order by smallint_col;
select float_col, dayofmonth(float_col) from dayofmonth_tests order by smallint_col;
select double_col, dayofmonth(double_col) from dayofmonth_tests order by smallint_col;
select numeric_col, dayofmonth(numeric_col) from dayofmonth_tests order by smallint_col;
select monetary_col, dayofmonth(monetary_col) from dayofmonth_tests order by smallint_col;
select date_col, dayofmonth(date_col) from dayofmonth_tests order by smallint_col;
select time_col, dayofmonth(time_col) from dayofmonth_tests order by smallint_col;
select timestamp_col, dayofmonth(timestamp_col) from dayofmonth_tests order by smallint_col;
select datetime_col, dayofmonth(datetime_col) from dayofmonth_tests order by smallint_col;
select set_col, dayofmonth(set_col) from dayofmonth_tests order by smallint_col;


select * from dayofmonth_tests where smallint_col < dayofmonth(varchar_col) order by smallint_col;
select * from dayofmonth_tests where smallint_col = dayofmonth('2010-01-02')+9 order by smallint_col;

drop table dayofmonth_tests;

create table t (col varchar(255)) partition by list (dayofmonth(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;


create table dayofmonth_tests as select dayofmonth('2010-01-02') as [ dayofmonth('2010-01-02')];

SELECT * FROM db_attribute where class_name='dayofmonth_tests';

select * from dayofmonth_tests;

drop table dayofmonth_tests;

create view dayofmonth_view(v) as select dayofmonth('2010-01-02') from db_root;

select * from dayofmonth_view;

drop dayofmonth_view;

$varchar, $2009-01-01 20:18:32
select dayofmonth(?) as rez;

$varchar, $2009-01-01 20:18:32
select dayofmonth(?) as rez;

$date, $1985-01-02
select dayofmonth(?) as rez;

$datetime, $01/02/1985 12:13:15
select dayofmonth(?) as rez;

-- test for valid date time format
select dayofmonth(datetime'2003-12-31 01:02:03.1234'), if (dayofmonth(datetime'2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select dayofmonth(timestamp'2003-12-31 01:02:03'), if (dayofmonth(timestamp'2003-12-31 01:02:03') = 31, 'ok', 'nok');
select dayofmonth(date'2003-12-31'), if (dayofmonth(date'2003-12-31') = 31, 'ok', 'nok');


-- test for valid date, time string format
select dayofmonth('2003-12-31 01:02:03.1234'), if (dayofmonth('2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select dayofmonth('2003-12-31 01:02:03'), if (dayofmonth('2003-12-31 01:02:03') = 31, 'ok', 'nok');
select dayofmonth('2003-12-31'), if (dayofmonth('2003-12-31') = 31, 'ok', 'nok');


-- test for valid current_*
SELECT if(dayofmonth(current_date) = CAST(DATE_FORMAT(current_date,'%e') AS INTEGER),'ok','not ok');
SELECT if(dayofmonth(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%e') AS INTEGER),'ok','not ok');
SELECT if(dayofmonth(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%e') AS INTEGER),'ok','not ok');

-- test for special case
select dayofmonth('1-1-1'), if (dayofmonth('1-1-1') = 1, 'ok', 'nok');
select dayofmonth('1/1/1'), if (dayofmonth('1/1/1') = 1, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is returned.
select dayofmonth('2000-01-00 01:02:03');
select dayofmonth('2000-12-32 01:02:03');
select dayofmonth('1999-2-29 01:02:03');

select dayofmonth('01:02:03');
commit;
--+ holdcas off;
