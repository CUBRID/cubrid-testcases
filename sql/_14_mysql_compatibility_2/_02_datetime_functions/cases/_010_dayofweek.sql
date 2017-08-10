--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select date_format('2000-01-02', '%w=>%W'), dayofweek('2000-01-02');

select date_format('2000-01-03', '%w=>%W'), dayofweek('2000-01-03');

select date_format('2000-01-04', '%w=>%W'), dayofweek('2000-01-04');

select date_format('2000-01-05', '%w=>%W'), dayofweek('2000-01-05');

select date_format('2000-01-06', '%w=>%W'), dayofweek('2000-01-06');

select date_format('2000-01-07', '%w=>%W'), dayofweek('2000-01-07');

select date_format('2000-01-08', '%w=>%W'), dayofweek('2000-01-08');

select date_format('01/01/2010', '%W'), dayofweek('01/01/2010');

select dayofweek(str_to_date('12/25/1999', '%m/%d/%Y'));

select dayofweek('2010-01-01 12:20:00');

create table dayofweek_tests(char_col char(32), varchar_col varchar(32), 
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

insert into dayofweek_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,6,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,2,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, dayofweek(char_col) from dayofweek_tests order by smallint_col;
select varchar_col, dayofweek(varchar_col) from dayofweek_tests order by smallint_col;
select string_col, dayofweek(string_col) from dayofweek_tests order by smallint_col;
select bit_col, dayofweek(bit_col) from dayofweek_tests order by smallint_col;
select integer_col, dayofweek(integer_col) from dayofweek_tests order by smallint_col;
select smallint_col, dayofweek(smallint_col) from dayofweek_tests order by smallint_col;
select bigint_col, dayofweek(bigint_col) from dayofweek_tests order by smallint_col;
--select float_col, dayofweek(float_col) from dayofweek_tests order by smallint_col;
select float_col, if(dayofweek(float_col)=dayofweek(concat(year(sysdate),'-12-25')),'ok','nok') from dayofweek_tests order by smallint_col;
select double_col, dayofweek(double_col) from dayofweek_tests order by smallint_col;
--select numeric_col, dayofweek(numeric_col) from dayofweek_tests order by smallint_col;
select numeric_col, if(dayofweek(numeric_col)=dayofweek(concat(year(sysdate),'-11-12')),'ok','nok') from dayofweek_tests order by smallint_col;
select monetary_col, dayofweek(monetary_col) from dayofweek_tests order by smallint_col;
select date_col, dayofweek(date_col) from dayofweek_tests order by smallint_col;
select time_col, dayofweek(time_col) from dayofweek_tests order by smallint_col;
select timestamp_col, dayofweek(timestamp_col) from dayofweek_tests order by smallint_col;
select datetime_col, dayofweek(datetime_col) from dayofweek_tests order by smallint_col;
select set_col, dayofweek(set_col) from dayofweek_tests order by smallint_col;


select * from dayofweek_tests where smallint_col = dayofweek('2010-01-02')-1 order by smallint_col;
select * from dayofweek_tests where smallint_col < dayofweek(varchar_col) order by smallint_col;

drop table dayofweek_tests;

create table t (col varchar(255)) partition by list (dayofweek(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table dayofweek_tests as select dayofweek('2010-01-02');

SELECT * FROM db_attribute where class_name='dayofweek_tests';

select * from dayofweek_tests;

drop table dayofweek_tests;

create view dayofweek_view(v) as select dayofweek('2010-01-02') from db_root;

select * from dayofweek_view;

drop dayofweek_view;

$varchar, $2009-01-01 20:18:32
select dayofweek(?) as rez;

$date, $1985-01-02
select dayofweek(?) as rez;

$datetime, $01/02/1985 12:13:15
select dayofweek(?) as rez;

$time, $12:23:15
select dayofweek(?) as rez;

$date, $1985-04-05
select 1 as rez from db_root where dayofweek(?) = 6;

$datetime, $01/03/1985 19:45:00
select 1 as rez from db_root where dayofweek(?) = 2;

-- test for valid date time format
select dayofweek(datetime'2003-08-23 01:02:03.1234'), if (dayofweek(datetime'2010-08-23 01:02:03.1234') = 2, 'ok', 'nok');
select dayofweek(timestamp'2010-08-23 01:02:03'), if (dayofweek(timestamp'2010-08-23 01:02:03') = 2, 'ok', 'nok');
select dayofweek(date'2010-08-23'), if (dayofweek(date'2010-08-23') = 2, 'ok', 'nok');


-- test for valid date, time string format
select dayofweek('2010-08-23 01:02:03.1234'), if (dayofweek('2010-08-23 01:02:03.1234') = 2, 'ok', 'nok');
select dayofweek('2010-08-23 01:02:03'), if (dayofweek('2010-08-23 01:02:03') = 2, 'ok', 'nok');
select dayofweek('2010-08-23'), if (dayofweek('2010-08-23') = 2, 'ok', 'nok');


-- test for valid current_*
select if (dayofweek(current_datetime)= CAST(date_format(current_datetime,'%w') AS INTEGER)+1, 'ok', 'nok');
select if (dayofweek(current_timestamp)= CAST(date_format(current_timestamp,'%w') AS INTEGER)+1, 'ok', 'nok');
select if (dayofweek(current_date)= CAST(date_format(current_date,'%w') AS INTEGER)+1, 'ok', 'nok');

-- test for normal case
select dayofweek('2010-08-01'), if (dayofweek('2010-08-01') = 1, 'ok', 'nok');
select dayofweek('2010-08-02'), if (dayofweek('2010-08-02') = 2, 'ok', 'nok');
select dayofweek('2010-08-03'), if (dayofweek('2010-08-03') = 3, 'ok', 'nok');
select dayofweek('2010-08-04'), if (dayofweek('2010-08-04') = 4, 'ok', 'nok');
select dayofweek('2010-08-05'), if (dayofweek('2010-08-05') = 5, 'ok', 'nok');
select dayofweek('2010-08-06'), if (dayofweek('2010-08-06') = 6, 'ok', 'nok');
select dayofweek('2010-08-07'), if (dayofweek('2010-08-07') = 7, 'ok', 'nok');

select dayofweek('2000-08-01'), if (dayofweek('2000-08-01') = 3, 'ok', 'nok');
select dayofweek('2000-08-02'), if (dayofweek('2000-08-02') = 4, 'ok', 'nok');
select dayofweek('2000-08-03'), if (dayofweek('2000-08-03') = 5, 'ok', 'nok');
select dayofweek('2000-08-04'), if (dayofweek('2000-08-04') = 6, 'ok', 'nok');
select dayofweek('2000-08-05'), if (dayofweek('2000-08-05') = 7, 'ok', 'nok');
select dayofweek('2000-08-06'), if (dayofweek('2000-08-06') = 1, 'ok', 'nok');
select dayofweek('2000-08-07'), if (dayofweek('2000-08-07') = 2, 'ok', 'nok');


-- test for special case
select dayofweek('2000-08-06'), if (dayofweek('2000-08-06') = 1, 'ok', 'nok');
select dayofweek(date'2000-08-06' - 1), if (dayofweek(date'2000-08-06' - 1) = 7, 'ok', 'nok');
select dayofweek('2000-08-05'), if (dayofweek('2000-08-05') = 7, 'ok', 'nok');
select dayofweek(date'2000-08-05' + 1), if (dayofweek(date'2000-08-05' + 1) = 1, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select dayofweek('2000-01-00 01:02:03');
select dayofweek('2000-12-32 01:02:03');
select dayofweek('1999-2-29 01:02:03');

select dayofweek('01:02:03');

set system parameters 'return_null_on_function_errors = no';

select date_format('2000-01-02', '%w=>%W'), dayofweek('2000-01-02');

select date_format('2000-01-03', '%w=>%W'), dayofweek('2000-01-03');

select date_format('2000-01-04', '%w=>%W'), dayofweek('2000-01-04');

select date_format('2000-01-05', '%w=>%W'), dayofweek('2000-01-05');

select date_format('2000-01-06', '%w=>%W'), dayofweek('2000-01-06');

select date_format('2000-01-07', '%w=>%W'), dayofweek('2000-01-07');

select date_format('2000-01-08', '%w=>%W'), dayofweek('2000-01-08');

select date_format('01/01/2010', '%W'), dayofweek('01/01/2010');

select dayofweek(str_to_date('12/25/1999', '%m/%d/%Y'));

select dayofweek('2010-01-01 12:20:00');

create table dayofweek_tests(char_col char(32), varchar_col varchar(32), 
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

insert into dayofweek_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,6,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,2,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, dayofweek(char_col) from dayofweek_tests order by smallint_col;
select varchar_col, dayofweek(varchar_col) from dayofweek_tests order by smallint_col;
select string_col, dayofweek(string_col) from dayofweek_tests order by smallint_col;
select bit_col, dayofweek(bit_col) from dayofweek_tests order by smallint_col;
select integer_col, dayofweek(integer_col) from dayofweek_tests order by smallint_col;
select smallint_col, dayofweek(smallint_col) from dayofweek_tests order by smallint_col;
select bigint_col, dayofweek(bigint_col) from dayofweek_tests order by smallint_col;
--select float_col, dayofweek(float_col) from dayofweek_tests order by smallint_col;
select float_col, if(dayofweek(float_col)=dayofweek(concat(year(sysdate),'-12-25')),'ok','nok') from dayofweek_tests order by smallint_col;
select double_col, dayofweek(double_col) from dayofweek_tests order by smallint_col;
--select numeric_col, dayofweek(numeric_col) from dayofweek_tests order by smallint_col;
select numeric_col, if(dayofweek(numeric_col)=dayofweek(concat(year(sysdate),'-11-12')),'ok','nok') from dayofweek_tests order by smallint_col;
select monetary_col, dayofweek(monetary_col) from dayofweek_tests order by smallint_col;
select date_col, dayofweek(date_col) from dayofweek_tests order by smallint_col;
select time_col, dayofweek(time_col) from dayofweek_tests order by smallint_col;
select timestamp_col, dayofweek(timestamp_col) from dayofweek_tests order by smallint_col;
select datetime_col, dayofweek(datetime_col) from dayofweek_tests order by smallint_col;
select set_col, dayofweek(set_col) from dayofweek_tests order by smallint_col;


select * from dayofweek_tests where smallint_col = dayofweek('2010-01-02')-1 order by smallint_col;
select * from dayofweek_tests where smallint_col < dayofweek(varchar_col) order by smallint_col;

drop table dayofweek_tests;

create table t (col varchar(255)) partition by list (dayofweek(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table dayofweek_tests as select dayofweek('2010-01-02');

SELECT * FROM db_attribute where class_name='dayofweek_tests';

select * from dayofweek_tests;

drop table dayofweek_tests;

create view dayofweek_view(v) as select dayofweek('2010-01-02') from db_root;

select * from dayofweek_view;

drop dayofweek_view;

$varchar, $2009-01-01 20:18:32
select dayofweek(?) as rez;

$date, $1985-01-02
select dayofweek(?) as rez;

$datetime, $01/02/1985 12:13:15
select dayofweek(?) as rez;

$time, $12:23:15
select dayofweek(?) as rez;

$date, $1985-04-05
select 1 as rez from db_root where dayofweek(?) = 6;

$datetime, $01/03/1985 19:45:00
select 1 as rez from db_root where dayofweek(?) = 2;

-- test for valid date time format
select dayofweek(datetime'2003-08-23 01:02:03.1234'), if (dayofweek(datetime'2010-08-23 01:02:03.1234') = 2, 'ok', 'nok');
select dayofweek(timestamp'2010-08-23 01:02:03'), if (dayofweek(timestamp'2010-08-23 01:02:03') = 2, 'ok', 'nok');
select dayofweek(date'2010-08-23'), if (dayofweek(date'2010-08-23') = 2, 'ok', 'nok');


-- test for valid date, time string format
select dayofweek('2010-08-23 01:02:03.1234'), if (dayofweek('2010-08-23 01:02:03.1234') = 2, 'ok', 'nok');
select dayofweek('2010-08-23 01:02:03'), if (dayofweek('2010-08-23 01:02:03') = 2, 'ok', 'nok');
select dayofweek('2010-08-23'), if (dayofweek('2010-08-23') = 2, 'ok', 'nok');


-- test for valid current_*
select if (dayofweek(current_datetime)= CAST(date_format(current_datetime,'%w') AS INTEGER)+1, 'ok', 'nok');
select if (dayofweek(current_timestamp)= CAST(date_format(current_timestamp,'%w') AS INTEGER)+1, 'ok', 'nok');
select if (dayofweek(current_date)= CAST(date_format(current_date,'%w') AS INTEGER)+1, 'ok', 'nok');

-- test for normal case
select dayofweek('2010-08-01'), if (dayofweek('2010-08-01') = 1, 'ok', 'nok');
select dayofweek('2010-08-02'), if (dayofweek('2010-08-02') = 2, 'ok', 'nok');
select dayofweek('2010-08-03'), if (dayofweek('2010-08-03') = 3, 'ok', 'nok');
select dayofweek('2010-08-04'), if (dayofweek('2010-08-04') = 4, 'ok', 'nok');
select dayofweek('2010-08-05'), if (dayofweek('2010-08-05') = 5, 'ok', 'nok');
select dayofweek('2010-08-06'), if (dayofweek('2010-08-06') = 6, 'ok', 'nok');
select dayofweek('2010-08-07'), if (dayofweek('2010-08-07') = 7, 'ok', 'nok');

select dayofweek('2000-08-01'), if (dayofweek('2000-08-01') = 3, 'ok', 'nok');
select dayofweek('2000-08-02'), if (dayofweek('2000-08-02') = 4, 'ok', 'nok');
select dayofweek('2000-08-03'), if (dayofweek('2000-08-03') = 5, 'ok', 'nok');
select dayofweek('2000-08-04'), if (dayofweek('2000-08-04') = 6, 'ok', 'nok');
select dayofweek('2000-08-05'), if (dayofweek('2000-08-05') = 7, 'ok', 'nok');
select dayofweek('2000-08-06'), if (dayofweek('2000-08-06') = 1, 'ok', 'nok');
select dayofweek('2000-08-07'), if (dayofweek('2000-08-07') = 2, 'ok', 'nok');


-- test for special case
select dayofweek('2000-08-06'), if (dayofweek('2000-08-06') = 1, 'ok', 'nok');
select dayofweek(date'2000-08-06' - 1), if (dayofweek(date'2000-08-06' - 1) = 7, 'ok', 'nok');
select dayofweek('2000-08-05'), if (dayofweek('2000-08-05') = 7, 'ok', 'nok');
select dayofweek(date'2000-08-05' + 1), if (dayofweek(date'2000-08-05' + 1) = 1, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select dayofweek('2000-01-00 01:02:03');
select dayofweek('2000-12-32 01:02:03');
select dayofweek('1999-2-29 01:02:03');

select dayofweek('01:02:03');
commit;
--+ holdcas off;
