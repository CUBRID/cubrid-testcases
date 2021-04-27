--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select sec_to_time(3600);
select sec_to_time('3600');
select sec_to_time(3599.1);
select sec_to_time(3599.5);
select sec_to_time(3599.9);

select sec_to_time(3020398) as overflow_rez;
select sec_to_time(-3020398) as overflow_rez;

select sec_to_time(3020400) as overflow_rez;

create table sec_to_time_tests(char_col char(32), varchar_col varchar(32), 
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

insert into sec_to_time_tests values('2010-01-02','6200','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, sec_to_time(char_col) from sec_to_time_tests order by smallint_col;
select varchar_col, sec_to_time(varchar_col) from sec_to_time_tests order by smallint_col;
select string_col, sec_to_time(string_col) from sec_to_time_tests order by smallint_col;
select bit_col, sec_to_time(bit_col) from sec_to_time_tests order by smallint_col;
select integer_col, sec_to_time(integer_col) from sec_to_time_tests order by smallint_col;
select smallint_col, sec_to_time(smallint_col) from sec_to_time_tests order by smallint_col;
select bigint_col, sec_to_time(bigint_col) from sec_to_time_tests order by smallint_col;
select float_col, sec_to_time(float_col) from sec_to_time_tests order by smallint_col;
select double_col, sec_to_time(double_col) from sec_to_time_tests order by smallint_col;
select numeric_col, sec_to_time(numeric_col) from sec_to_time_tests order by smallint_col;
select monetary_col, sec_to_time(monetary_col) from sec_to_time_tests order by smallint_col;
select date_col, sec_to_time(date_col) from sec_to_time_tests order by smallint_col;
select time_col, sec_to_time(time_col) from sec_to_time_tests order by smallint_col;
select timestamp_col, sec_to_time(timestamp_col) from sec_to_time_tests order by smallint_col;
select datetime_col, sec_to_time(datetime_col) from sec_to_time_tests order by smallint_col;
select set_col, sec_to_time(set_col) from sec_to_time_tests order by smallint_col; 

select * from sec_to_time_tests where smallint_col = sec_to_time('2010-01-02')+10 order by smallint_col;

drop table sec_to_time_tests;

create table sec_to_time_tests as select sec_to_time('2010-01-02') as [ sec_to_time('2010-01-02')];

SELECT * FROM db_attribute where class_name='sec_to_time_tests';

select * from sec_to_time_tests;

drop table sec_to_time_tests;

create view sec_to_time_view(v) as select sec_to_time(11223) from db_root;

select * from sec_to_time_view;

drop sec_to_time_view;

$varchar, $1900.21
select sec_to_time(?) as rez;

$int, $2540
select sec_to_time(?) as rez;

$float, $2540.23
select sec_to_time(?) as rez;

$double, $3540.23
select sec_to_time(?) as rez;

$numeric, $2540.74
select sec_to_time(?) as rez;

$datetime, $01/02/1985 12:13:15
select sec_to_time(?) as rez;

$datetime, $01/02/1985 12:13:15
select 1 as rez from db_root where sec_to_time(?) = 1;

-- test for valid date time format
select sec_to_time(time_to_sec(datetime'2000-12-31 17:34:23.1234')), if (sec_to_time(time_to_sec(datetime'2000-12-31 17:34:23.1234')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec(timestamp'2000-12-31 17:34:23')), if (sec_to_time(time_to_sec(timestamp'2000-12-31 17:34:23')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec(time'17:34:23')), if (sec_to_time(time_to_sec(time'17:34:23')) = '17:34:23', 'ok', 'nok');


-- test for valid date, time string format
select sec_to_time(time_to_sec('2000-12-31 17:34:23.1234')), if (sec_to_time(time_to_sec('2000-12-31 17:34:23.1234')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec('2000-12-31 17:34:23')), if (sec_to_time(time_to_sec('2000-12-31 17:34:23')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec('17:34:23')), if (sec_to_time(time_to_sec('17:34:23')) = '17:34:23', 'ok', 'nok');


-- test for valid current_*
select if (sec_to_time(time_to_sec(current_datetime)) = current_time , 'ok', 'nok');
select if (sec_to_time(time_to_sec(current_timestamp)) = current_time , 'ok', 'nok');
select if (sec_to_time(time_to_sec(current_time)) = current_time , 'ok', 'nok');


-- test for normal case
select sec_to_time(0), if (sec_to_time(0) = '00:00:00', 'ok', 'nok');
select sec_to_time(1), if (sec_to_time(1) = '00:00:01', 'ok', 'nok');
select sec_to_time(60), if (sec_to_time(60) = '00:01:00', 'ok', 'nok');
select sec_to_time(60*60), if (sec_to_time(60*60) = '01:00:00', 'ok', 'nok');
select sec_to_time(3*60*60 + 12*60 + 30), if (sec_to_time(3*60*60 + 12*60 + 30) = '3:12:30', 'ok', 'nok');
select sec_to_time(24*60*60 - 1), if (sec_to_time(24*60*60 - 1) = '23:59:59', 'ok', 'nok');



-- check if ER_TIME_CONVERSION is occured.
select sec_to_time(-1);
select sec_to_time(24*60*60);
select if (sec_to_time(current_date) is null, 'nok', 'ok');

set system parameters 'return_null_on_function_errors = no';

select sec_to_time(3600);
select sec_to_time('3600');
select sec_to_time(3599.1);
select sec_to_time(3599.5);
select sec_to_time(3599.9);

select sec_to_time(3020398) as overflow_rez;
select sec_to_time(-3020398) as overflow_rez;

select sec_to_time(3020400) as overflow_rez;

create table sec_to_time_tests(char_col char(32), varchar_col varchar(32), 
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

insert into sec_to_time_tests values('2010-01-02','6200','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, sec_to_time(char_col) from sec_to_time_tests order by smallint_col;
select varchar_col, sec_to_time(varchar_col) from sec_to_time_tests order by smallint_col;
select string_col, sec_to_time(string_col) from sec_to_time_tests order by smallint_col;
select bit_col, sec_to_time(bit_col) from sec_to_time_tests order by smallint_col;
select integer_col, sec_to_time(integer_col) from sec_to_time_tests order by smallint_col;
select smallint_col, sec_to_time(smallint_col) from sec_to_time_tests order by smallint_col;
select bigint_col, sec_to_time(bigint_col) from sec_to_time_tests order by smallint_col;
select float_col, sec_to_time(float_col) from sec_to_time_tests order by smallint_col;
select double_col, sec_to_time(double_col) from sec_to_time_tests order by smallint_col;
select numeric_col, sec_to_time(numeric_col) from sec_to_time_tests order by smallint_col;
select monetary_col, sec_to_time(monetary_col) from sec_to_time_tests order by smallint_col;
select date_col, sec_to_time(date_col) from sec_to_time_tests order by smallint_col;
select time_col, sec_to_time(time_col) from sec_to_time_tests order by smallint_col;
select timestamp_col, sec_to_time(timestamp_col) from sec_to_time_tests order by smallint_col;
select datetime_col, sec_to_time(datetime_col) from sec_to_time_tests order by smallint_col;
select set_col, sec_to_time(set_col) from sec_to_time_tests order by smallint_col; 

select * from sec_to_time_tests where smallint_col = sec_to_time('2010-01-02')+10 order by smallint_col;

drop table sec_to_time_tests;

create table sec_to_time_tests as select sec_to_time('2010-01-02') as [ sec_to_time('2010-01-02')];

SELECT * FROM db_attribute where class_name='sec_to_time_tests';

select * from sec_to_time_tests;

drop table sec_to_time_tests;

create view sec_to_time_view(v) as select sec_to_time(11223) from db_root;

select * from sec_to_time_view;

drop sec_to_time_view;

$varchar, $1900.21
select sec_to_time(?) as rez;

$int, $2540
select sec_to_time(?) as rez;

$float, $2540.23
select sec_to_time(?) as rez;

$double, $3540.23
select sec_to_time(?) as rez;

$numeric, $2540.74
select sec_to_time(?) as rez;

$datetime, $01/02/1985 12:13:15
select sec_to_time(?) as rez;

$datetime, $01/02/1985 12:13:15
select 1 as rez from db_root where sec_to_time(?) = 1;

-- test for valid date time format
select sec_to_time(time_to_sec(datetime'2000-12-31 17:34:23.1234')), if (sec_to_time(time_to_sec(datetime'2000-12-31 17:34:23.1234')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec(timestamp'2000-12-31 17:34:23')), if (sec_to_time(time_to_sec(timestamp'2000-12-31 17:34:23')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec(time'17:34:23')), if (sec_to_time(time_to_sec(time'17:34:23')) = '17:34:23', 'ok', 'nok');


-- test for valid date, time string format
select sec_to_time(time_to_sec('2000-12-31 17:34:23.1234')), if (sec_to_time(time_to_sec('2000-12-31 17:34:23.1234')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec('2000-12-31 17:34:23')), if (sec_to_time(time_to_sec('2000-12-31 17:34:23')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec('17:34:23')), if (sec_to_time(time_to_sec('17:34:23')) = '17:34:23', 'ok', 'nok');


-- test for valid current_*
select if (sec_to_time(time_to_sec(current_datetime)) = current_time , 'ok', 'nok');
select if (sec_to_time(time_to_sec(current_timestamp)) = current_time , 'ok', 'nok');
select if (sec_to_time(time_to_sec(current_time)) = current_time , 'ok', 'nok');


-- test for normal case
select sec_to_time(0), if (sec_to_time(0) = '00:00:00', 'ok', 'nok');
select sec_to_time(1), if (sec_to_time(1) = '00:00:01', 'ok', 'nok');
select sec_to_time(60), if (sec_to_time(60) = '00:01:00', 'ok', 'nok');
select sec_to_time(60*60), if (sec_to_time(60*60) = '01:00:00', 'ok', 'nok');
select sec_to_time(3*60*60 + 12*60 + 30), if (sec_to_time(3*60*60 + 12*60 + 30) = '3:12:30', 'ok', 'nok');
select sec_to_time(24*60*60 - 1), if (sec_to_time(24*60*60 - 1) = '23:59:59', 'ok', 'nok');



-- check if ER_TIME_CONVERSION is occured.
select sec_to_time(-1);
select sec_to_time(24*60*60);

commit;
--+ holdcas off;
