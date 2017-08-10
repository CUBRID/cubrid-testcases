--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';

select quarter('2010-01-01');

select quarter('2010-02-01');

select quarter('2010-03-01');

select quarter('2010-04-01');

select quarter('2010-05-01');

select quarter('2010-06-01');

select quarter('2010-07-01');

select quarter('2010-08-01');

select quarter('2010-09-01');

select quarter('2010-10-01');

select quarter('2010-11-01');

select quarter('2010-12-01');

select quarter('01/01/2010');

select quarter(str_to_date('12/25/1999', '%m/%d/%Y'));

select quarter('2010-01-01 12:20:00');

create table quarter_tests(char_col char(32), varchar_col varchar(32), 
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

insert into quarter_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,2,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11
10:49:51'),'1983-01-02 17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,23,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, quarter(char_col) from quarter_tests order by smallint_col;
select varchar_col, quarter(varchar_col) from quarter_tests order by smallint_col;
select string_col, quarter(string_col) from quarter_tests order by smallint_col;
select bit_col, quarter(bit_col) from quarter_tests order by smallint_col;
select integer_col, quarter(integer_col) from quarter_tests order by smallint_col;
select smallint_col, quarter(smallint_col) from quarter_tests order by smallint_col;
select bigint_col, quarter(bigint_col) from quarter_tests order by smallint_col;
select float_col, quarter(float_col) from quarter_tests order by smallint_col;
select double_col, quarter(double_col) from quarter_tests order by smallint_col;
select numeric_col, quarter(numeric_col) from quarter_tests order by smallint_col;
select monetary_col, quarter(monetary_col) from quarter_tests order by smallint_col;
select date_col, quarter(date_col) from quarter_tests order by smallint_col;
select time_col, quarter(time_col) from quarter_tests order by smallint_col;
select timestamp_col, quarter(timestamp_col) from quarter_tests order by smallint_col;
select datetime_col, quarter(datetime_col) from quarter_tests order by smallint_col;
select set_col, quarter(set_col) from quarter_tests order by smallint_col;


select * from quarter_tests where smallint_col = quarter('2010-01-02')+1 order by smallint_col;
select * from quarter_tests where smallint_col < quarter(varchar_col) order by smallint_col;

drop table quarter_tests;

create table t (col varchar(255)) partition by list (quarter(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table quarter_tests as select quarter('2010-01-02');

SELECT * FROM db_attribute where class_name='quarter_tests';

select * from quarter_tests;

drop table quarter_tests;

create view quarter_view(v) as select quarter('2010-01-02') from db_root;

select * from quarter_view;

drop quarter_view;

$varchar, $2009-01-01 20:18:32
select quarter(?) as rez;

$date, $1985-01-02
select quarter(?) as rez;

$datetime, $01/02/1985 12:13:15
select quarter(?) as rez;

$time, $12:23:15
select quarter(?) as rez;

$date, $1985-05-01
select 1 as rez from db_root where 2 = quarter(?);

$date, $1985-02-01
select 1 as rez from db_root where quarter(?) = 3;

-- test for valid date time format
select quarter(datetime'2003-12-31 01:02:03.1234'), if (quarter(datetime'2003-12-31 01:02:03.1234') = 4, 'ok', 'nok');
select quarter(timestamp'2003-12-31 01:02:03'), if (quarter(timestamp'2003-12-31 01:02:03') = 4, 'ok', 'nok');
select quarter(date'2003-12-31'), if (quarter(date'2003-12-31') = 4, 'ok', 'nok');


-- test for valid date, time string format
select quarter('2003-12-31 01:02:03.1234'), if (quarter('2003-12-31 01:02:03.1234') = 4, 'ok', 'nok');
select quarter('2003-12-31 01:02:03'), if (quarter('2003-12-31 01:02:03') = 4, 'ok', 'nok');
select quarter('2003-12-31'), if (quarter('2003-12-31') = 4, 'ok', 'nok');


-- test for valid current_*
select if (quarter(current_date) = (CAST(DATE_FORMAT(current_date,'%m') AS INTEGER) -1)/3 +1, 'ok', 'not ok');
select if (quarter(current_datetime) = (CAST(DATE_FORMAT(current_datetime,'%m') AS INTEGER) -1)/3 +1, 'ok', 'not ok');
select if (quarter(current_timestamp) = (CAST(DATE_FORMAT(current_timestamp,'%m') AS INTEGER) -1)/3 +1, 'ok', 'not ok');


-- test for special case
select quarter('1-1-1'), if (quarter('1-1-1') = 1, 'ok', 'nok');
select quarter('1/1/1'), if (quarter('1/1/1') = 1, 'ok', 'nok');
select quarter('2000-12-31'), if (quarter('2000-12-31') = 4, 'ok', 'nok');
select quarter(date'2000-12-31' + 1), if (quarter(date'2000-12-31' + 1) = 1, 'ok', 'nok');
select quarter(date'2000-1-1' - 1), if (quarter(date'2000-1-1' - 1) = 4, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select quarter('2000-01-00 01:02:03');
select quarter('2000-12-32 01:02:03');
select quarter('1999-2-29 01:02:03');

select quarter('01:02:03');

set system parameters 'return_null_on_function_errors = no';

select quarter('2010-01-01');

select quarter('2010-02-01');

select quarter('2010-03-01');

select quarter('2010-04-01');

select quarter('2010-05-01');

select quarter('2010-06-01');

select quarter('2010-07-01');

select quarter('2010-08-01');

select quarter('2010-09-01');

select quarter('2010-10-01');

select quarter('2010-11-01');

select quarter('2010-12-01');

select quarter('01/01/2010');

select quarter(str_to_date('12/25/1999', '%m/%d/%Y'));

select quarter('2010-01-01 12:20:00');

create table quarter_tests(char_col char(32), varchar_col varchar(32), 
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

insert into quarter_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,2,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11
10:49:51'),'1983-01-02 17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,23,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, quarter(char_col) from quarter_tests order by smallint_col;
select varchar_col, quarter(varchar_col) from quarter_tests order by smallint_col;
select string_col, quarter(string_col) from quarter_tests order by smallint_col;
select bit_col, quarter(bit_col) from quarter_tests order by smallint_col;
select integer_col, quarter(integer_col) from quarter_tests order by smallint_col;
select smallint_col, quarter(smallint_col) from quarter_tests order by smallint_col;
select bigint_col, quarter(bigint_col) from quarter_tests order by smallint_col;
select float_col, quarter(float_col) from quarter_tests order by smallint_col;
select double_col, quarter(double_col) from quarter_tests order by smallint_col;
select numeric_col, quarter(numeric_col) from quarter_tests order by smallint_col;
select monetary_col, quarter(monetary_col) from quarter_tests order by smallint_col;
select date_col, quarter(date_col) from quarter_tests order by smallint_col;
select time_col, quarter(time_col) from quarter_tests order by smallint_col;
select timestamp_col, quarter(timestamp_col) from quarter_tests order by smallint_col;
select datetime_col, quarter(datetime_col) from quarter_tests order by smallint_col;
select set_col, quarter(set_col) from quarter_tests order by smallint_col;


select * from quarter_tests where smallint_col = quarter('2010-01-02')+1 order by smallint_col;
select * from quarter_tests where smallint_col < quarter(varchar_col) order by smallint_col;

drop table quarter_tests;

create table t (col varchar(255)) partition by list (quarter(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table quarter_tests as select quarter('2010-01-02');

SELECT * FROM db_attribute where class_name='quarter_tests';

select * from quarter_tests;

drop table quarter_tests;

create view quarter_view(v) as select quarter('2010-01-02') from db_root;

select * from quarter_view;

drop quarter_view;

$varchar, $2009-01-01 20:18:32
select quarter(?) as rez;

$date, $1985-01-02
select quarter(?) as rez;

$datetime, $01/02/1985 12:13:15
select quarter(?) as rez;

$time, $12:23:15
select quarter(?) as rez;

$date, $1985-05-01
select 1 as rez from db_root where 2 = quarter(?);

$date, $1985-02-01
select 1 as rez from db_root where quarter(?) = 3;

-- test for valid date time format
select quarter(datetime'2003-12-31 01:02:03.1234'), if (quarter(datetime'2003-12-31 01:02:03.1234') = 4, 'ok', 'nok');
select quarter(timestamp'2003-12-31 01:02:03'), if (quarter(timestamp'2003-12-31 01:02:03') = 4, 'ok', 'nok');
select quarter(date'2003-12-31'), if (quarter(date'2003-12-31') = 4, 'ok', 'nok');


-- test for valid date, time string format
select quarter('2003-12-31 01:02:03.1234'), if (quarter('2003-12-31 01:02:03.1234') = 4, 'ok', 'nok');
select quarter('2003-12-31 01:02:03'), if (quarter('2003-12-31 01:02:03') = 4, 'ok', 'nok');
select quarter('2003-12-31'), if (quarter('2003-12-31') = 4, 'ok', 'nok');


-- test for valid current_*
select if (quarter(current_date) = (CAST(DATE_FORMAT(current_date,'%m') AS INTEGER) -1)/3 +1, 'ok', 'not ok');
select if (quarter(current_datetime) = (CAST(DATE_FORMAT(current_datetime,'%m') AS INTEGER) -1)/3 +1, 'ok', 'not ok');
select if (quarter(current_timestamp) = (CAST(DATE_FORMAT(current_timestamp,'%m') AS INTEGER) -1)/3 +1, 'ok', 'not ok');


-- test for special case
select quarter('1-1-1'), if (quarter('1-1-1') = 1, 'ok', 'nok');
select quarter('1/1/1'), if (quarter('1/1/1') = 1, 'ok', 'nok');
select quarter('2000-12-31'), if (quarter('2000-12-31') = 4, 'ok', 'nok');
select quarter(date'2000-12-31' + 1), if (quarter(date'2000-12-31' + 1) = 1, 'ok', 'nok');
select quarter(date'2000-1-1' - 1), if (quarter(date'2000-1-1' - 1) = 4, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select quarter('2000-01-00 01:02:03');
select quarter('2000-12-32 01:02:03');
select quarter('1999-2-29 01:02:03');

select quarter('01:02:03');
commit;
--+ holdcas off;
