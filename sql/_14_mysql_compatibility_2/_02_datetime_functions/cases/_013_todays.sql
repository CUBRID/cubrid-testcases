--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select to_days('2010-05-11') as q;

select to_days('2010-06-21') as q;

select to_days('2008-02-29') as q;

select to_days('1983-05-24') as q;

select to_days('01/01/2010') as q;

select to_days(str_to_date('12/25/1999', '%m/%d/%Y'));

select to_days('2010-01-01 12:20:00');

create table to_days_tests(char_col char(32), varchar_col varchar(32), 
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

insert into to_days_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,6,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,139,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, to_days(char_col) from to_days_tests order by smallint_col
select varchar_col, to_days(varchar_col) from to_days_tests order by smallint_col;
select string_col, to_days(string_col) from to_days_tests order by smallint_col;
select bit_col, to_days(bit_col) from to_days_tests order by smallint_col;
select integer_col, to_days(integer_col) from to_days_tests order by smallint_col;
select smallint_col, to_days(smallint_col) from to_days_tests order by smallint_col;
select bigint_col, to_days(bigint_col) from to_days_tests order by smallint_col;
--select float_col, to_days(float_col) from to_days_tests order by smallint_col;
select float_col, if(to_days(float_col)=to_days(date(concat(year(sysdate),'-12-25'))),'ok','nok') from to_days_tests order by smallint_col;
select double_col, to_days(double_col) from to_days_tests order by smallint_col;
--select numeric_col, to_days(numeric_col) from to_days_tests order by smallint_col;
select numeric_col, if(to_days(numeric_col)=to_days(date(concat(year(sysdate),'-11-12'))),'ok','nok') from to_days_tests order by smallint_col;
select monetary_col, to_days(monetary_col) from to_days_tests order by smallint_col;
select date_col, to_days(date_col) from to_days_tests order by smallint_col;
select time_col, to_days(time_col) from to_days_tests order by smallint_col;
select timestamp_col, to_days(timestamp_col) from to_days_tests order by smallint_col;
select datetime_col, to_days(datetime_col) from to_days_tests order by smallint_col;
select set_col, to_days(set_col) from to_days_tests order by smallint_col;


select * from to_days_tests where smallint_col < to_days(varchar_col) order by smallint_col;
select * from to_days_tests where smallint_col = to_days('2010-01-02')-734000 order by smallint_col;

drop table to_days_tests;

create table t (col varchar(255)) partition by list (to_days(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table to_days_tests as select to_days('2010-01-02') as [ to_days('2010-01-02')];

SELECT * FROM db_attribute where class_name='to_days_tests';

select * from to_days_tests;

drop table to_days_tests;

create view to_days_view(v) as select to_days('2010-01-02') from db_root;

select * from to_days_view;

drop to_days_view;

$varchar, $2009-01-01 20:18:32
select to_days(?) as rez;

$date, $1985-01-02
select to_days(?) as rez;

$datetime, $01/02/1985 12:13:15
select to_days(?) as rez;

$time, $12:23:15
select to_days(?) as rez;

$date, $1985-02-01
select 1 as rez from db_root where to_days(?) = 725038;

$datetime, $01/02/1985 12:13:14
select 1 as rez from db_root where to_days(?) = 2;

-- test for valid date time format
select to_days(datetime'2003-12-31 01:02:03.1234'), if (to_days(datetime'2003-12-31 01:02:03.1234') = 731945, 'ok', 'nok');
select to_days(timestamp'2003-12-31 01:02:03'), if (to_days(timestamp'2003-12-31 01:02:03') = 731945, 'ok', 'nok');
select to_days(date'2003-12-31'), if (to_days(date'2003-12-31') = 731945, 'ok', 'nok');


-- test for valid date, time string format
select to_days('2003-12-31 01:02:03.1234'), if (to_days('2003-12-31 01:02:03.1234') = 731945, 'ok', 'nok');
select to_days('2003-12-31 01:02:03'), if (to_days('2003-12-31 01:02:03') = 731945, 'ok', 'nok');
select to_days('2003-12-31'), if (to_days('2003-12-31') = 731945, 'ok', 'nok');


-- test for valid current_*
select if ((to_days(current_datetime) - to_days(current_date)) = 0, 'ok', 'nok');
select if ((to_days(current_timestamp) - to_days(current_date)) = 0, 'ok', 'nok');
select if ((to_days(current_date) - to_days(current_date)) = 0, 'ok', 'nok');

-- test for valid input
select to_days('2000-02-17') - to_days('1998-06-30'), if (to_days('2000-02-17') - to_days('1998-06-30') = date'2000-02-17' - date'1998-06-30', 'ok', 'nok');
select to_days('3772-02-17') - to_days('1898-06-30'), if (to_days('3772-02-17') - to_days('1898-06-30') = date'3772-02-17' - date'1898-06-30', 'ok', 'nok');
select to_days('2009-02-17') - to_days('2003-02-01'), if (to_days('2009-02-17') - to_days('2003-02-01') = date'2009-02-17' - date'2003-02-01', 'ok', 'nok');


-- test for special case
select to_days('1-1-1'), if (to_days('1-1-1') = 366, 'ok', 'nok');
select to_days('1/1/1'), if (to_days('1/1/1') = 366, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select to_days('2000-01-00 01:02:03');
select to_days('2000-12-32 01:02:03');
select to_days('1999-2-29 01:02:03');

select to_days('01:02:03');

set system parameters 'return_null_on_function_errors = no';

select to_days('2010-05-11') as q;

select to_days('2010-06-21') as q;

select to_days('2008-02-29') as q;

select to_days('1983-05-24') as q;

select to_days('01/01/2010') as q;

select to_days(str_to_date('12/25/1999', '%m/%d/%Y'));

select to_days('2010-01-01 12:20:00');

create table to_days_tests(char_col char(32), varchar_col varchar(32), 
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

insert into to_days_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,6,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,139,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, to_days(char_col) from to_days_tests order by smallint_col
select varchar_col, to_days(varchar_col) from to_days_tests order by smallint_col;
select string_col, to_days(string_col) from to_days_tests order by smallint_col;
select bit_col, to_days(bit_col) from to_days_tests order by smallint_col;
select integer_col, to_days(integer_col) from to_days_tests order by smallint_col;
select smallint_col, to_days(smallint_col) from to_days_tests order by smallint_col;
select bigint_col, to_days(bigint_col) from to_days_tests order by smallint_col;
--select float_col, to_days(float_col) from to_days_tests order by smallint_col;
select float_col, if(to_days(float_col)=to_days(date(concat(year(sysdate),'-12-25'))),'ok','nok') from to_days_tests order by smallint_col;
select double_col, to_days(double_col) from to_days_tests order by smallint_col;
--select numeric_col, to_days(numeric_col) from to_days_tests order by smallint_col;
select numeric_col, if(to_days(numeric_col)=to_days(date(concat(year(sysdate),'-11-12'))),'ok','nok') from to_days_tests order by smallint_col;
select monetary_col, to_days(monetary_col) from to_days_tests order by smallint_col;
select date_col, to_days(date_col) from to_days_tests order by smallint_col;
select time_col, to_days(time_col) from to_days_tests order by smallint_col;
select timestamp_col, to_days(timestamp_col) from to_days_tests order by smallint_col;
select datetime_col, to_days(datetime_col) from to_days_tests order by smallint_col;
select set_col, to_days(set_col) from to_days_tests order by smallint_col;


select * from to_days_tests where smallint_col < to_days(varchar_col) order by smallint_col;
select * from to_days_tests where smallint_col = to_days('2010-01-02')-734000 order by smallint_col;

drop table to_days_tests;

create table t (col varchar(255)) partition by list (to_days(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table to_days_tests as select to_days('2010-01-02') as [ to_days('2010-01-02')];

SELECT * FROM db_attribute where class_name='to_days_tests';

select * from to_days_tests;

drop table to_days_tests;

create view to_days_view(v) as select to_days('2010-01-02') from db_root;

select * from to_days_view;

drop to_days_view;

$varchar, $2009-01-01 20:18:32
select to_days(?) as rez;

$date, $1985-01-02
select to_days(?) as rez;

$datetime, $01/02/1985 12:13:15
select to_days(?) as rez;

$time, $12:23:15
select to_days(?) as rez;

$date, $1985-02-01
select 1 as rez from db_root where to_days(?) = 725038;

$datetime, $01/02/1985 12:13:14
select 1 as rez from db_root where to_days(?) = 2;

-- test for valid date time format
select to_days(datetime'2003-12-31 01:02:03.1234'), if (to_days(datetime'2003-12-31 01:02:03.1234') = 731945, 'ok', 'nok');
select to_days(timestamp'2003-12-31 01:02:03'), if (to_days(timestamp'2003-12-31 01:02:03') = 731945, 'ok', 'nok');
select to_days(date'2003-12-31'), if (to_days(date'2003-12-31') = 731945, 'ok', 'nok');


-- test for valid date, time string format
select to_days('2003-12-31 01:02:03.1234'), if (to_days('2003-12-31 01:02:03.1234') = 731945, 'ok', 'nok');
select to_days('2003-12-31 01:02:03'), if (to_days('2003-12-31 01:02:03') = 731945, 'ok', 'nok');
select to_days('2003-12-31'), if (to_days('2003-12-31') = 731945, 'ok', 'nok');


-- test for valid current_*
select if ((to_days(current_datetime) - to_days(current_date)) = 0, 'ok', 'nok');
select if ((to_days(current_timestamp) - to_days(current_date)) = 0, 'ok', 'nok');
select if ((to_days(current_date) - to_days(current_date)) = 0, 'ok', 'nok');

-- test for valid input
select to_days('2000-02-17') - to_days('1998-06-30'), if (to_days('2000-02-17') - to_days('1998-06-30') = date'2000-02-17' - date'1998-06-30', 'ok', 'nok');
select to_days('3772-02-17') - to_days('1898-06-30'), if (to_days('3772-02-17') - to_days('1898-06-30') = date'3772-02-17' - date'1898-06-30', 'ok', 'nok');
select to_days('2009-02-17') - to_days('2003-02-01'), if (to_days('2009-02-17') - to_days('2003-02-01') = date'2009-02-17' - date'2003-02-01', 'ok', 'nok');


-- test for special case
select to_days('1-1-1'), if (to_days('1-1-1') = 366, 'ok', 'nok');
select to_days('1/1/1'), if (to_days('1/1/1') = 366, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select to_days('2000-01-00 01:02:03');
select to_days('2000-12-32 01:02:03');
select to_days('1999-2-29 01:02:03');

select to_days('01:02:03');
commit;
--+ holdcas off;
