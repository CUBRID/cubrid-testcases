--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';

select day('2010-01-01');

select day('01/01/2010');

select day(str_to_date('12/25/1999', '%m/%d/%Y'));

select day('2010-01-01 12:20:00');

create table day_tests(char_col char(32), varchar_col varchar(32), 
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

insert into day_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,1,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, day(char_col) from day_tests order by smallint_col;
select varchar_col, day(varchar_col) from day_tests order by smallint_col;
select string_col, day(string_col) from day_tests order by smallint_col;
select bit_col, day(bit_col) from day_tests order by smallint_col;
select integer_col, day(integer_col) from day_tests order by smallint_col;
select smallint_col, day(smallint_col) from day_tests order by smallint_col;
select bigint_col, day(bigint_col) from day_tests order by smallint_col;
select float_col, day(float_col) from day_tests order by smallint_col;
select double_col, day(double_col) from day_tests order by smallint_col;
select numeric_col, day(numeric_col) from day_tests order by smallint_col;
select monetary_col, day(monetary_col) from day_tests order by smallint_col;
select date_col, day(date_col) from day_tests order by smallint_col;
select time_col, day(time_col) from day_tests order by smallint_col;
select timestamp_col, day(timestamp_col) from day_tests order by smallint_col;
select datetime_col, day(datetime_col) from day_tests order by smallint_col;
select set_col, day(set_col) from day_tests order by smallint_col;


select * from day_tests where smallint_col < day(varchar_col) order by smallint_col;
select * from day_tests where smallint_col = day('2010-01-02')-1 order by smallint_col;

drop table day_tests;

create table t (col varchar(255)) partition by list (day(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table day_tests as select day('2010-01-02') as [ day('2010-01-02')];

SELECT * FROM db_attribute where class_name='day_tests';

select * from day_tests;

drop table day_tests;

create view day_view(v) as select day('2010-01-02') as [ day('2010-01-02')] from db_root;

select * from day_view;

drop day_view;

$varchar, $2009-01-01 20:18:32
select day(?) as rez;

$varchar, $2009-01-01 20:18:32
select day(?) as rez;

$date, $1985-01-02
select day(?) as rez;

$datetime, $01/02/1985 12:13:15
select day(?) as rez;

--wrong type of hostvar
$int, $12
select day(?) as rez;

--wrong string format
$varchar, $2010
select day(?) as rez;

-- test for valid date time format
select day(datetime'2003-12-31 01:02:03.1234'), if (day(datetime'2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select day(timestamp'2003-12-31 01:02:03'), if (day(timestamp'2003-12-31 01:02:03') = 31, 'ok', 'nok');
select day(date'2003-12-31'), if (day(date'2003-12-31') = 31, 'ok', 'nok');


-- test for valid date, time string format
select day('2003-12-31 01:02:03.1234'), if (day('2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select day('2003-12-31 01:02:03'), if (day('2003-12-31 01:02:03') = 31, 'ok', 'nok');
select day('2003-12-31'), if (day('2003-12-31') = 31, 'ok', 'nok');


-- test for valid current_*
SELECT if(day(current_date) = CAST(DATE_FORMAT(current_date,'%e') AS INTEGER),'ok','not ok');
SELECT if(day(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%e') AS INTEGER),'ok','not ok');
SELECT if(day(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%e') AS INTEGER),'ok','not ok');

-- test for special case
select day('1-1-1'), if (day('1-1-1') = 1, 'ok', 'nok');
select day('1/1/1'), if (day('1/1/1') = 1, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is returned.
select day('2000-01-00 01:02:03');
select day('2000-12-32 01:02:03');
select day('1999-2-29 01:02:03');

select day('01:02:03');

set system parameters 'return_null_on_function_errors = no';
select day('2010-01-01');

select day('01/01/2010');

select day(str_to_date('12/25/1999', '%m/%d/%Y'));

select day('2010-01-01 12:20:00');

create table day_tests(char_col char(32), varchar_col varchar(32), 
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

insert into day_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,1,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, day(char_col) from day_tests order by smallint_col;
select varchar_col, day(varchar_col) from day_tests order by smallint_col;
select string_col, day(string_col) from day_tests order by smallint_col;
select bit_col, day(bit_col) from day_tests order by smallint_col;
select integer_col, day(integer_col) from day_tests order by smallint_col;
select smallint_col, day(smallint_col) from day_tests order by smallint_col;
select bigint_col, day(bigint_col) from day_tests order by smallint_col;
select float_col, day(float_col) from day_tests order by smallint_col;
select double_col, day(double_col) from day_tests order by smallint_col;
select numeric_col, day(numeric_col) from day_tests order by smallint_col;
select monetary_col, day(monetary_col) from day_tests order by smallint_col;
select date_col, day(date_col) from day_tests order by smallint_col;
select time_col, day(time_col) from day_tests order by smallint_col;
select timestamp_col, day(timestamp_col) from day_tests order by smallint_col;
select datetime_col, day(datetime_col) from day_tests order by smallint_col;
select set_col, day(set_col) from day_tests order by smallint_col;


select * from day_tests where smallint_col < day(varchar_col) order by smallint_col;
select * from day_tests where smallint_col = day('2010-01-02')-1 order by smallint_col;

drop table day_tests;

create table t (col varchar(255)) partition by list (day(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table day_tests as select day('2010-01-02') as [ day('2010-01-02')];

SELECT * FROM db_attribute where class_name='day_tests';

select * from day_tests;

drop table day_tests;

create view day_view(v) as select day('2010-01-02') from db_root;

select * from day_view;

drop day_view;

$varchar, $2009-01-01 20:18:32
select day(?) as rez;

$varchar, $2009-01-01 20:18:32
select day(?) as rez;

$date, $1985-01-02
select day(?) as rez;

$datetime, $01/02/1985 12:13:15
select day(?) as rez;

--wrong type of hostvar
$int, $12
select day(?) as rez;

--wrong string format
$varchar, $2010
select day(?) as rez;

-- test for valid date time format
select day(datetime'2003-12-31 01:02:03.1234'), if (day(datetime'2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select day(timestamp'2003-12-31 01:02:03'), if (day(timestamp'2003-12-31 01:02:03') = 31, 'ok', 'nok');
select day(date'2003-12-31'), if (day(date'2003-12-31') = 31, 'ok', 'nok');


-- test for valid date, time string format
select day('2003-12-31 01:02:03.1234'), if (day('2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select day('2003-12-31 01:02:03'), if (day('2003-12-31 01:02:03') = 31, 'ok', 'nok');
select day('2003-12-31'), if (day('2003-12-31') = 31, 'ok', 'nok');


-- test for valid current_*
SELECT if(day(current_date) = CAST(DATE_FORMAT(current_date,'%e') AS INTEGER),'ok','not ok');
SELECT if(day(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%e') AS INTEGER),'ok','not ok');
SELECT if(day(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%e') AS INTEGER),'ok','not ok');

-- test for special case
select day('1-1-1'), if (day('1-1-1') = 1, 'ok', 'nok');
select day('1/1/1'), if (day('1/1/1') = 1, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is returned.
select day('2000-01-00 01:02:03');
select day('2000-12-32 01:02:03');
select day('1999-2-29 01:02:03');

select day('01:02:03');
commit;
--+ holdcas off;
