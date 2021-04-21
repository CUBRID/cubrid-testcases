--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select date_format('2000-01-03', '%W'), weekday('2000-01-03');

select date_format('2000-01-04', '%W'), weekday('2000-01-04');

select date_format('2000-01-05', '%W'), weekday('2000-01-05');

select date_format('2000-01-06', '%W'), weekday('2000-01-06');

select date_format('2000-01-07', '%W'), weekday('2000-01-07');

select date_format('2000-01-08', '%W'), weekday('2000-01-08');

select date_format('2000-01-09', '%W'), weekday('2000-01-09');

select date_format('01/01/2010', '%W'), weekday('01/01/2010');

select date_format(str_to_date('12/25/1999', '%m/%d/%Y'), '%W'), weekday(str_to_date('12/25/1999', '%m/%d/%Y'));

select date_format('2010-01-01 12:20:00', '%W'), weekday('2010-01-01 12:20:00');

create table weekday_tests(char_col char(32), varchar_col varchar(32), 
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

insert into weekday_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,6,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,2,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, weekday(char_col) from weekday_tests order by smallint_col;
select varchar_col, weekday(varchar_col) from weekday_tests order by smallint_col;
select string_col, weekday(string_col) from weekday_tests order by smallint_col;
select bit_col, weekday(bit_col) from weekday_tests order by smallint_col;
select integer_col, weekday(integer_col) from weekday_tests order by smallint_col;
select smallint_col, weekday(smallint_col) from weekday_tests order by smallint_col;
select bigint_col, weekday(bigint_col) from weekday_tests order by smallint_col;
--select float_col, weekday(float_col) from weekday_tests order by smallint_col;
 select float_col, if(weekday(float_col)=weekday(concat(year(sysdate),'-12-25')),'ok','nok') from weekday_tests order by smallint_col;
select double_col, weekday(double_col) from weekday_tests order by smallint_col;
--select numeric_col, weekday(numeric_col) from weekday_tests order by smallint_col;
select numeric_col, if(weekday(numeric_col)=weekday(concat(year(sysdate),'-11-12')),'ok','nok') from weekday_tests order by smallint_col;
select monetary_col, weekday(monetary_col) from weekday_tests order by smallint_col;
select date_col, weekday(date_col) from weekday_tests order by smallint_col;
select time_col, weekday(time_col) from weekday_tests order by smallint_col;
select timestamp_col, weekday(timestamp_col) from weekday_tests order by smallint_col;
select datetime_col, weekday(datetime_col) from weekday_tests order by smallint_col;
select set_col, weekday(set_col) from weekday_tests order by smallint_col;


select * from weekday_tests where smallint_col = weekday('2010-01-02')+1 order by smallint_col;
select * from weekday_tests where smallint_col < weekday(varchar_col) order by smallint_col;

drop table weekday_tests;

create table t (col varchar(255)) partition by list (weekday(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table weekday_tests as select weekday('2010-01-02') as [ weekday('2010-01-02')];

SELECT * FROM db_attribute where class_name='weekday_tests';

select * from weekday_tests;

drop table weekday_tests;

create view weekday_view(v) as select weekday('2010-01-02') from db_root;

select * from weekday_view;

drop weekday_view;

$varchar, $2009-01-01 20:18:32
select weekday(?) as rez;

$date, $1985-01-02
select weekday(?) as rez;

$datetime, $01/02/1985 12:13:15
select weekday(?) as rez;

$time, $12:23:15
select weekday(?) as rez;

$date, $1985-04-05
select 1 as rez from db_root where 4 = weekday(?);

$datetime, $01/03/1985
select 1 as rez from db_root where weekday(?) = 4;

-- test for valid date time format
select weekday(datetime'2003-08-23 01:02:03.1234'), if (weekday(datetime'2010-08-23 01:02:03.1234') = 0, 'ok', 'nok');
select weekday(timestamp'2010-08-23 01:02:03'), if (weekday(timestamp'2010-08-23 01:02:03') = 0, 'ok', 'nok');
select weekday(date'2010-08-23'), if (weekday(date'2010-08-23') = 0, 'ok', 'nok');


-- test for valid date, time string format
select weekday('2010-08-23 01:02:03.1234'), if (weekday('2010-08-23 01:02:03.1234') = 0, 'ok', 'nok');
select weekday('2010-08-23 01:02:03'), if (weekday('2010-08-23 01:02:03') = 0, 'ok', 'nok');
select weekday('2010-08-23'), if (weekday('2010-08-23') = 0, 'ok', 'nok');


-- test for valid current_*
select if ((weekday(current_datetime) + 1)%7 = CAST(date_format(current_datetime,'%w') AS INTEGER), 'ok', 'nok');
select if ((weekday(current_timestamp) + 1)%7 = CAST(date_format(current_timestamp,'%w') AS INTEGER), 'ok', 'nok');
select if ((weekday(current_date) + 1)%7 = CAST(date_format(current_date,'%w') AS INTEGER), 'ok', 'nok');

-- test for normal case
select weekday('2010-08-01'), if (weekday('2010-08-01') = 6, 'ok', 'nok');
select weekday('2010-08-02'), if (weekday('2010-08-02') = 0, 'ok', 'nok');
select weekday('2010-08-03'), if (weekday('2010-08-03') = 1, 'ok', 'nok');
select weekday('2010-08-04'), if (weekday('2010-08-04') = 2, 'ok', 'nok');
select weekday('2010-08-05'), if (weekday('2010-08-05') = 3, 'ok', 'nok');
select weekday('2010-08-05'), if (weekday('2010-08-06') = 4, 'ok', 'nok');
select weekday('2010-08-07'), if (weekday('2010-08-07') = 5, 'ok', 'nok');

select weekday('2000-08-01'), if (weekday('2000-08-01') = 1, 'ok', 'nok');
select weekday('2000-08-02'), if (weekday('2000-08-02') = 2, 'ok', 'nok');
select weekday('2000-08-03'), if (weekday('2000-08-03') = 3, 'ok', 'nok');
select weekday('2000-08-04'), if (weekday('2000-08-04') = 4, 'ok', 'nok');
select weekday('2000-08-05'), if (weekday('2000-08-05') = 5, 'ok', 'nok');
select weekday('2000-08-05'), if (weekday('2000-08-06') = 6, 'ok', 'nok');
select weekday('2000-08-07'), if (weekday('2000-08-07') = 0, 'ok', 'nok');


-- test for special case
select weekday('2000-08-07'), if (weekday('2000-08-07') = 0, 'ok', 'nok');
select weekday(date'2000-08-07' - 1), if (weekday(date'2000-08-07' - 1) = 6, 'ok', 'nok');
select weekday('2000-08-05'), if (weekday('2000-08-06') = 6, 'ok', 'nok');
select weekday(date'2000-08-05' + 1), if (weekday(date'2000-08-06' + 1) = 0, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select weekday('2000-01-00 01:02:03');
select weekday('2000-12-32 01:02:03');
select weekday('1999-2-29 01:02:03');

select weekday('01:02:03');

set system parameters 'return_null_on_function_errors = no';
select date_format('2000-01-03', '%W'), weekday('2000-01-03');

select date_format('2000-01-04', '%W'), weekday('2000-01-04');

select date_format('2000-01-05', '%W'), weekday('2000-01-05');

select date_format('2000-01-06', '%W'), weekday('2000-01-06');

select date_format('2000-01-07', '%W'), weekday('2000-01-07');

select date_format('2000-01-08', '%W'), weekday('2000-01-08');

select date_format('2000-01-09', '%W'), weekday('2000-01-09');

select date_format('01/01/2010', '%W'), weekday('01/01/2010');

select date_format(str_to_date('12/25/1999', '%m/%d/%Y'), '%W'), weekday(str_to_date('12/25/1999', '%m/%d/%Y'));

select date_format('2010-01-01 12:20:00', '%W'), weekday('2010-01-01 12:20:00');

create table weekday_tests(char_col char(32), varchar_col varchar(32), 
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

insert into weekday_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,6,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,2,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, weekday(char_col) from weekday_tests order by smallint_col;
select varchar_col, weekday(varchar_col) from weekday_tests order by smallint_col;
select string_col, weekday(string_col) from weekday_tests order by smallint_col;
select bit_col, weekday(bit_col) from weekday_tests order by smallint_col;
select integer_col, weekday(integer_col) from weekday_tests order by smallint_col;
select smallint_col, weekday(smallint_col) from weekday_tests order by smallint_col;
select bigint_col, weekday(bigint_col) from weekday_tests order by smallint_col;
--select float_col, weekday(float_col) from weekday_tests order by smallint_col;
select float_col, if(weekday(float_col)=weekday(concat(year(sysdate),'-12-25')),'ok','nok') from weekday_tests order by smallint_col;
select double_col, weekday(double_col) from weekday_tests order by smallint_col;
--select numeric_col, weekday(numeric_col) from weekday_tests order by smallint_col;
select numeric_col, if(weekday(numeric_col)=weekday(concat(year(sysdate),'-11-12')),'ok','nok') from weekday_tests order by smallint_col;
select monetary_col, weekday(monetary_col) from weekday_tests order by smallint_col;
select date_col, weekday(date_col) from weekday_tests order by smallint_col;
select time_col, weekday(time_col) from weekday_tests order by smallint_col;
select timestamp_col, weekday(timestamp_col) from weekday_tests order by smallint_col;
select datetime_col, weekday(datetime_col) from weekday_tests order by smallint_col;
select set_col, weekday(set_col) from weekday_tests order by smallint_col;


select * from weekday_tests where smallint_col = weekday('2010-01-02')+1 order by smallint_col;
select * from weekday_tests where smallint_col < weekday(varchar_col) order by smallint_col;

drop table weekday_tests;

create table t (col varchar(255)) partition by list (weekday(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table weekday_tests as select weekday('2010-01-02') as [ weekday('2010-01-02')];

SELECT * FROM db_attribute where class_name='weekday_tests';

select * from weekday_tests;

drop table weekday_tests;

create view weekday_view(v) as select weekday('2010-01-02') from db_root;

select * from weekday_view;

drop weekday_view;

$varchar, $2009-01-01 20:18:32
select weekday(?) as rez;

$date, $1985-01-02
select weekday(?) as rez;

$datetime, $01/02/1985 12:13:15
select weekday(?) as rez;

$time, $12:23:15
select weekday(?) as rez;

$date, $1985-04-05
select 1 as rez from db_root where 4 = weekday(?);

$datetime, $01/03/1985
select 1 as rez from db_root where weekday(?) = 4;

-- test for valid date time format
select weekday(datetime'2003-08-23 01:02:03.1234'), if (weekday(datetime'2010-08-23 01:02:03.1234') = 0, 'ok', 'nok');
select weekday(timestamp'2010-08-23 01:02:03'), if (weekday(timestamp'2010-08-23 01:02:03') = 0, 'ok', 'nok');
select weekday(date'2010-08-23'), if (weekday(date'2010-08-23') = 0, 'ok', 'nok');


-- test for valid date, time string format
select weekday('2010-08-23 01:02:03.1234'), if (weekday('2010-08-23 01:02:03.1234') = 0, 'ok', 'nok');
select weekday('2010-08-23 01:02:03'), if (weekday('2010-08-23 01:02:03') = 0, 'ok', 'nok');
select weekday('2010-08-23'), if (weekday('2010-08-23') = 0, 'ok', 'nok');


-- test for valid current_*
select if ((weekday(current_datetime) + 1)%7 = CAST(date_format(current_datetime,'%w') AS INTEGER), 'ok', 'nok');
select if ((weekday(current_timestamp) + 1)%7 = CAST(date_format(current_timestamp,'%w') AS INTEGER), 'ok', 'nok');
select if ((weekday(current_date) + 1)%7 = CAST(date_format(current_date,'%w') AS INTEGER), 'ok', 'nok');

-- test for normal case
select weekday('2010-08-01'), if (weekday('2010-08-01') = 6, 'ok', 'nok');
select weekday('2010-08-02'), if (weekday('2010-08-02') = 0, 'ok', 'nok');
select weekday('2010-08-03'), if (weekday('2010-08-03') = 1, 'ok', 'nok');
select weekday('2010-08-04'), if (weekday('2010-08-04') = 2, 'ok', 'nok');
select weekday('2010-08-05'), if (weekday('2010-08-05') = 3, 'ok', 'nok');
select weekday('2010-08-05'), if (weekday('2010-08-06') = 4, 'ok', 'nok');
select weekday('2010-08-07'), if (weekday('2010-08-07') = 5, 'ok', 'nok');

select weekday('2000-08-01'), if (weekday('2000-08-01') = 1, 'ok', 'nok');
select weekday('2000-08-02'), if (weekday('2000-08-02') = 2, 'ok', 'nok');
select weekday('2000-08-03'), if (weekday('2000-08-03') = 3, 'ok', 'nok');
select weekday('2000-08-04'), if (weekday('2000-08-04') = 4, 'ok', 'nok');
select weekday('2000-08-05'), if (weekday('2000-08-05') = 5, 'ok', 'nok');
select weekday('2000-08-05'), if (weekday('2000-08-06') = 6, 'ok', 'nok');
select weekday('2000-08-07'), if (weekday('2000-08-07') = 0, 'ok', 'nok');


-- test for special case
select weekday('2000-08-07'), if (weekday('2000-08-07') = 0, 'ok', 'nok');
select weekday(date'2000-08-07' - 1), if (weekday('2000-08-07' - 1) = 6, 'ok', 'nok');
select weekday('2000-08-05'), if (weekday('2000-08-06') = 6, 'ok', 'nok');
select weekday(date'2000-08-05' + 1), if (weekday(date'2000-08-06' + 1) = 0, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select weekday('2000-01-00 01:02:03');
select weekday('2000-12-32 01:02:03');
select weekday('1999-2-29 01:02:03');

select weekday('01:02:03');

commit;
--+ holdcas off;
