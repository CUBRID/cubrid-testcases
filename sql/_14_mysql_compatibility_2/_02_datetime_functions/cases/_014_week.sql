--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select week('2010-01-01',0);
select week('2010-01-01',1);
select week('2010-01-01',2);
select week('2010-01-01',3);
select week('2010-01-01',4);
select week('2010-01-01',5);
select week('2010-01-01',6);
select week('2010-01-01',7);

select week('2010-01-03',0);
select week('2010-01-03',1);
select week('2010-01-03',2);
select week('2010-01-03',3);
select week('2010-01-03',4);
select week('2010-01-03',5);
select week('2010-01-03',6);
select week('2010-01-03',7);

select week('2010-05-02',0);
select week('2010-05-02',1);
select week('2010-05-02',2);
select week('2010-05-02',3);
select week('2010-05-02',4);
select week('2010-05-02',5);
select week('2010-05-02',6);
select week('2010-05-02',7);

select week('2010-05-17',0);
select week('2010-05-17',1);
select week('2010-05-17',2);
select week('2010-05-17',3);
select week('2010-05-17',4);
select week('2010-05-17',5);
select week('2010-05-17',6);
select week('2010-05-17',7);

select week('2009-01-01',0);
select week('2009-01-01',1);
select week('2009-01-01',2);
select week('2009-01-01',3);
select week('2009-01-01',4);
select week('2009-01-01',5);
select week('2009-01-01',6);
select week('2009-01-01',7);

select week('2009-01-03',0);
select week('2009-01-03',1);
select week('2009-01-03',2);
select week('2009-01-03',3);
select week('2009-01-03',4);
select week('2009-01-03',5);
select week('2009-01-03',6);
select week('2009-01-03',7);

select week('2009-05-02',0);
select week('2009-05-02',1);
select week('2009-05-02',2);
select week('2009-05-02',3);
select week('2009-05-02',4);
select week('2009-05-02',5);
select week('2009-05-02',6);
select week('2009-05-02',7);

select week('2009-05-17',0);
select week('2009-05-17',1);
select week('2009-05-17',2);
select week('2009-05-17',3);
select week('2009-05-17',4);
select week('2009-05-17',5);
select week('2009-05-17',6);
select week('2009-05-17',7);

select week('2008-01-01',0);
select week('2008-01-01',1);
select week('2008-01-01',2);
select week('2008-01-01',3);
select week('2008-01-01',4);
select week('2008-01-01',5);
select week('2008-01-01',6);
select week('2008-01-01',7);

select week('2008-01-03',0);
select week('2008-01-03',1);
select week('2008-01-03',2);
select week('2008-01-03',3);
select week('2008-01-03',4);
select week('2008-01-03',5);
select week('2008-01-03',6);
select week('2008-01-03',7);

select week('2008-05-02',0);
select week('2008-05-02',1);
select week('2008-05-02',2);
select week('2008-05-02',3);
select week('2008-05-02',4);
select week('2008-05-02',5);
select week('2008-05-02',6);
select week('2008-05-02',7);

select week('2008-02-29',0);
select week('2008-02-29',1);
select week('2008-02-29',2);
select week('2008-02-29',3);
select week('2008-02-29',4);
select week('2008-02-29',5);
select week('2008-02-29',6);
select week('2008-02-29',7);

select week('2008-05-17',0);
select week('2008-05-17',1);
select week('2008-05-17',2);
select week('2008-05-17',3);
select week('2008-05-17',4);
select week('2008-05-17',5);
select week('2008-05-17',6);
select week('2008-05-17',7);

select week('2007-01-01',0);
select week('2007-01-01',1);
select week('2007-01-01',2);
select week('2007-01-01',3);
select week('2007-01-01',4);
select week('2007-01-01',5);
select week('2007-01-01',6);
select week('2007-01-01',7);

select week('2007-01-03',0);
select week('2007-01-03',1);
select week('2007-01-03',2);
select week('2007-01-03',3);
select week('2007-01-03',4);
select week('2007-01-03',5);
select week('2007-01-03',6);
select week('2007-01-03',7);

select week('2007-05-02',0);
select week('2007-05-02',1);
select week('2007-05-02',2);
select week('2007-05-02',3);
select week('2007-05-02',4);
select week('2007-05-02',5);
select week('2007-05-02',6);
select week('2007-05-02',7);

