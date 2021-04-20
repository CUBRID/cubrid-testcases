--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select time('12:23:15');

select time('12:23:15.123');

select time(str_to_date('2010-01-02 12:23:25', '%Y-%m-%d %H:%i:%s'));

select time('2010-01-01 12:20:00');

create table time_tests(char_col char(32), varchar_col varchar(32), 
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

insert into time_tests values('2010-01-02 10:19:21','asdf','05/04/2010 12:23:15.123',NULL,12000,23,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, time(char_col) from time_tests order by smallint_col;
select varchar_col, time(varchar_col) from time_tests order by smallint_col;
select string_col, time(string_col) from time_tests order by smallint_col;
select bit_col, time(bit_col) from time_tests order by smallint_col;
select integer_col, time(integer_col) from time_tests order by smallint_col;
select smallint_col, time(smallint_col) from time_tests order by smallint_col;
select bigint_col, time(bigint_col) from time_tests order by smallint_col;
select float_col, time(float_col) from time_tests order by smallint_col;
select double_col, time(double_col) from time_tests order by smallint_col;
select numeric_col, time(numeric_col) from time_tests order by smallint_col;
select monetary_col, time(monetary_col) from time_tests order by smallint_col;
select date_col, time(date_col) from time_tests order by smallint_col;
select time_col, time(time_col) from time_tests order by smallint_col;
select timestamp_col, time(timestamp_col) from time_tests order by smallint_col;
select datetime_col, time(datetime_col) from time_tests order by smallint_col;
select set_col, time(set_col) from time_tests order by smallint_col;


drop table time_tests;

create table t (col varchar(255)) partition by list (time(col)) (PARTITION P0 VALUES IN ('12:00:00.000', '11:00:00.000'));

drop table t;


create table time_tests as select time('10:11:12') as [ time('10:11:12')];

SELECT * FROM db_attribute where class_name='time_tests';

select * from time_tests;

drop table time_tests;

create view time_view(v) as select time('2010-01-02 12:23:10') from db_root;

select * from time_view;

drop time_view;

$varchar, $2009-01-01 20:18:32
select time(?) as rez;

$varchar, $2009-01-01 20:18:32
select time(?) as rez;

$date, $1985-01-02
select time(?) as rez;

$datetime, $01/02/1985 12:13:15
select time(?) as rez;

-- test for valid date time format
select time(datetime'2003-12-31 01:02:03.123'), if (time(datetime'2003-12-31 01:02:03.123') = '01:02:03.123', 'ok', 'nok');
select time(timestamp'2003-12-31 01:02:03'), if (time(timestamp'2003-12-31 01:02:03') = '01:02:03', 'ok', 'nok');
select time(time'01:02:03'), if (time(time'01:02:03') = '01:02:03', 'ok', 'nok');


-- test for valid date, time string format
select time('2003-12-31 01:02:03.123'), if (time('2003-12-31 01:02:03.123') = '01:02:03.123', 'ok', 'nok');
select time('2003-12-31 01:02:03'), if (time('2003-12-31 01:02:03') = '01:02:03', 'ok', 'nok');
select time('01:02:03'), if (time('01:02:03') = '01:02:03', 'ok', 'nok');
select time('01:02:03.123'), if (time('01:02:03.123') = '01:02:03.123', 'ok', 'nok');

select time(N'2003-12-31 01:02:03.123'), if (time(N'2003-12-31 01:02:03.123') = N'01:02:03.123', 'ok', 'nok');
select time(N'2003-12-31 01:02:03'), if (time(N'2003-12-31 01:02:03') = N'01:02:03', 'ok', 'nok');
select time(N'01:02:03'), if (time(N'01:02:03') = N'01:02:03', 'ok', 'nok');
select time(N'01:02:03.456'), if (time(N'01:02:03.456') = N'01:02:03.456', 'ok', 'nok');

-- test for valid current_*
SELECT if(cast(current_time as time) = SYS_TIME,'ok','nok');
SELECT if(cast(current_timestamp as time) = SYS_TIME,'ok','nok');
SELECT if(cast(current_datetime as time) = SYS_TIME,'ok','nok');

-- test for special case
select time('23:59:59'), if (time('23:59:59') = '23:59:59', 'ok', 'nok');
select time('00:00:00'), if (time('00:00:00') = '00:00:00', 'ok', 'nok');

-- check if ER_TIME_CONVERSION is occured.
select time('00:61:00');

set system parameters 'return_null_on_function_errors = no';

select time('12:23:15');

select time('12:23:15.123');

select time(str_to_date('2010-01-02 12:23:25', '%Y-%m-%d %H:%i:%s'));

select time('2010-01-01 12:20:00');

create table time_tests(char_col char(32), varchar_col varchar(32), 
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

insert into time_tests values('2010-01-02 10:19:21','asdf','05/04/2010 12:23:15.123',NULL,12000,23,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, time(char_col) from time_tests order by smallint_col;
select varchar_col, time(varchar_col) from time_tests order by smallint_col;
select string_col, time(string_col) from time_tests order by smallint_col;
select bit_col, time(bit_col) from time_tests order by smallint_col;
select integer_col, time(integer_col) from time_tests order by smallint_col;
select smallint_col, time(smallint_col) from time_tests order by smallint_col;
select bigint_col, time(bigint_col) from time_tests order by smallint_col;
select float_col, time(float_col) from time_tests order by smallint_col;
select double_col, time(double_col) from time_tests order by smallint_col;
select numeric_col, time(numeric_col) from time_tests order by smallint_col;
select monetary_col, time(monetary_col) from time_tests order by smallint_col;
select date_col, time(date_col) from time_tests order by smallint_col;
select time_col, time(time_col) from time_tests order by smallint_col;
select timestamp_col, time(timestamp_col) from time_tests order by smallint_col;
select datetime_col, time(datetime_col) from time_tests order by smallint_col;
select set_col, time(set_col) from time_tests order by smallint_col;


drop table time_tests;

create table t (col varchar(255)) partition by list (time(col)) (PARTITION P0 VALUES IN ('12:00:00.000', '11:00:00.000'));

drop table t;


create table time_tests as select time('10:11:12') as [ time('10:11:12')];

SELECT * FROM db_attribute where class_name='time_tests';

select * from time_tests;

drop table time_tests;

create view time_view(v) as select time('2010-01-02 12:23:10') from db_root;

select * from time_view;

drop time_view;

$varchar, $2009-01-01 20:18:32
select time(?) as rez;

$varchar, $2009-01-01 20:18:32
select time(?) as rez;

$date, $1985-01-02
select time(?) as rez;

$datetime, $01/02/1985 12:13:15
select time(?) as rez;

-- test for valid date time format
select time(datetime'2003-12-31 01:02:03.123'), if (time(datetime'2003-12-31 01:02:03.123') = '01:02:03.123', 'ok', 'nok');
select time(timestamp'2003-12-31 01:02:03'), if (time(timestamp'2003-12-31 01:02:03') = '01:02:03', 'ok', 'nok');
select time(time'01:02:03'), if (time(time'01:02:03') = '01:02:03', 'ok', 'nok');


-- test for valid date, time string format
select time('2003-12-31 01:02:03.123'), if (time('2003-12-31 01:02:03.123') = '01:02:03.123', 'ok', 'nok');
select time('2003-12-31 01:02:03'), if (time('2003-12-31 01:02:03') = '01:02:03', 'ok', 'nok');
select time('01:02:03'), if (time('01:02:03') = '01:02:03', 'ok', 'nok');
select time('01:02:03.123'), if (time('01:02:03.123') = '01:02:03.123', 'ok', 'nok');

select time(N'2003-12-31 01:02:03.123'), if (time(N'2003-12-31 01:02:03.123') = N'01:02:03.123', 'ok', 'nok');
select time(N'2003-12-31 01:02:03'), if (time(N'2003-12-31 01:02:03') = N'01:02:03', 'ok', 'nok');
select time(N'01:02:03'), if (time(N'01:02:03') = N'01:02:03', 'ok', 'nok');
select time(N'01:02:03.456'), if (time(N'01:02:03.456') = N'01:02:03.456', 'ok', 'nok');

-- test for valid current_*
SELECT if(cast(current_time as time) = SYS_TIME,'ok','nok');
SELECT if(cast(current_timestamp as time) = SYS_TIME,'ok','nok');
SELECT if(cast(current_datetime as time) = SYS_TIME,'ok','nok');

-- test for special case
select time('23:59:59'), if (time('23:59:59') = '23:59:59', 'ok', 'nok');
select time('00:00:00'), if (time('00:00:00') = '00:00:00', 'ok', 'nok');

-- check if ER_TIME_CONVERSION is occured.
select time('00:61:00');
commit;
--+ holdcas off;