select week('2007-05-17',0);
select week('2007-05-17',1);
select week('2007-05-17',2);
select week('2007-05-17',3);
select week('2007-05-17',4);
select week('2007-05-17',5);
select week('2007-05-17',6);
select week('2007-05-17',7);

select week('2007-05-15',NULL);
select week('some text', 1);
select week('some other text');


create table week_tests(char_col char(32), varchar_col varchar(32), 
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

insert into week_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, week(char_col) from week_tests order by smallint_col;
select varchar_col, week(varchar_col) from week_tests order by smallint_col;
select string_col, week(string_col) from week_tests order by smallint_col;
select bit_col, week(bit_col) from week_tests order by smallint_col;
select integer_col, week(integer_col) from week_tests order by smallint_col;
select smallint_col, week(smallint_col) from week_tests order by smallint_col;
select bigint_col, week(bigint_col) from week_tests order by smallint_col;
select float_col, week(float_col) from week_tests order by smallint_col;
select double_col, week(double_col) from week_tests order by smallint_col;
select numeric_col, week(numeric_col) from week_tests order by smallint_col;
select monetary_col, week(monetary_col) from week_tests order by smallint_col;
select date_col, week(date_col) from week_tests order by smallint_col;
select time_col, week(time_col) from week_tests order by smallint_col;
select timestamp_col, week(timestamp_col) from week_tests order by smallint_col;
select datetime_col, week(datetime_col) from week_tests order by smallint_col;
select set_col, week(set_col) from week_tests order by smallint_col; 

select char_col, week(varchar_col,char_col) from week_tests order by smallint_col;
select varchar_col, week(varchar_col,varchar_col) from week_tests order by smallint_col;
select string_col, week(varchar_col,string_col) from week_tests order by smallint_col;
select bit_col, week(varchar_col,bit_col) from week_tests order by smallint_col;
select integer_col, week(varchar_col,integer_col) from week_tests order by smallint_col;
select smallint_col, week(varchar_col,smallint_col) from week_tests order by smallint_col;
select bigint_col, week(varchar_col,bigint_col) from week_tests order by smallint_col;
select float_col, week(varchar_col,float_col) from week_tests order by smallint_col;
select double_col, week(varchar_col,double_col) from week_tests order by smallint_col;
select numeric_col, week(varchar_col,numeric_col) from week_tests order by smallint_col;
select monetary_col, week(varchar_col,monetary_col) from week_tests order by smallint_col;
select date_col, week(varchar_col,date_col) from week_tests order by smallint_col;
select time_col, week(varchar_col,time_col) from week_tests order by smallint_col;
select timestamp_col, week(varchar_col,timestamp_col) from week_tests order by smallint_col;
select datetime_col, week(varchar_col,datetime_col) from week_tests order by smallint_col;
select set_col, week(varchar_col,set_col) from week_tests order by smallint_col; 

select * from week_tests where smallint_col = week('2010-01-02')+10 order by smallint_col;
select * from week_tests where smallint_col < week(varchar_col) order by smallint_col;

drop table week_tests;

create table t (col varchar(255)) partition by list (week(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table week_tests as select week('2010-01-02');

SELECT * FROM db_attribute where class_name='week_tests';

select * from week_tests;

drop table week_tests;

create view week_view(v) as select week('2010-01-02') from db_root;

select * from week_view;

drop week_view;

$varchar, $2009-01-01 20:18:32
select week(?) as rez;

$date, $1985-01-02
select week(?) as rez;

$datetime, $01/02/1985 12:13:15
select week(?,1) as rez;

$datetime, $01/02/1985 12:13:15
select 1 as rez from db_root where week(?) = 1;

$int, $1
select week('2010-01-01',?) as rez;

$int, $2
select 1 as rez from db_root where week('2010-01-01',?) = 1;

$datetime, $01/02/1985 12:13:15, $int, $1
select 1 as rez from db_root where week(?,?) = 1;

set system parameters 'default_week_format=2';
select week ('2010-01-01');

set system parameters 'default_week_format=3';
select week ('2010-01-01');

set system parameters 'default_week_format=0';

-- test for valid date time format
select week(datetime'2003-12-31 01:02:03.1234'), if (week(datetime'2003-12-31 01:02:03.1234') = 52, 'ok', 'nok');
select week(timestamp'2003-12-31 01:02:03'), if (week(timestamp'2003-12-31 01:02:03') = 52, 'ok', 'nok');
select week(date'2003-12-31'), if (week(date'2003-12-31') = 52, 'ok', 'nok');


-- test for valid date, time string format
select week('2003-12-31 01:02:03.1234'), if (week('2003-12-31 01:02:03.1234') = 52, 'ok', 'nok');
select week('2003-12-31 01:02:03'), if (week('2003-12-31 01:02:03') = 52, 'ok', 'nok');
select week('2003-12-31'), if (week('2003-12-31') = 52, 'ok', 'nok');


-- test for valid current_*
select if ((week(current_datetime) - week(current_date)) = 0, 'ok', 'nok');
select if ((week(current_timestamp) - week(current_date)) = 0, 'ok', 'nok');
select if ((week(current_date) - week(current_date)) = 0, 'ok', 'nok');

-- test for valid input
select week('2000-12-01') - week(date'2000-12-01'-7*14), if (week('2000-12-01') - week(date'2000-12-01'-7*14) = 14, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*8),  if (week('2000-12-01') - week(date'2000-12-01'-7*8)  =  8, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*20), if (week('2000-12-01') - week(date'2000-12-01'-7*20) = 20, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*22), if (week('2000-12-01') - week(date'2000-12-01'-7*22) = 22, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*35), if (week('2000-12-01') - week(date'2000-12-01'-7*35) = 35, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*14), if (week('1973-12-01') - week(date'1973-12-01'-7*14) = 14, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*8),  if (week('1973-12-01') - week(date'1973-12-01'-7*8)  =  8, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*20), if (week('1973-12-01') - week(date'1973-12-01'-7*20) = 20, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*22), if (week('1973-12-01') - week(date'1973-12-01'-7*22) = 22, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*35), if (week('1973-12-01') - week(date'1973-12-01'-7*35) = 35, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*14), if (week('1936-12-01') - week(date'1936-12-01'-7*14) = 14, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*8),  if (week('1936-12-01') - week(date'1936-12-01'-7*8)  =  8, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*20), if (week('1936-12-01') - week(date'1936-12-01'-7*20) = 20, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*22), if (week('1936-12-01') - week(date'1936-12-01'-7*22) = 22, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*35), if (week('1936-12-01') - week(date'1936-12-01'-7*35) = 35, 'ok', 'nok');


-- test for valid option

select week('2010-01-02', 0), if (week('2010-01-02', 0) = 0, 'ok', 'nok');  -- 0-53 sunday (sunday)
select week('2010-01-03', 0), if (week('2010-01-03', 0) = 1, 'ok', 'nok');

select week('2010-01-02', 2), if (week('2010-01-02', 2) = 52, 'ok', 'nok'); -- 1-53 sunday (sunday)
select week('2010-01-03', 2), if (week('2010-01-03', 2) = 1, 'ok', 'nok');

select week('2010-01-03', 5), if (week('2010-01-03', 5) = 0, 'ok', 'nok'); -- 0-53 sunday (monday)
select week('2010-01-04', 5), if (week('2010-01-04', 5) = 1, 'ok', 'nok');

select week('2010-01-03', 7), if (week('2010-01-03', 7) = 52, 'ok', 'nok'); -- 1-53 sunday (monday)
select week('2010-01-04', 7), if (week('2010-01-04', 7) = 1, 'ok', 'nok');


select week('2010-01-01', 1), if (week('2010-01-01', 1) = 0, 'ok', 'nok');  -- 0-53 3day, monday
select week('2010-01-03', 1), if (week('2010-01-03', 1) = 0, 'ok', 'nok'); 
select week('2010-01-04', 1), if (week('2010-01-04', 1) = 1, 'ok', 'nok'); 
select week('2008-01-01', 1), if (week('2008-01-01', 1) = 1, 'ok', 'nok');
select week('2008-01-06', 1), if (week('2008-01-06', 1) = 1, 'ok', 'nok');
select week('2008-01-07', 1), if (week('2008-01-07', 1) = 2, 'ok', 'nok');

select week('2010-01-01', 3), if (week('2010-01-01', 3) = 53, 'ok', 'nok');  -- 1-53 3day, monday
select week('2010-01-03', 3), if (week('2010-01-03', 3) = 53, 'ok', 'nok'); 
select week('2010-01-04', 3), if (week('2010-01-04', 3) = 1, 'ok', 'nok'); 
select week('2008-01-01', 3), if (week('2008-01-01', 3) = 1, 'ok', 'nok');
select week('2008-01-06', 3), if (week('2008-01-06', 3) = 1, 'ok', 'nok');
select week('2008-01-07', 3), if (week('2008-01-07', 3) = 2, 'ok', 'nok');

select week('2010-01-01', 4), if (week('2010-01-01', 4) = 0, 'ok', 'nok');  -- 0-53 3day, sunday
select week('2010-01-02', 4), if (week('2010-01-02', 4) = 0, 'ok', 'nok'); 
select week('2010-01-03', 4), if (week('2010-01-03', 4) = 1, 'ok', 'nok'); 
select week('2008-01-01', 4), if (week('2008-01-01', 4) = 1, 'ok', 'nok');
select week('2008-01-05', 4), if (week('2008-01-05', 4) = 1, 'ok', 'nok');
select week('2008-01-06', 4), if (week('2008-01-06', 4) = 2, 'ok', 'nok');

select week('2010-01-01', 6), if (week('2010-01-01', 6) = 52, 'ok', 'nok');  -- 1-53 3day, sunday
select week('2010-01-02', 6), if (week('2010-01-02', 6) = 52, 'ok', 'nok'); 
select week('2010-01-03', 6), if (week('2010-01-03', 6) = 1, 'ok', 'nok'); 
select week('2008-01-01', 6), if (week('2008-01-01', 6) = 1, 'ok', 'nok');
select week('2008-01-05', 6), if (week('2008-01-05', 6) = 1, 'ok', 'nok');
select week('2008-01-06', 6), if (week('2008-01-06', 6) = 2, 'ok', 'nok');


-- test for special case
select week('1-1-1'), if (week('1-1-1') = 0, 'ok', 'nok');
select week('1/1/1'), if (week('1/1/1') = 0, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select week('2000-01-00 01:02:03');
select week('2000-12-32 01:02:03');
select week('1999-2-29 01:02:03');

select week('01:02:03');

set system parameters 'return_null_on_function_errors = no';
select week('2010-01-01',0);
select week('2010-01-01',1);
select week('2010-01-01',2);
select week('2010-01-01',3);
select week('2010-01-01',4);
select week('2010-01-01',5);
select week('2010-01-01',6);
select week('2010-01-01',7);

select week('2010-01-03',0);
select week('2010-01-03',1);
select week('2010-01-03',2);
select week('2010-01-03',3);
select week('2010-01-03',4);
select week('2010-01-03',5);
select week('2010-01-03',6);
select week('2010-01-03',7);

select week('2010-05-02',0);
select week('2010-05-02',1);
select week('2010-05-02',2);
select week('2010-05-02',3);
select week('2010-05-02',4);
select week('2010-05-02',5);
select week('2010-05-02',6);
select week('2010-05-02',7);

select week('2010-05-17',0);
select week('2010-05-17',1);
select week('2010-05-17',2);
select week('2010-05-17',3);
select week('2010-05-17',4);
select week('2010-05-17',5);
select week('2010-05-17',6);
select week('2010-05-17',7);

select week('2009-01-01',0);
select week('2009-01-01',1);
select week('2009-01-01',2);
select week('2009-01-01',3);
select week('2009-01-01',4);
select week('2009-01-01',5);
select week('2009-01-01',6);
select week('2009-01-01',7);

select week('2009-01-03',0);
select week('2009-01-03',1);
select week('2009-01-03',2);
select week('2009-01-03',3);
select week('2009-01-03',4);
select week('2009-01-03',5);
select week('2009-01-03',6);
select week('2009-01-03',7);

select week('2009-05-02',0);
select week('2009-05-02',1);
select week('2009-05-02',2);
select week('2009-05-02',3);
select week('2009-05-02',4);
select week('2009-05-02',5);
select week('2009-05-02',6);
select week('2009-05-02',7);

select week('2009-05-17',0);
select week('2009-05-17',1);
select week('2009-05-17',2);
select week('2009-05-17',3);
select week('2009-05-17',4);
select week('2009-05-17',5);
select week('2009-05-17',6);
select week('2009-05-17',7);

select week('2008-01-01',0);
select week('2008-01-01',1);
select week('2008-01-01',2);
select week('2008-01-01',3);
select week('2008-01-01',4);
select week('2008-01-01',5);
select week('2008-01-01',6);
select week('2008-01-01',7);

select week('2008-01-03',0);
select week('2008-01-03',1);
select week('2008-01-03',2);
select week('2008-01-03',3);
select week('2008-01-03',4);
select week('2008-01-03',5);
select week('2008-01-03',6);
select week('2008-01-03',7);

select week('2008-05-02',0);
select week('2008-05-02',1);
select week('2008-05-02',2);
select week('2008-05-02',3);
select week('2008-05-02',4);
select week('2008-05-02',5);
select week('2008-05-02',6);
select week('2008-05-02',7);

select week('2008-02-29',0);
select week('2008-02-29',1);
select week('2008-02-29',2);
select week('2008-02-29',3);
select week('2008-02-29',4);
select week('2008-02-29',5);
select week('2008-02-29',6);
select week('2008-02-29',7);

select week('2008-05-17',0);
select week('2008-05-17',1);
select week('2008-05-17',2);
select week('2008-05-17',3);
select week('2008-05-17',4);
select week('2008-05-17',5);
select week('2008-05-17',6);
select week('2008-05-17',7);

select week('2007-01-01',0);
select week('2007-01-01',1);
select week('2007-01-01',2);
select week('2007-01-01',3);
select week('2007-01-01',4);
select week('2007-01-01',5);
select week('2007-01-01',6);
select week('2007-01-01',7);

select week('2007-01-03',0);
select week('2007-01-03',1);
select week('2007-01-03',2);
select week('2007-01-03',3);
select week('2007-01-03',4);
select week('2007-01-03',5);
select week('2007-01-03',6);
select week('2007-01-03',7);

select week('2007-05-02',0);
select week('2007-05-02',1);
select week('2007-05-02',2);
select week('2007-05-02',3);
select week('2007-05-02',4);
select week('2007-05-02',5);
select week('2007-05-02',6);
select week('2007-05-02',7);

select week('2007-05-17',0);
select week('2007-05-17',1);
select week('2007-05-17',2);
select week('2007-05-17',3);
select week('2007-05-17',4);
select week('2007-05-17',5);
select week('2007-05-17',6);
select week('2007-05-17',7);

select week('2007-05-15',NULL);
select week('some text', 1);
select week('some other text');


create table week_tests(char_col char(32), varchar_col varchar(32), 
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

insert into week_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, week(char_col) from week_tests order by smallint_col;
select varchar_col, week(varchar_col) from week_tests order by smallint_col;
select string_col, week(string_col) from week_tests order by smallint_col;
select bit_col, week(bit_col) from week_tests order by smallint_col;
select integer_col, week(integer_col) from week_tests order by smallint_col;
select smallint_col, week(smallint_col) from week_tests order by smallint_col;
select bigint_col, week(bigint_col) from week_tests order by smallint_col;
select float_col, week(float_col) from week_tests order by smallint_col;
select double_col, week(double_col) from week_tests order by smallint_col;
select numeric_col, week(numeric_col) from week_tests order by smallint_col;
select monetary_col, week(monetary_col) from week_tests order by smallint_col;
select date_col, week(date_col) from week_tests order by smallint_col;
select time_col, week(time_col) from week_tests order by smallint_col;
select timestamp_col, week(timestamp_col) from week_tests order by smallint_col;
select datetime_col, week(datetime_col) from week_tests order by smallint_col;
select set_col, week(set_col) from week_tests order by smallint_col; 

select char_col, week(varchar_col,char_col) from week_tests order by smallint_col;
select varchar_col, week(varchar_col,varchar_col) from week_tests order by smallint_col;
select string_col, week(varchar_col,string_col) from week_tests order by smallint_col;
select bit_col, week(varchar_col,bit_col) from week_tests order by smallint_col;
select integer_col, week(varchar_col,integer_col) from week_tests order by smallint_col;
select smallint_col, week(varchar_col,smallint_col) from week_tests order by smallint_col;
select bigint_col, week(varchar_col,bigint_col) from week_tests order by smallint_col;
select float_col, week(varchar_col,float_col) from week_tests order by smallint_col;
select double_col, week(varchar_col,double_col) from week_tests order by smallint_col;
select numeric_col, week(varchar_col,numeric_col) from week_tests order by smallint_col;
select monetary_col, week(varchar_col,monetary_col) from week_tests order by smallint_col;
select date_col, week(varchar_col,date_col) from week_tests order by smallint_col;
select time_col, week(varchar_col,time_col) from week_tests order by smallint_col;
select timestamp_col, week(varchar_col,timestamp_col) from week_tests order by smallint_col;
select datetime_col, week(varchar_col,datetime_col) from week_tests order by smallint_col;
select set_col, week(varchar_col,set_col) from week_tests order by smallint_col; 

select * from week_tests where smallint_col = week('2010-01-02')+10 order by smallint_col;
select * from week_tests where smallint_col < week(varchar_col) order by smallint_col;

drop table week_tests;

create table t (col varchar(255)) partition by list (week(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table week_tests as select week('2010-01-02');

SELECT * FROM db_attribute where class_name='week_tests';

select * from week_tests;

drop table week_tests;

create view week_view(v) as select week('2010-01-02') from db_root;

select * from week_view;

drop week_view;

$varchar, $2009-01-01 20:18:32
select week(?) as rez;

$date, $1985-01-02
select week(?) as rez;

$datetime, $01/02/1985 12:13:15
select week(?,1) as rez;

$datetime, $01/02/1985 12:13:15
select 1 as rez from db_root where week(?) = 1;

$int, $1
select week('2010-01-01',?) as rez;

$int, $2
select 1 as rez from db_root where week('2010-01-01',?) = 1;

$datetime, $01/02/1985 12:13:15, $int, $1
select 1 as rez from db_root where week(?,?) = 1;

set system parameters 'default_week_format=2';
select week ('2010-01-01');

set system parameters 'default_week_format=3';
select week ('2010-01-01');

set system parameters 'default_week_format=0';

-- test for valid date time format
select week(datetime'2003-12-31 01:02:03.1234'), if (week(datetime'2003-12-31 01:02:03.1234') = 52, 'ok', 'nok');
select week(timestamp'2003-12-31 01:02:03'), if (week(timestamp'2003-12-31 01:02:03') = 52, 'ok', 'nok');
select week(date'2003-12-31'), if (week(date'2003-12-31') = 52, 'ok', 'nok');


-- test for valid date, time string format
select week('2003-12-31 01:02:03.1234'), if (week('2003-12-31 01:02:03.1234') = 52, 'ok', 'nok');
select week('2003-12-31 01:02:03'), if (week('2003-12-31 01:02:03') = 52, 'ok', 'nok');
select week('2003-12-31'), if (week('2003-12-31') = 52, 'ok', 'nok');


-- test for valid current_*
select if ((week(current_datetime) - week(current_date)) = 0, 'ok', 'nok');
select if ((week(current_timestamp) - week(current_date)) = 0, 'ok', 'nok');
select if ((week(current_date) - week(current_date)) = 0, 'ok', 'nok');

-- test for valid input
select week('2000-12-01') - week(date'2000-12-01'-7*14), if (week('2000-12-01') - week(date'2000-12-01'-7*14) = 14, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*8),  if (week('2000-12-01') - week(date'2000-12-01'-7*8)  =  8, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*20), if (week('2000-12-01') - week(date'2000-12-01'-7*20) = 20, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*22), if (week('2000-12-01') - week(date'2000-12-01'-7*22) = 22, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*35), if (week('2000-12-01') - week(date'2000-12-01'-7*35) = 35, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*14), if (week('1973-12-01') - week(date'1973-12-01'-7*14) = 14, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*8),  if (week('1973-12-01') - week(date'1973-12-01'-7*8)  =  8, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*20), if (week('1973-12-01') - week(date'1973-12-01'-7*20) = 20, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*22), if (week('1973-12-01') - week(date'1973-12-01'-7*22) = 22, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*35), if (week('1973-12-01') - week(date'1973-12-01'-7*35) = 35, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*14), if (week('1936-12-01') - week(date'1936-12-01'-7*14) = 14, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*8),  if (week('1936-12-01') - week(date'1936-12-01'-7*8)  =  8, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*20), if (week('1936-12-01') - week(date'1936-12-01'-7*20) = 20, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*22), if (week('1936-12-01') - week(date'1936-12-01'-7*22) = 22, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*35), if (week('1936-12-01') - week(date'1936-12-01'-7*35) = 35, 'ok', 'nok');


-- test for valid option

select week('2010-01-02', 0), if (week('2010-01-02', 0) = 0, 'ok', 'nok');  -- 0-53 sunday (sunday)
select week('2010-01-03', 0), if (week('2010-01-03', 0) = 1, 'ok', 'nok');

select week('2010-01-02', 2), if (week('2010-01-02', 2) = 52, 'ok', 'nok'); -- 1-53 sunday (sunday)
select week('2010-01-03', 2), if (week('2010-01-03', 2) = 1, 'ok', 'nok');

select week('2010-01-03', 5), if (week('2010-01-03', 5) = 0, 'ok', 'nok'); -- 0-53 sunday (monday)
select week('2010-01-04', 5), if (week('2010-01-04', 5) = 1, 'ok', 'nok');

select week('2010-01-03', 7), if (week('2010-01-03', 7) = 52, 'ok', 'nok'); -- 1-53 sunday (monday)
select week('2010-01-04', 7), if (week('2010-01-04', 7) = 1, 'ok', 'nok');


select week('2010-01-01', 1), if (week('2010-01-01', 1) = 0, 'ok', 'nok');  -- 0-53 3day, monday
select week('2010-01-03', 1), if (week('2010-01-03', 1) = 0, 'ok', 'nok'); 
select week('2010-01-04', 1), if (week('2010-01-04', 1) = 1, 'ok', 'nok'); 
select week('2008-01-01', 1), if (week('2008-01-01', 1) = 1, 'ok', 'nok');
select week('2008-01-06', 1), if (week('2008-01-06', 1) = 1, 'ok', 'nok');
select week('2008-01-07', 1), if (week('2008-01-07', 1) = 2, 'ok', 'nok');

select week('2010-01-01', 3), if (week('2010-01-01', 3) = 53, 'ok', 'nok');  -- 1-53 3day, monday
select week('2010-01-03', 3), if (week('2010-01-03', 3) = 53, 'ok', 'nok'); 
select week('2010-01-04', 3), if (week('2010-01-04', 3) = 1, 'ok', 'nok'); 
select week('2008-01-01', 3), if (week('2008-01-01', 3) = 1, 'ok', 'nok');
select week('2008-01-06', 3), if (week('2008-01-06', 3) = 1, 'ok', 'nok');
select week('2008-01-07', 3), if (week('2008-01-07', 3) = 2, 'ok', 'nok');

select week('2010-01-01', 4), if (week('2010-01-01', 4) = 0, 'ok', 'nok');  -- 0-53 3day, sunday
select week('2010-01-02', 4), if (week('2010-01-02', 4) = 0, 'ok', 'nok'); 
select week('2010-01-03', 4), if (week('2010-01-03', 4) = 1, 'ok', 'nok'); 
select week('2008-01-01', 4), if (week('2008-01-01', 4) = 1, 'ok', 'nok');
select week('2008-01-05', 4), if (week('2008-01-05', 4) = 1, 'ok', 'nok');
select week('2008-01-06', 4), if (week('2008-01-06', 4) = 2, 'ok', 'nok');

select week('2010-01-01', 6), if (week('2010-01-01', 6) = 52, 'ok', 'nok');  -- 1-53 3day, sunday
select week('2010-01-02', 6), if (week('2010-01-02', 6) = 52, 'ok', 'nok'); 
select week('2010-01-03', 6), if (week('2010-01-03', 6) = 1, 'ok', 'nok'); 
select week('2008-01-01', 6), if (week('2008-01-01', 6) = 1, 'ok', 'nok');
select week('2008-01-05', 6), if (week('2008-01-05', 6) = 1, 'ok', 'nok');
select week('2008-01-06', 6), if (week('2008-01-06', 6) = 2, 'ok', 'nok');


-- test for special case
select week('1-1-1'), if (week('1-1-1') = 0, 'ok', 'nok');
select week('1/1/1'), if (week('1/1/1') = 0, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select week('2000-01-00 01:02:03');
select week('2000-12-32 01:02:03');
select week('1999-2-29 01:02:03');

select week('01:02:03');
commit;
--+ holdcas off;
